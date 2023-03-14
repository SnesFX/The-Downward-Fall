using UnityEngine;
using UnityEngine.Rendering;

[DisallowMultipleComponent]
public class ViveGrip_GripPoint : MonoBehaviour
{
	[Tooltip("The distance at which you can touch objects.")]
	public float touchRadius = 0.2f;

	[Tooltip("The distance at which objects will automatically drop.\nUse UpdateRadius to modify in code.")]
	public float holdRadius = 0.3f;

	[Tooltip("Is the touch radius visible? (Good for debugging)")]
	public bool visible;

	[Tooltip("Should the button toggle grabbing?")]
	public bool inputIsToggle;

	[HideInInspector]
	public ViveGrip_ControllerHandler controller;

	[HideInInspector]
	public ViveGrip_Grabber grabber;

	public const string GRIP_SPHERE_NAME = "ViveGrip Touch Sphere";

	private ViveGrip_TouchDetection touch;

	private bool firmlyGrabbed;

	private bool externalGrabTriggered;

	private GameObject lastTouchedObject;

	private GameObject lastInteractedObject;

	private void Start()
	{
		grabber = base.gameObject.AddComponent<ViveGrip_Grabber>();
		GameObject gameObject = InstantiateTouchSphere();
		touch = gameObject.AddComponent<ViveGrip_TouchDetection>();
		UpdateRadius(touchRadius, holdRadius);
	}

	private void Update()
	{
		CheckController();
		GameObject givenObject = TouchedObject();
		HandleTouching(givenObject);
		HandleGrabbing(givenObject);
		HandleInteraction(givenObject);
		HandleFumbling();
		lastTouchedObject = givenObject;
	}

	private void CheckController()
	{
		if (!(controller != null))
		{
			controller = GetComponent<ViveGrip_ControllerHandler>();
		}
	}

	private void HandleGrabbing(GameObject givenObject)
	{
		if (!GrabTriggered() && !externalGrabTriggered)
		{
			return;
		}
		externalGrabTriggered = false;
		if (grabber.HoldingSomething())
		{
			if (givenObject != null)
			{
				Message("ViveGripHighlightStart", givenObject);
			}
			DestroyConnection();
		}
		else if (givenObject != null && givenObject.GetComponent<ViveGrip_Grabbable>() != null)
		{
			Message("ViveGripGrabStart", givenObject);
			Message("ViveGripHighlightStop", givenObject);
		}
	}

	private bool GrabTriggered()
	{
		if (controller == null)
		{
			return false;
		}
		if (inputIsToggle)
		{
			return controller.Pressed(ViveGrip_ControllerHandler.Action.Grab);
		}
		return (!grabber.HoldingSomething()) ? controller.Pressed(ViveGrip_ControllerHandler.Action.Grab) : controller.Released(ViveGrip_ControllerHandler.Action.Grab);
	}

	private void DestroyConnection()
	{
		firmlyGrabbed = false;
		Message("ViveGripGrabStop", HeldObject());
	}

	private void HandleFumbling()
	{
		if (grabber.HoldingSomething())
		{
			float num = CalculateGrabDistance();
			bool flag = num <= holdRadius;
			firmlyGrabbed = firmlyGrabbed || flag;
			if (firmlyGrabbed && !flag)
			{
				DestroyConnection();
			}
		}
	}

	private float CalculateGrabDistance()
	{
		ViveGrip_Grabbable component = grabber.ConnectedGameObject().GetComponent<ViveGrip_Grabbable>();
		Vector3 b = component.WorldAnchorPosition();
		return Vector3.Distance(base.transform.position, b);
	}

	private void HandleInteraction(GameObject givenObject)
	{
		if (grabber.HoldingSomething())
		{
			givenObject = grabber.ConnectedGameObject();
		}
		if (!(givenObject == null) && !(givenObject.GetComponent<ViveGrip_Interactable>() == null))
		{
			if (controller.Pressed(ViveGrip_ControllerHandler.Action.Interact))
			{
				lastInteractedObject = givenObject;
				Message("ViveGripInteractionStart", givenObject);
			}
			if (controller.Released(ViveGrip_ControllerHandler.Action.Interact))
			{
				Message("ViveGripInteractionStop", lastInteractedObject);
				lastInteractedObject = null;
			}
		}
	}

	private void HandleTouching(GameObject givenObject)
	{
		if (!GameObjectsEqual(lastTouchedObject, givenObject))
		{
			if (lastTouchedObject != null)
			{
				Message("ViveGripTouchStop", lastTouchedObject);
				Message("ViveGripHighlightStop", lastTouchedObject);
			}
			if (!grabber.HoldingSomething() && givenObject != null)
			{
				Message("ViveGripTouchStart", givenObject);
				Message("ViveGripHighlightStart", givenObject);
			}
		}
	}

	private bool GameObjectsEqual(GameObject first, GameObject second)
	{
		if (first == null && second == null)
		{
			return true;
		}
		if (first == null || second == null)
		{
			return false;
		}
		return first.GetInstanceID() == second.GetInstanceID();
	}

	private GameObject InstantiateTouchSphere()
	{
		GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Sphere);
		Renderer component = gameObject.GetComponent<Renderer>();
		component.enabled = visible;
		if (visible)
		{
			component.material = new Material(Shader.Find("ViveGrip/TouchSphere"));
			component.shadowCastingMode = ShadowCastingMode.Off;
			component.receiveShadows = false;
		}
		gameObject.transform.localScale = Vector3.one;
		gameObject.transform.position = base.transform.position;
		gameObject.transform.SetParent(base.transform);
		gameObject.AddComponent<Rigidbody>().isKinematic = true;
		gameObject.layer = base.gameObject.layer;
		gameObject.name = "ViveGrip Touch Sphere";
		return gameObject;
	}

	public bool TouchingSomething()
	{
		return TouchedObject() != null;
	}

	public GameObject TouchedObject()
	{
		if (touch == null)
		{
			return null;
		}
		return touch.NearestObject();
	}

	public bool HoldingSomething()
	{
		if (grabber == null)
		{
			return false;
		}
		return grabber.HoldingSomething();
	}

	public GameObject HeldObject()
	{
		if (grabber == null)
		{
			return null;
		}
		if (!grabber.HoldingSomething())
		{
			return null;
		}
		return grabber.ConnectedGameObject();
	}

	public void ToggleGrab()
	{
		externalGrabTriggered = true;
	}

	public GameObject TrackedObject()
	{
		return controller.TrackedObject();
	}

	public void UpdateRadius(float touch, float hold)
	{
		this.touch.transform.localScale = Vector3.one * touch;
		holdRadius = hold;
	}

	private void Message(string name, GameObject objectToMessage)
	{
		TrackedObject().BroadcastMessage(name, this, SendMessageOptions.DontRequireReceiver);
		if (!(objectToMessage == null))
		{
			objectToMessage.SendMessage(name, this, SendMessageOptions.DontRequireReceiver);
		}
	}

	private void OnDisable()
	{
		if (TouchingSomething())
		{
			ViveGrip_Highlighter component = TouchedObject().GetComponent<ViveGrip_Highlighter>();
			if (!(component == null))
			{
				component.RemoveHighlight();
			}
		}
	}

	private void OnEnable()
	{
		if (TouchingSomething())
		{
			ViveGrip_Highlighter component = TouchedObject().GetComponent<ViveGrip_Highlighter>();
			if (!(component == null))
			{
				component.Highlight();
			}
		}
	}
}
