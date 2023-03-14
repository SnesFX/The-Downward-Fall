using System.Collections;
using UnityEngine;

public class ViveGripExample_Button : MonoBehaviour
{
	private const float SPEED = 0.1f;

	private float distance;

	private int direction = 1;

	private int VIBRATION_DURATION_IN_MILLISECONDS = 25;

	private float VIBRATION_STRENGTH = 0.4f;

	private void Start()
	{
		ResetDistance();
	}

	private void ViveGripInteractionStart(ViveGrip_GripPoint gripPoint)
	{
		gripPoint.controller.Vibrate(VIBRATION_DURATION_IN_MILLISECONDS, VIBRATION_STRENGTH);
		GetComponent<ViveGrip_Interactable>().enabled = false;
		StartCoroutine("Move");
	}

	private IEnumerator Move()
	{
		while (distance > 0f)
		{
			Increment();
			yield return null;
		}
		yield return StartCoroutine("MoveBack");
	}

	private IEnumerator MoveBack()
	{
		direction *= -1;
		ResetDistance();
		while (distance > 0f)
		{
			Increment();
			yield return null;
		}
		direction *= -1;
		ResetDistance();
		GetComponent<ViveGrip_Interactable>().enabled = true;
	}

	private void Increment()
	{
		float a = Time.deltaTime * 0.1f;
		a = Mathf.Min(a, distance);
		base.transform.Translate(0f, 0f, a * (float)direction);
		distance -= a;
	}

	private void ResetDistance()
	{
		distance = 0.03f;
	}
}
