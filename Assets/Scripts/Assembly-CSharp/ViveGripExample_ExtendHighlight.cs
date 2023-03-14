using UnityEngine;

public class ViveGripExample_ExtendHighlight : MonoBehaviour
{
	public Texture highlightTexture;

	private void Start()
	{
		ViveGrip_Highlighter component = GetComponent<ViveGrip_Highlighter>();
		ViveGripExample_NewHighlight viveGripExample_NewHighlight = component.UpdateEffect(typeof(ViveGripExample_NewHighlight)) as ViveGripExample_NewHighlight;
		viveGripExample_NewHighlight.highlightTexture = highlightTexture;
	}
}
