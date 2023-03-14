using UnityEngine;
using UnityEngine.SceneManagement;

public class Intro : MonoBehaviour
{
	public GameObject wow;

	private void Start()
	{
		Invoke("IntroEnd", 105f);
	}

	private void IntroEnd()
	{
		SceneManager.LoadScene(1);
	}

	public void Update()
	{
		if (Input.GetKeyUp(KeyCode.E))
		{
			GameObject[] array = GameObject.FindGameObjectsWithTag("firsttrig");
			GameObject[] array2 = array;
			foreach (GameObject gameObject in array2)
			{
				gameObject.SetActive(false);
				Object.Instantiate(wow, base.transform.position, base.transform.rotation);
			}
			SceneManager.LoadScene(1);
		}
	}
}
