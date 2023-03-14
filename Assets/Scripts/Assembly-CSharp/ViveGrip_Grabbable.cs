using System;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
[DisallowMultipleComponent]
public class ViveGrip_Grabbable : ViveGrip_Object
{
	public enum RotationMode
	{
		Disabled = 0,
		ApplyGrip = 1,
		ApplyGripAndOrientation = 2
	}

	[Serializable]
	public class Position
	{
		[Tooltip("Should the grip connect to the Local Anchor position?")]
		public bool enabled;

		[Tooltip("The local position that will be gripped if enabled.")]
		public Vector3 localPosition = Vector3.zero;
	}

	[Serializable]
	public class Rotation
	{
		[Tooltip("The rotations that will be applied to a grabbed object.")]
		public RotationMode mode = RotationMode.ApplyGrip;

		[Tooltip("The local orientation that can be snapped to when grabbed.")]
		public Vector3 localOrientation = Vector3.zero;
	}

	public Position anchor;

	public Rotation rotation;

	private Vector3 grabCentre;

	public void OnDrawGizmosSelected()
	{
		if (anchor != null && anchor.enabled)
		{
			Gizmos.DrawIcon(base.transform.position + RotatedAnchor(), "ViveGrip/anchor.png", true);
		}
	}

	public Vector3 RotatedAnchor()
	{
		return base.transform.rotation * anchor.localPosition;
	}

	public void GrabFrom(Vector3 jointLocation)
	{
		grabCentre = ((!anchor.enabled) ? (jointLocation - base.transform.position) : anchor.localPosition);
	}

	public Vector3 WorldAnchorPosition()
	{
		return base.transform.position + base.transform.rotation * grabCentre;
	}

	public bool ApplyGripRotation()
	{
		return rotation.mode != RotationMode.Disabled;
	}

	public bool SnapToOrientation()
	{
		return rotation.mode == RotationMode.ApplyGripAndOrientation;
	}
}
