using System;
using System.Collections.Generic;
using UnityEngine;

public class ViveGrip_Highlighter : MonoBehaviour
{
	private ViveGrip_HighlightEffect effect;

	private bool highlighted;

	private HashSet<ViveGrip_GripPoint> grips = new HashSet<ViveGrip_GripPoint>();

	private void Update()
	{
		if (highlighted && grips.Count == 0)
		{
			RemoveHighlight();
		}
		if (!highlighted && grips.Count != 0)
		{
			Highlight();
		}
	}

	public void RemoveHighlight()
	{
		if (effect != null)
		{
			effect.Stop(base.gameObject);
			highlighted = false;
		}
	}

	public void Highlight()
	{
		if (effect != null)
		{
			effect.Start(base.gameObject);
			highlighted = true;
		}
	}

	public ViveGrip_HighlightEffect UpdateEffect(Type effectType)
	{
		if (effectType == null || typeof(ViveGrip_HighlightEffect).IsAssignableFrom(effectType))
		{
			if (effect != null)
			{
				effect.Stop(base.gameObject);
			}
			AssignEffect(effectType);
		}
		else
		{
			Debug.LogError(string.Concat(effectType, " does not implement the ViveGrip_HighlightEffect interface"));
		}
		return effect;
	}

	public ViveGrip_HighlightEffect CurrentEffect()
	{
		return effect;
	}

	private void AssignEffect(Type effectType)
	{
		if (effectType == null)
		{
			effect = null;
		}
		else
		{
			effect = Activator.CreateInstance(effectType) as ViveGrip_HighlightEffect;
		}
		ViveGrip_Object[] components = GetComponents<ViveGrip_Object>();
		foreach (ViveGrip_Object viveGrip_Object in components)
		{
			viveGrip_Object.highlightEffect = effectType;
		}
	}

	private void ViveGripHighlightStart(ViveGrip_GripPoint gripPoint)
	{
		if (base.enabled)
		{
			grips.Add(gripPoint);
		}
	}

	private void ViveGripHighlightStop(ViveGrip_GripPoint gripPoint)
	{
		if (base.enabled)
		{
			grips.Remove(gripPoint);
		}
	}

	private void OnDisable()
	{
		RemoveHighlight();
	}
}
