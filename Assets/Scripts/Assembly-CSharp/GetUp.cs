using UnityEngine;

public class GetUp : MonoBehaviour
{
	public GameObject fps;

	private void Start()
	{
		Invoke("CreateCamera", 5f);
	}

	private void CreateCamera()
	{
		fps.SetActive(true);
		Object.Destroy(base.gameObject);
	}
}
