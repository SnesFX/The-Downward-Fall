using UnityEngine;
using UnityEngine.SceneManagement;

public class Demoend : MonoBehaviour
{
	private void OnTriggerEnter()
	{
		SceneManager.LoadScene(4);
	}
}
