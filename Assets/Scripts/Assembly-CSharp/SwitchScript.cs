using UnityEngine;

public class SwitchScript : MonoBehaviour
{
	public GameObject TurnOn;

	public GameObject DestroyObj;

	[SerializeField]
	private Transform player;

	private void OnMouseDown()
	{
		if ((base.transform.position - player.position).magnitude < 3f)
		{
			TurnOn.SetActive(true);
			Object.Destroy(DestroyObj);
		}
	}
}
