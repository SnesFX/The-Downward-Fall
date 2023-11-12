using UnityEngine;

public class KitchenScene : MonoBehaviour
{
	public GameObject Player;

	public GameObject Camera;

	public GameObject Fadein;

	public GameObject Fetty;

	[SerializeField]
	private Transform player;

	private void OnMouseDown()
	{
		if ((base.transform.position - player.position).magnitude < 3f)
		{
			GameObject[] array = GameObject.FindGameObjectsWithTag("Player");
			GameObject[] array2 = array;
			foreach (GameObject gameObject in array2)
			{
				gameObject.SetActive(false);
				Camera.SetActive(true);
				Fetty.SetActive(true);
				Invoke("Reset", 9f);
			}
		}
	}

	private void Reset()
	{
		Player.SetActive(true);
	//	Object.Destroy(Camera);
		Object.Destroy(base.gameObject);
	}
}
