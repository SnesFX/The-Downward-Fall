using UnityEngine;

public class ViveGripExample_Lever : MonoBehaviour
{
	private ViveGrip_ControllerHandler controller;

	private float oldXRotation;

	private int VIBRATION_DURATION_IN_MILLISECONDS = 50;

	private float MAX_VIBRATION_STRENGTH = 0.7f;

	private float MAX_VIBRATION_ANGLE = 35f;

	private void Start()
	{
		oldXRotation = base.transform.eulerAngles.x;
	}

	private void ViveGripGrabStart(ViveGrip_GripPoint gripPoint)
	{
		controller = gripPoint.controller;
	}

	private void ViveGripGrabStop()
	{
		controller = null;
	}

	private void Update()
	{
		float x = base.transform.eulerAngles.x;
		if (controller != null)
		{
			float num = Mathf.Min(Mathf.Abs(x - oldXRotation), MAX_VIBRATION_ANGLE);
			float strength = num / MAX_VIBRATION_ANGLE * MAX_VIBRATION_STRENGTH;
			controller.Vibrate(VIBRATION_DURATION_IN_MILLISECONDS, strength);
		}
		oldXRotation = x;
	}
}
