using UnityEngine;
using UnityEngine.UI;

public class BendydollTalk : MonoBehaviour
{
	public bool isImgOn;

	public Image img;

	public GameObject ObjectHere;

	public GameObject img2;

	[SerializeField]
	private Transform player;

	private void Start()
	{
		img.enabled = false;
		isImgOn = false;
	}

	private void OnMouseDown()
	{
		if ((base.transform.position - player.position).magnitude < 3f)
		{
			GameObject[] array = GameObject.FindGameObjectsWithTag("bendydoll");
			GameObject[] array2 = array;
			foreach (GameObject gameObject in array2)
			{
				gameObject.SetActive(false);
			}
			img2.SetActive(true);
			Object.Instantiate(ObjectHere, base.transform.position, base.transform.rotation);
			img.enabled = true;
			isImgOn = true;
			Object.Destroy(img, 15f);
			base.gameObject.SetActive(false);
		}
	}
}
