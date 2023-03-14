using UnityEngine;

public class RagdollOnClick : MonoBehaviour
{
	public GameObject Ragdoll;

	private void OnMouseDown()
	{
		Object.Instantiate(Ragdoll, base.transform.position, base.transform.rotation);
		Object.Destroy(base.gameObject);
	}
}
