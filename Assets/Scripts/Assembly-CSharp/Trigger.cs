using UnityEngine;

public class Trigger : MonoBehaviour
{
	public GameObject Voiceline;

	private void OnTriggerEnter()
	{
		Object.Instantiate(Voiceline, base.transform.position, base.transform.rotation);
	}
}
