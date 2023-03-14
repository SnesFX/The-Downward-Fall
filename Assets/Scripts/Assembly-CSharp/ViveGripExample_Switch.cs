using UnityEngine;

public class ViveGripExample_Switch : MonoBehaviour
{
	private void Start()
	{
	}

	public void Flip()
	{
		Vector3 eulerAngles = base.transform.eulerAngles;
		eulerAngles.x *= -1f;
		base.transform.eulerAngles = eulerAngles;
	}
}
