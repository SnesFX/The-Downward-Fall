using UnityEngine;

public class BreakDownDoor : MonoBehaviour
{
	public GameObject breakdown;

	public GameObject FPS;

	public GameObject doormesh;

	public GameObject CameraScene;

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
				Invoke("CreateCamera", 3.3f);
				breakdown.SetActive(true);
				doormesh.SetActive(false);
			}
		}
	}

	private void CreateCamera()
	{
		FPS.SetActive(true);
		Object.Destroy(CameraScene);
		Object.Destroy(base.gameObject);
	}
}
