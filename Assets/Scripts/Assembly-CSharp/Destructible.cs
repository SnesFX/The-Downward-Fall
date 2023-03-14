using UnityEngine;

public class Destructible : MonoBehaviour
{
	public GameObject destroyedVersion;

	private void OnTriggerEnter()
	{
		Object.Instantiate(destroyedVersion, base.transform.position, Quaternion.Euler(0f, 70f, 0f));
		Object.Destroy(base.gameObject);
	}
}
