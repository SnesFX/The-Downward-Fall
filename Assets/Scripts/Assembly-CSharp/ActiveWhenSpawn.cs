using UnityEngine;

public class ActiveWhenSpawn : MonoBehaviour
{
	public GameObject activehere;

	private void Start()
	{
		activehere.SetActive(true);
		Object.Destroy(base.gameObject);
	}
}
