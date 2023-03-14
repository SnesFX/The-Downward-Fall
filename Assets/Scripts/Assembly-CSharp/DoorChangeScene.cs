using UnityEngine;
using UnityEngine.SceneManagement;

public class DoorChangeScene : MonoBehaviour
{
	[SerializeField]
	private Transform player;

	private void OnMouseDown()
	{
		if ((base.transform.position - player.position).magnitude < 3f)
		{
			SceneManager.LoadScene(3);
		}
	}
}
