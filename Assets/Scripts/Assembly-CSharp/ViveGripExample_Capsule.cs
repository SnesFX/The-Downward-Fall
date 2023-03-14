using UnityEngine;

public class ViveGripExample_Capsule : MonoBehaviour
{
	public bool inZone;

	public bool seated = true;

	private Vector3 seatedPosition;

	private const float FLOAT_SPEED = 3f;

	private const float FLOAT_DISTANCE = 0.01f;

	private void Start()
	{
		seatedPosition = base.transform.position;
	}

	private void Update()
	{
		GetComponent<Rigidbody>().useGravity = !seated;
		if (seated)
		{
			Vector3 position = base.transform.position;
			position.y = seatedPosition.y + Mathf.Sin(Time.time * 3f) * 0.01f;
			base.transform.position = position;
		}
	}

	private void ViveGripGrabStart()
	{
		seated = false;
	}

	private void ViveGripGrabStop()
	{
		seated = inZone;
		if (seated)
		{
			Reseat();
		}
	}

	private void Reseat()
	{
		base.transform.position = seatedPosition;
		base.transform.rotation = Quaternion.identity;
		GetComponent<Rigidbody>().velocity = Vector3.zero;
		GetComponent<Rigidbody>().angularVelocity = Vector3.zero;
	}

	private void OnCollisionEnter()
	{
		seated = false;
	}
}
