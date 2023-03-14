using UnityEngine;

public class ViveGripExample_Dial : MonoBehaviour
{
	public Transform attachedLight;

	private void Start()
	{
	}

	private void Update()
	{
		HingeJoint component = GetComponent<HingeJoint>();
		float num = (component.angle + 90f) / 180f;
		float r = 1f - num;
		Color color = new Color(r, num, 0f);
		attachedLight.gameObject.GetComponent<Renderer>().material.color = color;
		attachedLight.GetChild(0).GetComponent<Light>().color = color;
	}
}
