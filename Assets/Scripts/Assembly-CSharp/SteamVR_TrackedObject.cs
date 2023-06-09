using System;
using UnityEngine;
using Valve.VR;

public class SteamVR_TrackedObject : MonoBehaviour
{
	public enum EIndex
	{
		None = -1,
		Hmd = 0,
		Device1 = 1,
		Device2 = 2,
		Device3 = 3,
		Device4 = 4,
		Device5 = 5,
		Device6 = 6,
		Device7 = 7,
		Device8 = 8,
		Device9 = 9,
		Device10 = 10,
		Device11 = 11,
		Device12 = 12,
		Device13 = 13,
		Device14 = 14,
		Device15 = 15
	}

	public EIndex index;

	[Tooltip("If not set, relative to parent")]
	public Transform origin;

	private SteamVR_Events.Action newPosesAction;

	public bool isValid { get; private set; }

	private SteamVR_TrackedObject()
	{
		newPosesAction = SteamVR_Events.NewPosesAction(OnNewPoses);
	}

	private void OnNewPoses(TrackedDevicePose_t[] poses)
	{
		if (index == EIndex.None)
		{
			return;
		}
		int num = (int)index;
		isValid = false;
		if (poses.Length > num && poses[num].bDeviceIsConnected && poses[num].bPoseIsValid)
		{
			isValid = true;
			SteamVR_Utils.RigidTransform rigidTransform = new SteamVR_Utils.RigidTransform(poses[num].mDeviceToAbsoluteTracking);
			if (origin != null)
			{
				base.transform.position = origin.transform.TransformPoint(rigidTransform.pos);
				base.transform.rotation = origin.rotation * rigidTransform.rot;
			}
			else
			{
				base.transform.localPosition = rigidTransform.pos;
				base.transform.localRotation = rigidTransform.rot;
			}
		}
	}

	private void OnEnable()
	{
		SteamVR_Render instance = SteamVR_Render.instance;
		if (instance == null)
		{
			base.enabled = false;
		}
		else
		{
			newPosesAction.enabled = true;
		}
	}

	private void OnDisable()
	{
		newPosesAction.enabled = false;
		isValid = false;
	}

	public void SetDeviceIndex(int index)
	{
		if (Enum.IsDefined(typeof(EIndex), index))
		{
			this.index = (EIndex)index;
		}
	}
}
