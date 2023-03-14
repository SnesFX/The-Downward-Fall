using UnityEngine;

public class ViveGripExample_Tar : MonoBehaviour
{
	private ViveGrip_GripPoint attachedGripPoint;

	private const float SPEED_THRESHOLD = 6f;

	private bool attached;

	private void Start()
	{
	}

	private void Update()
	{
		if (!(attachedGripPoint == null))
		{
			float magnitude = GetComponent<Rigidbody>().velocity.magnitude;
			attached = attached || magnitude < 6f;
			if (attached && magnitude > 6f)
			{
				attachedGripPoint.enabled = true;
				attachedGripPoint.ToggleGrab();
				attachedGripPoint = null;
			}
		}
	}

	private void ViveGripTouchStart(ViveGrip_GripPoint gripPoint)
	{
		if (!gripPoint.HoldingSomething())
		{
			gripPoint.ToggleGrab();
			attachedGripPoint = gripPoint;
			gripPoint.enabled = false;
			attached = false;
		}
	}
}
