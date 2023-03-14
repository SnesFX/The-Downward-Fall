using UnityEngine;

public class PressE : MonoBehaviour
{
	public GameObject ObjectHere;

	[SerializeField]
	private Transform player;

	private void OnMouseDown()
	{
		if ((base.transform.position - player.position).magnitude < 3f)
		{
			GameObject[] array = GameObject.FindGameObjectsWithTag("Finish");
			GameObject[] array2 = array;
			foreach (GameObject gameObject in array2)
			{
				gameObject.SetActive(false);
			}
			Object.Instantiate(ObjectHere, base.transform.position, base.transform.rotation);
		}
	}
}
