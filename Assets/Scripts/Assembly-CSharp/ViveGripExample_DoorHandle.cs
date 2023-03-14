using UnityEngine;

public class ViveGripExample_DoorHandle : MonoBehaviour
{
	public Transform door;

	private void Start()
	{
	}

	private void Update()
	{
		Vector3 localEulerAngles = new Vector3(0f, 90f, 0f);
		localEulerAngles.x = 0f - door.GetComponent<HingeJoint>().angle;
		base.transform.localEulerAngles = localEulerAngles;
	}
}
