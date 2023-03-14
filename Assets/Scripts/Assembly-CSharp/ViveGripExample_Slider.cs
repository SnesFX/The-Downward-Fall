using UnityEngine;

public class ViveGripExample_Slider : MonoBehaviour
{
	private ViveGrip_ControllerHandler controller;

	private float oldX;

	private int VIBRATION_DURATION_IN_MILLISECONDS = 50;

	private float MAX_VIBRATION_STRENGTH = 0.2f;

	private float MAX_VIBRATION_DISTANCE = 0.03f;

	private void Start()
	{
		oldX = base.transform.position.x;
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
		float x = base.transform.position.x;
		if (controller != null)
		{
			float num = Mathf.Min(Mathf.Abs(x - oldX), MAX_VIBRATION_DISTANCE);
			float strength = num / MAX_VIBRATION_DISTANCE * MAX_VIBRATION_STRENGTH;
			controller.Vibrate(VIBRATION_DURATION_IN_MILLISECONDS, strength);
		}
		oldX = x;
	}
}
