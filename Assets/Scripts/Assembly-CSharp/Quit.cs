using UnityEngine;

public class Quit : MonoBehaviour
{
	public void Exitgame()
	{
		Application.Quit();
	}

	private void OnMouseDown()
	{
		Application.Quit();
	}
}
