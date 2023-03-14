using UnityEngine;
using Valve.VR;

public class SteamVR_ControllerManager : MonoBehaviour
{
	public GameObject left;

	public GameObject right;

	[Tooltip("Populate with objects you want to assign to additional controllers")]
	public GameObject[] objects;

	[Tooltip("Set to true if you want objects arbitrarily assigned to controllers before their role (left vs right) is identified")]
	public bool assignAllBeforeIdentified;

	private uint[] indices;

	private bool[] connected = new bool[16];

	private uint leftIndex = uint.MaxValue;

	private uint rightIndex = uint.MaxValue;

	private SteamVR_Events.Action inputFocusAction;

	private SteamVR_Events.Action deviceConnectedAction;

	private SteamVR_Events.Action trackedDeviceRoleChangedAction;

	private static string hiddenPrefix = "hidden (";

	private static string hiddenPostfix = ")";

	private static string[] labels = new string[2] { "left", "right" };

	private SteamVR_ControllerManager()
	{
		inputFocusAction = SteamVR_Events.InputFocusAction(OnInputFocus);
		deviceConnectedAction = SteamVR_Events.DeviceConnectedAction(OnDeviceConnected);
		trackedDeviceRoleChangedAction = SteamVR_Events.SystemAction(EVREventType.VREvent_TrackedDeviceRoleChanged, OnTrackedDeviceRoleChanged);
	}

	private void SetUniqueObject(GameObject o, int index)
	{
		for (int i = 0; i < index; i++)
		{
			if (objects[i] == o)
			{
				return;
			}
		}
		objects[index] = o;
	}

	public void UpdateTargets()
	{
		GameObject[] array = objects;
		int num = ((array != null) ? array.Length : 0);
		objects = new GameObject[2 + num];
		SetUniqueObject(right, 0);
		SetUniqueObject(left, 1);
		for (int i = 0; i < num; i++)
		{
			SetUniqueObject(array[i], 2 + i);
		}
		indices = new uint[2 + num];
		for (int j = 0; j < indices.Length; j++)
		{
			indices[j] = uint.MaxValue;
		}
	}

	private void Awake()
	{
		UpdateTargets();
	}

	private void OnEnable()
	{
		for (int i = 0; i < objects.Length; i++)
		{
			GameObject gameObject = objects[i];
			if (gameObject != null)
			{
				gameObject.SetActive(false);
			}
			indices[i] = uint.MaxValue;
		}
		Refresh();
		for (int j = 0; j < SteamVR.connected.Length; j++)
		{
			if (SteamVR.connected[j])
			{
				OnDeviceConnected(j, true);
			}
		}
		inputFocusAction.enabled = true;
		deviceConnectedAction.enabled = true;
		trackedDeviceRoleChangedAction.enabled = true;
	}

	private void OnDisable()
	{
		inputFocusAction.enabled = false;
		deviceConnectedAction.enabled = false;
		trackedDeviceRoleChangedAction.enabled = false;
	}

	private void OnInputFocus(bool hasFocus)
	{
		if (hasFocus)
		{
			for (int i = 0; i < objects.Length; i++)
			{
				GameObject gameObject = objects[i];
				if (gameObject != null)
				{
					string text = ((i >= 2) ? (i - 1).ToString() : labels[i]);
					ShowObject(gameObject.transform, hiddenPrefix + text + hiddenPostfix);
				}
			}
			return;
		}
		for (int j = 0; j < objects.Length; j++)
		{
			GameObject gameObject2 = objects[j];
			if (gameObject2 != null)
			{
				string text2 = ((j >= 2) ? (j - 1).ToString() : labels[j]);
				HideObject(gameObject2.transform, hiddenPrefix + text2 + hiddenPostfix);
			}
		}
	}

