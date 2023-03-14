using UnityEngine;

public class LadderScript : MonoBehaviour
{
	public GameObject obj;

	public GameObject DestroyObj;

	private void OnTriggerEnter()
	{
		obj.SetActive(true);
		Object.Destroy(DestroyObj);
		Object.Destroy(base.gameObject);
	}
}
