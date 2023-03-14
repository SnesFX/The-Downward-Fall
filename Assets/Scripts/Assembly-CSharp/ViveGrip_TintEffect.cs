using System.Collections.Generic;
using UnityEngine;

public class ViveGrip_TintEffect : ViveGrip_HighlightEffect
{
	private Color tintColor = new Color(0.2f, 0.2f, 0.2f, 0f);

	private Queue<Color> oldColors = new Queue<Color>();

	public void Start(GameObject gameObject)
	{
		Stop(gameObject);
		Material[] array = MaterialsFrom(RenderersIn(gameObject));
		foreach (Material material in array)
		{
			StashColor(material);
		}
	}

	public void Stop(GameObject gameObject)
	{
		Material[] array = MaterialsFrom(RenderersIn(gameObject));
		foreach (Material material in array)
		{
			if (oldColors.Count == 0)
			{
				break;
			}
			PopColor(material);
		}
		oldColors.Clear();
	}

	private void StashColor(Material material)
	{
		oldColors.Enqueue(material.color);
		material.color += tintColor;
	}

	private void PopColor(Material material)
	{
		material.color = oldColors.Dequeue();
	}

	public virtual Renderer[] RenderersIn(GameObject gameObject)
	{
		Renderer component = gameObject.GetComponent<Renderer>();
		if (component == null)
		{
			return new Renderer[0];
		}
		return new Renderer[1] { component };
	}

	public virtual Material[] MaterialsFrom(Renderer[] renderers)
	{
		if (renderers.Length == 0)
		{
			return new Material[0];
		}
		return renderers[0].materials;
	}
}