	private void HideObject(Transform t, string name)
	{
		if (t.gameObject.name.StartsWith(hiddenPrefix))
		{
			Debug.Log("Ignoring double-hide.");
			return;
		}
		Transform transform = new GameObject(name).transform;
		transform.parent = t.parent;
		t.parent = transform;
		transform.gameObject.SetActive(false);
	}

	private void ShowObject(Transform t, string name)
	{
		Transform parent = t.parent;
		if (!(parent.gameObject.name != name))
		{
			t.parent = parent.parent;
			Object.Destroy(parent.gameObject);
		}
	}

	private void SetTrackedDeviceIndex(int objectIndex, uint trackedDeviceIndex)
	{
		if (trackedDeviceIndex != uint.MaxValue)
		{
			for (int i = 0; i < objects.Length; i++)
			{
				if (i != objectIndex && indices[i] == trackedDeviceIndex)
				{
					GameObject gameObject = objects[i];
					if (gameObject != null)
					{
						gameObject.SetActive(false);
					}
					indices[i] = uint.MaxValue;
				}
			}
		}
		if (trackedDeviceIndex == indices[objectIndex])
		{
			return;
		}
		indices[objectIndex] = trackedDeviceIndex;
		GameObject gameObject2 = objects[objectIndex];
		if (gameObject2 != null)
		{
			if (trackedDeviceIndex == uint.MaxValue)
			{
				gameObject2.SetActive(false);
				return;
			}
			gameObject2.SetActive(true);
			gameObject2.BroadcastMessage("SetDeviceIndex", (int)trackedDeviceIndex, SendMessageOptions.DontRequireReceiver);
		}
	}

	private void OnTrackedDeviceRoleChanged(VREvent_t vrEvent)
	{
		Refresh();
	}

	private void OnDeviceConnected(int index, bool connected)
	{
		bool flag = this.connected[index];
		this.connected[index] = false;
		if (connected)
		{
			CVRSystem system = OpenVR.System;
			if (system != null)
			{
				ETrackedDeviceClass trackedDeviceClass = system.GetTrackedDeviceClass((uint)index);
				if (trackedDeviceClass == ETrackedDeviceClass.Controller || trackedDeviceClass == ETrackedDeviceClass.GenericTracker)
				{
					this.connected[index] = true;
					flag = !flag;
				}
			}
		}
		if (flag)
		{
			Refresh();
		}
	}

	public void Refresh()
	{
		int num = 0;
		CVRSystem system = OpenVR.System;
		if (system != null)
		{
			leftIndex = system.GetTrackedDeviceIndexForControllerRole(ETrackedControllerRole.LeftHand);
			rightIndex = system.GetTrackedDeviceIndexForControllerRole(ETrackedControllerRole.RightHand);
		}
		if (leftIndex == uint.MaxValue && rightIndex == uint.MaxValue)
		{
			for (uint num2 = 0u; num2 < connected.Length; num2++)
			{
				if (num >= objects.Length)
				{
					break;
				}
				if (connected[num2])
				{
					SetTrackedDeviceIndex(num++, num2);
					if (!assignAllBeforeIdentified)
					{
						break;
					}
				}
			}
		}
		else
		{
			SetTrackedDeviceIndex(num++, (rightIndex >= connected.Length || !connected[rightIndex]) ? uint.MaxValue : rightIndex);
			SetTrackedDeviceIndex(num++, (leftIndex >= connected.Length || !connected[leftIndex]) ? uint.MaxValue : leftIndex);
			if (leftIndex != uint.MaxValue && rightIndex != uint.MaxValue)
			{
				for (uint num3 = 0u; num3 < connected.Length; num3++)
				{
					if (num >= objects.Length)
					{
						break;
					}
					if (connected[num3] && num3 != leftIndex && num3 != rightIndex)
					{
						SetTrackedDeviceIndex(num++, num3);
					}
				}
			}
		}
		while (num < objects.Length)
		{
			SetTrackedDeviceIndex(num++, uint.MaxValue);
		}
	}
}
