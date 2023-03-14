using UnityEngine;

public class ViveGripExample_ExtendGrab : MonoBehaviour
{
	private float counter;

	private const float THRESHOLD = 0.2f;

	private void Start()
	{
	}

	private void Update()
	{
		if (!(counter <= 0f))
		{
			counter -= Time.deltaTime;
		}
	}

	private void ViveGripGrabStart()
	{
		if (base.enabled)
		{
			counter = 0.2f;
		}
	}

	private void ViveGripGrabStop(ViveGrip_GripPoint gripPoint)
	{
		if (base.enabled && !(counter <= 0f))
		{
			gripPoint.ToggleGrab();
		}
	}
}
