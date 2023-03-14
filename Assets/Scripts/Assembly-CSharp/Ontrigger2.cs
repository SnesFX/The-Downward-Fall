using UnityEngine;

public class Ontrigger2 : MonoBehaviour
{
	private void OnTriggerEnter()
	{
		GameObject[] array = GameObject.FindGameObjectsWithTag("firsttrig");
		GameObject[] array2 = array;
		foreach (GameObject gameObject in array2)
		{
			base.gameObject.SetActive(true);
		}
		Object.Destroy(base.gameObject);
	}
}
