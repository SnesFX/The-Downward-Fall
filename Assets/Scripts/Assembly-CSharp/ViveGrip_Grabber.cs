using UnityEngine;

public class ViveGrip_Grabber : MonoBehaviour
{
	public GameObject jointObject;

	public ConfigurableJoint joint;

	private void Start()
	{
	}

	private void ViveGripGrabStart(ViveGrip_GripPoint gripPoint)
	{
		if (base.enabled)
		{
			jointObject = InstantiateJointParent();
			GrabWith(gripPoint);
		}
	}

	private void ViveGripGrabStop(ViveGrip_GripPoint gripPoint)
	{
		if (base.enabled)
		{
			Object.Destroy(jointObject);
		}
	}

	private void GrabWith(ViveGrip_GripPoint gripPoint)
	{
		Rigidbody component = gripPoint.TouchedObject().GetComponent<Rigidbody>();
		component.gameObject.GetComponent<ViveGrip_Grabbable>().GrabFrom(base.transform.position);
		joint = ViveGrip_JointFactory.JointToConnect(jointObject, component, base.transform.rotation);
	}

	private GameObject InstantiateJointParent()
	{
		GameObject gameObject = new GameObject("ViveGrip Joint");
		gameObject.transform.parent = base.transform;
		gameObject.transform.localPosition = Vector3.zero;
		gameObject.transform.localScale = Vector3.one;
		gameObject.transform.rotation = Quaternion.identity;
		Rigidbody rigidbody = gameObject.AddComponent<Rigidbody>();
		rigidbody.useGravity = false;
		rigidbody.isKinematic = true;
		return gameObject;
	}

	public GameObject ConnectedGameObject()
	{
		return joint.connectedBody.gameObject;
	}

	public bool HoldingSomething()
	{
		return jointObject != null;
	}
}
