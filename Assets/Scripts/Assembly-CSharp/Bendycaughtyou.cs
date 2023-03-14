using UnityEngine;
using UnityEngine.SceneManagement;

public class Bendycaughtyou : MonoBehaviour
{
	public GameObject DeathAnim;

	private void OnTriggerEnter(Collider colidedObj)
	{
		if (colidedObj.tag == "Player")
		{
			Object.Instantiate(DeathAnim, base.transform.position, base.transform.rotation);
			Invoke("deathanimation", 1.15f);
			GameObject[] array = GameObject.FindGameObjectsWithTag("Player");
			GameObject[] array2 = array;
			foreach (GameObject gameObject in array2)
			{
				gameObject.SetActive(false);
			}
		}
	}

	private void deathanimation()
	{
		SceneManager.LoadScene(1);
	}
}
