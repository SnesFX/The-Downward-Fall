using UnityEngine;

public class DiningTrigger : MonoBehaviour
{
	private void OnTriggerEnter()
	{
		GameObject[] array = GameObject.FindGameObjectsWithTag("BeforeScare");
		GameObject[] array2 = array;
		foreach (GameObject gameObject in array2)
		{
			gameObject.SetActive(false);
			Object.Destroy(base.gameObject);
		}
	}
}
