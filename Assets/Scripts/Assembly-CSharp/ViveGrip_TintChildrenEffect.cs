using System.Collections.Generic;
using UnityEngine;

public class ViveGrip_TintChildrenEffect : ViveGrip_TintEffect
{
	public override Renderer[] RenderersIn(GameObject gameObject)
	{
		return gameObject.GetComponentsInChildren<Renderer>();
	}

	public override Material[] MaterialsFrom(Renderer[] renderers)
	{
		List<Material> list = new List<Material>();
		foreach (Renderer renderer in renderers)
		{
			list.AddRange(renderer.materials);
		}
		return list.ToArray();
	}
}
