using System.Collections.Generic;
using UnityEngine;

public class ViveGrip_TouchDetection : MonoBehaviour
{
	private List<ViveGrip_Object> collidingObjects = new List<ViveGrip_Object>();

	private void Start()
	{
		GetComponent<SphereCollider>().isTrigger = true;
	}

	private void OnTriggerEnter(Collider other)
	{
		ViveGrip_Object viveGrip_Object = ActiveComponent(other.gameObject);
		if (!(viveGrip_Object == null))
		{
			collidingObjects.Add(viveGrip_Object);
		}
	}

	private void OnTriggerExit(Collider other)
	{
		ViveGrip_Object viveGrip_Object = ActiveComponent(other.gameObject);
		if (!(viveGrip_Object == null))
		{
			collidingObjects.Remove(viveGrip_Object);
		}
	}

	public GameObject NearestObject()
	{
		float num = float.PositiveInfinity;
		GameObject result = null;
		foreach (ViveGrip_Object collidingObject in collidingObjects)
		{
			float num2 = Vector3.Distance(base.transform.position, collidingObject.transform.position);
			if (num2 < num)
			{
				result = collidingObject.gameObject;
				num = num2;
			}
		}
		return result;
	}

	private ViveGrip_Object ActiveComponent(GameObject gameObject)
	{
		if (gameObject == null)
		{
			return null;
		}
		ViveGrip_Object viveGrip_Object = ValidComponent(gameObject.transform);
		if (viveGrip_Object == null)
		{
			viveGrip_Object = ValidComponent(gameObject.transform.parent);
		}
		if (viveGrip_Object != null)
		{
			return viveGrip_Object;
		}
		return null;
	}

	private ViveGrip_Object ValidComponent(Transform transform)
	{
		if (transform == null)
		{
			return null;
		}
		ViveGrip_Object component = transform.GetComponent<ViveGrip_Object>();
		if (component != null && component.enabled)
		{
			return component;
		}
		return null;
	}
}
