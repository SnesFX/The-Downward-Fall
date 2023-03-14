using System.Collections;
using UnityEngine;

[DisallowMultipleComponent]
public class ViveGrip_ControllerHandler : MonoBehaviour
{
	public enum ViveInput
	{
		Grip = 0,
		Trigger = 1,
		Both = 2,
		None = 3
	}

	public enum Action
	{
		Grab = 0,
		Interact = 1
	}

	[Tooltip("The device that will be giving the input.")]
	public SteamVR_TrackedObject trackedObject;

	[Tooltip("The button used for gripping.")]
	public ViveInput grabInput;

	[Tooltip("The button used for interacting.")]
	public ViveInput interactInput = ViveInput.Trigger;

	private bool gripOrTriggerHeld;

	private bool gripOrTriggerPressed;

	private int deviceIndex = -1;

	private const float MAX_VIBRATION_STRENGTH = 3999f;

	private void Start()
	{
		if ((bool)trackedObject)
		{
			deviceIndex = (int)trackedObject.index;
		}
	}

	private void Update()
	{
		if (Device() != null)
		{
			if (InputPerformed(ViveInput.Grip, Device().GetPress) || InputPerformed(ViveInput.Trigger, Device().GetPress))
			{
				gripOrTriggerPressed = !gripOrTriggerHeld;
				gripOrTriggerHeld = true;
			}
			if (!InputPerformed(ViveInput.Grip, Device().GetPress) && !InputPerformed(ViveInput.Trigger, Device().GetPress))
			{
				gripOrTriggerPressed = false;
				gripOrTriggerHeld = false;
			}
		}
	}

	private void OnHandInitialized(int index)
	{
		deviceIndex = index;
	}

	public bool Pressed(Action action)
	{
		if (Device() == null)
		{
			return false;
		}
		ViveInput input = InputFor(action);
		return InputPerformed(input, Device().GetPressDown);
	}

	public bool Released(Action action)
	{
		if (Device() == null)
		{
			return false;
		}
		ViveInput input = InputFor(action);
		return InputPerformed(input, Device().GetPressUp);
	}

	public bool Holding(Action action)
	{
		if (Device() == null)
		{
			return false;
		}
		ViveInput input = InputFor(action);
		return InputPerformed(input, Device().GetPress);
	}

	private ViveInput InputFor(Action action)
	{
		switch (action)
		{
		case Action.Grab:
			return grabInput;
		case Action.Interact:
			return interactInput;
		default:
			return ViveInput.None;
		}
	}

	private bool InputPerformed(ViveInput input, InputFunction func)
	{
		switch (input)
		{
		case ViveInput.Grip:
			return func(ButtonMaskFor(ViveInput.Grip));
		case ViveInput.Trigger:
			return func(ButtonMaskFor(ViveInput.Trigger));
		case ViveInput.Both:
			return BothInputPerformed(func);
		default:
			return false;
		}
	}

	private bool BothInputPerformed(InputFunction func)
	{
		switch (func.Method.Name)
		{
		case "GetPressDown":
			return gripOrTriggerPressed;
		case "GetPress":
			return gripOrTriggerHeld;
		case "GetPressUp":
			return !gripOrTriggerHeld;
		default:
			return false;
		}
	}

	private ulong ButtonMaskFor(ViveInput input)
	{
		switch (input)
		{
		case ViveInput.Grip:
			return 4uL;
		case ViveInput.Trigger:
			return 8589934592uL;
		case ViveInput.Both:
			return 4294967296uL;
		default:
			return 2uL;
		}
	}

	public SteamVR_Controller.Device Device()
	{
		if (deviceIndex == -1)
		{
			return null;
		}
		if (deviceIndex == -1)
		{
			return null;
		}
		return SteamVR_Controller.Input(deviceIndex);
	}

	public void Vibrate(int milliseconds, float strength)
	{
		float length = (float)milliseconds / 1000f;
		StartCoroutine(LongVibration(length, strength));
	}

	private IEnumerator LongVibration(float length, float strength)
	{
		for (float i = 0f; i < length; i += Time.deltaTime)
		{
			if (Device() != null)
			{
				ushort durationMicroSec = (ushort)Mathf.Lerp(0f, 3999f, strength);
				Device().TriggerHapticPulse(durationMicroSec);
			}
			yield return null;
		}
	}

	public GameObject TrackedObject()
	{
		if (trackedObject == null)
		{
			return base.transform.parent.gameObject;
		}
		return trackedObject.gameObject;
	}
}
