using UnityEngine;
using UnityEngine.SceneManagement;

public class sceneloader : MonoBehaviour
{
	public void LoadScene()
	{
		GameObject[] array = GameObject.FindGameObjectsWithTag("firsttrig");
		GameObject[] array2 = array;
		foreach (GameObject gameObject in array2)
		{
			gameObject.SetActive(false);
		}
		SceneManager.LoadScene(1);
	}
}
