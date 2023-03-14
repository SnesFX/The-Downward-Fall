using System.Collections.Generic;
using UnityEngine;

public class ViveGripExample_NewHighlight : ViveGrip_HighlightEffect
{
	public Texture highlightTexture;

	private Queue<Texture> oldTextures = new Queue<Texture>();

	public void Start(GameObject gameObject)
	{
		Renderer component = gameObject.GetComponent<Renderer>();
		if (!(component == null))
		{
			Stop(gameObject);
			Material[] materials = component.materials;
			foreach (Material material in materials)
			{
				Texture mainTexture = material.mainTexture;
				oldTextures.Enqueue(mainTexture);
				material.mainTexture = highlightTexture;
			}
		}
	}

	public void Stop(GameObject gameObject)
	{
		Renderer component = gameObject.GetComponent<Renderer>();
		if (component == null)
		{
			return;
		}
		Material[] materials = component.materials;
		foreach (Material material in materials)
		{
			if (oldTextures.Count == 0)
			{
				break;
			}
			material.mainTexture = oldTextures.Dequeue();
		}
		oldTextures.Clear();
	}
}
