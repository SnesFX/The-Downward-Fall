using UnityEngine;
using ViveGrip.TypeReferences;

public class ViveGripExample_Manager : MonoBehaviour
{
	public bool disableAllHighlighting;

	[ClassImplements(typeof(ViveGrip_HighlightEffect))]
	public ClassTypeReference highlightEffectForEverything;

	public bool changeHighlightsAtStart;

	public float gripStrengthMultiplier = 1f;

	public float gripRotationMultiplier = 1f;

	private void Start()
	{
		if (changeHighlightsAtStart)
		{
			ChangeAllHighlightEffects();
		}
	}

	private void Update()
	{
		SetHighlighting();
		SetGripStrength();
	}

	private void SetHighlighting()
	{
		ViveGrip_Highlighter[] array = AllHighlighters();
		foreach (ViveGrip_Highlighter viveGrip_Highlighter in array)
		{
			viveGrip_Highlighter.enabled = !disableAllHighlighting;
		}
	}

	private void SetGripStrength()
	{
		ViveGrip_JointFactory.LINEAR_DRIVE_MULTIPLIER = gripStrengthMultiplier;
		ViveGrip_JointFactory.ANGULAR_DRIVE_MULTIPLIER = gripRotationMultiplier;
	}

	private void OnValidate()
	{
		ChangeAllHighlightEffects();
	}

	private void ChangeAllHighlightEffects()
	{
		if (AllHighlighters().Length != 0)
		{
			Debug.Log("Changing all highlight effects to: " + highlightEffectForEverything.ToString());
			ViveGrip_Highlighter[] array = AllHighlighters();
			foreach (ViveGrip_Highlighter viveGrip_Highlighter in array)
			{
				viveGrip_Highlighter.UpdateEffect(highlightEffectForEverything.Type);
			}
		}
	}

	private ViveGrip_Highlighter[] AllHighlighters()
	{
		return Object.FindObjectsOfType<ViveGrip_Highlighter>();
	}
}
