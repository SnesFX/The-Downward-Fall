using UnityEngine;
using ViveGrip.TypeReferences;

public class ViveGrip_Object : MonoBehaviour
{
	[ClassImplements(typeof(ViveGrip_HighlightEffect))]
	public ClassTypeReference highlightEffect = typeof(ViveGrip_TintEffect);

	private ViveGrip_Highlighter highlighter;

	public void Awake()
	{
		highlighter = GetComponent<ViveGrip_Highlighter>();
		if (highlighter == null)
		{
			highlighter = base.gameObject.AddComponent<ViveGrip_Highlighter>();
		}
		highlighter.UpdateEffect(highlightEffect.Type);
	}

	private void OnDisable()
	{
		if (!(highlighter == null))
		{
			highlighter.RemoveHighlight();
		}
	}

	private void OnEnable()
	{
		if (!(highlighter == null))
		{
			highlighter.Highlight();
		}
	}

	private void OnValidate()
	{
		if (!(highlighter == null))
		{
			highlighter.UpdateEffect(highlightEffect.Type);
		}
	}
}
