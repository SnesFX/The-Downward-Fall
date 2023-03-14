using UnityEngine;

namespace Valve.VR.InteractionSystem
{
	public class ItemPackage : MonoBehaviour
	{
		public enum ItemPackageType
		{
			Unrestricted = 0,
			OneHanded = 1,
			TwoHanded = 2
		}

		public new string name;

		public ItemPackageType packageType;

		public GameObject itemPrefab;

		public GameObject otherHandItemPrefab;

		public GameObject previewPrefab;

		public GameObject fadedPreviewPrefab;
	}
}
