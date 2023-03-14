using UnityEngine;

public class ViveGripExample_SwitchBulb : MonoBehaviour
{
	private bool on;

	private void Start()
	{
		Toggle();
	}

	public void Toggle()
	{
		on = !on;
		Color color = ((!on) ? Color.red : Color.green);
		GetComponent<Renderer>().material.color = color;
	}
}
