using UnityEngine;

public class PressQuit : MonoBehaviour
{
	private void Update()
	{
		if (Input.GetKeyDown("escape"))
		{
			Application.Quit();
		}
	}
}
