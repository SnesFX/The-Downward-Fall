using System.Collections.Generic;
using UnityEngine;

public class ViveGripExample_Teleporter : MonoBehaviour
{
	public Transform player;

	private bool teleported;

	private void Start()
	{
	}

	private void ViveGripInteractionStart()
	{
		HashSet<Transform> hashSet = new HashSet<Transform>();
		hashSet.Add(player);
		hashSet.Add(base.transform);
		ViveGrip_GripPoint[] array = GripPoints();
		foreach (ViveGrip_GripPoint viveGrip_GripPoint in array)
		{
			if (viveGrip_GripPoint.HoldingSomething())
			{
				hashSet.Add(viveGrip_GripPoint.HeldObject().transform);
			}
		}
		foreach (Transform item in hashSet)
		{
			item.Translate(Distance(), Space.World);
		}
		teleported = !teleported;
	}

	private Vector3 Distance()
	{
		int num = ((!teleported) ? 1 : (-1));
		return new Vector3(0f, 0f, -6f * (float)num);
	}

	private ViveGrip_GripPoint[] GripPoints()
	{
		return player.GetComponentsInChildren<ViveGrip_GripPoint>();
	}
}
