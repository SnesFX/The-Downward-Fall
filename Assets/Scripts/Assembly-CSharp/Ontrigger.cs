using UnityEngine;

public class Ontrigger : MonoBehaviour
{
	public GameObject obj;

	private void OnTriggerEnter()
	{
		GameObject[] array = GameObject.FindGameObjectsWithTag("AliceAngel");
		GameObject[] array2 = array;
		foreach (GameObject gameObject in array2)
		{
			gameObject.SetActive(false);
		}
		Object.Instantiate(obj, new Vector3(40f, 1f, 40f), Quaternion.Euler(0f, 0f, 0f));
		Object.Destroy(base.gameObject);
	}
}
