using UnityEngine;

public class valve1 : MonoBehaviour
{
	public GameObject Unflood;

	[SerializeField]
	private Transform player;

	private void OnMouseDown()
	{
		if ((base.transform.position - player.position).magnitude < 3f)
		{
			GameObject[] array = GameObject.FindGameObjectsWithTag("flood1");
			GameObject[] array2 = array;
			foreach (GameObject gameObject in array2)
			{
				gameObject.SetActive(false);
			}
			Object.Instantiate(Unflood, new Vector3(32f, 1f, 16f), Quaternion.Euler(0f, 0f, 0f));
		}
	}
}
