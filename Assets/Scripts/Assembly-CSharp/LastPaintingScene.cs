using UnityEngine;

public class LastPaintingScene : MonoBehaviour
{
	public GameObject Camera;

	public GameObject Player;

	public GameObject UiDarkness;

	public GameObject Painting;

	[SerializeField]
	private Transform player;

	private void OnMouseDown()
	{
		if ((base.transform.position - player.position).magnitude < 3f)
		{
			Camera.SetActive(true);
			GameObject[] array = GameObject.FindGameObjectsWithTag("Player");
			GameObject[] array2 = array;
			foreach (GameObject gameObject in array2)
			{
				gameObject.SetActive(false);
				Invoke("CreateCamera", 18f);
				UiDarkness.SetActive(true);
				Camera.SetActive(true);
			}
		}
	}

	private void CreateCamera()
	{
		Player.SetActive(true);
		Painting.SetActive(true);
		Object.Destroy(Camera);
		Object.Destroy(base.gameObject);
	}
}
