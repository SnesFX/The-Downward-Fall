using UnityEngine;

public class ViveGripExample_CapsuleZone : MonoBehaviour
{
	public Transform capsule;

	private bool entered;

	private void Start()
	{
	}

	private void Update()
	{
		GetComponent<MeshRenderer>().enabled = entered;
	}

	private void OnTriggerStay(Collider other)
	{
		if (CapsuleIs(other.gameObject))
		{
			SetEnteredTo(!CapsuleSeated());
		}
	}

	private void OnTriggerExit(Collider other)
	{
		if (CapsuleIs(other.gameObject))
		{
			SetEnteredTo(false);
		}
	}

	private void SetEnteredTo(bool state)
	{
		entered = state;
		capsule.gameObject.GetComponent<ViveGripExample_Capsule>().inZone = state;
	}

	private bool CapsuleSeated()
	{
		return capsule.gameObject.GetComponent<ViveGripExample_Capsule>().seated;
	}

	private bool CapsuleIs(GameObject gameObject)
	{
		return capsule.gameObject.GetInstanceID() == gameObject.GetInstanceID();
	}
}
