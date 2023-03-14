using UnityEngine;

public class ViveGripExample_Bubbler : MonoBehaviour
{
	public GameObject bubble;

	private float maxSize = 0.2f;

	private float minSize = 0.1f;

	private float speed = 5f;

	private float cooldown;

	private bool bubbling;

	private ViveGrip_ControllerHandler controller;

	private void Start()
	{
	}

	private void Update()
	{
		if (bubbling)
		{
			if (cooldown > 0f)
			{
				cooldown -= Time.deltaTime;
				return;
			}
			controller.Vibrate(50, 0.1f);
			CreateBubble();
			cooldown = 0.1f;
		}
	}

	private void ViveGripInteractionStart(ViveGrip_GripPoint gripPoint)
	{
		if (gripPoint.HoldingSomething())
		{
			bubbling = true;
			controller = gripPoint.controller;
		}
	}

	private void ViveGripGrabStop()
	{
		StopFiring();
	}

	private void ViveGripInteractionStop()
	{
		StopFiring();
	}

	private void StopFiring()
	{
		bubbling = false;
		controller = null;
		cooldown = 0f;
	}

	private void CreateBubble()
	{
		Vector3 position = base.transform.position + base.transform.forward * 0.2f;
		GameObject gameObject = Object.Instantiate(bubble, position, Quaternion.identity);
		float num = Random.Range(minSize, maxSize);
		gameObject.transform.localScale = Vector3.one * num;
		gameObject.GetComponent<Rigidbody>().AddForce(base.transform.forward * speed);
	}
}
