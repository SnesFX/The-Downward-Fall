using UnityEngine;

[ExecuteInEditMode]
public class SteamVR_UpdatePoses : MonoBehaviour
{
	private void Awake()
	{
		Debug.Log("SteamVR_UpdatePoses has been deprecated - REMOVING");
		Object.DestroyImmediate(this);
	}
}
