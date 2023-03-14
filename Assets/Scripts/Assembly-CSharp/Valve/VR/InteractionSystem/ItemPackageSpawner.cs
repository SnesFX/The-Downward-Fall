using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;

namespace Valve.VR.InteractionSystem
{
	[RequireComponent(typeof(Interactable))]
	public class ItemPackageSpawner : MonoBehaviour
	{
		public ItemPackage _itemPackage;

		private bool useItemPackagePreview = true;

		private bool useFadedPreview;

		private GameObject previewObject;

		public bool requireTriggerPressToTake;

		public bool requireTriggerPressToReturn;

		public bool showTriggerHint;

		[EnumFlags]
		public Hand.AttachmentFlags attachmentFlags = Hand.AttachmentFlags.SnapOnAttach | Hand.AttachmentFlags.DetachOthers | Hand.AttachmentFlags.DetachFromOtherHand | Hand.AttachmentFlags.ParentToHand;

		public string attachmentPoint;

		public bool takeBackItem;

		public bool acceptDifferentItems;

		private GameObject spawnedItem;

		private bool itemIsSpawned;

		public UnityEvent pickupEvent;

		public UnityEvent dropEvent;

		public bool justPickedUpItem;

		public ItemPackage itemPackage
		{
			get
			{
				return _itemPackage;
			}
			set
			{
				CreatePreviewObject();
			}
		}

		private void CreatePreviewObject()
		{
			if (!useItemPackagePreview)
			{
				return;
			}
			ClearPreview();
			if (!useItemPackagePreview || itemPackage == null)
			{
				return;
			}
			if (!useFadedPreview)
			{
				if (itemPackage.previewPrefab != null)
				{
					previewObject = UnityEngine.Object.Instantiate(itemPackage.previewPrefab, base.transform.position, Quaternion.identity);
					previewObject.transform.parent = base.transform;
					previewObject.transform.localRotation = Quaternion.identity;
				}
			}
			else if (itemPackage.fadedPreviewPrefab != null)
			{
				previewObject = UnityEngine.Object.Instantiate(itemPackage.fadedPreviewPrefab, base.transform.position, Quaternion.identity);
				previewObject.transform.parent = base.transform;
				previewObject.transform.localRotation = Quaternion.identity;
			}
		}

		private void Start()
		{
			VerifyItemPackage();
		}

		private void VerifyItemPackage()
		{
			if (itemPackage == null)
			{
				ItemPackageNotValid();
			}
			if (itemPackage.itemPrefab == null)
			{
				ItemPackageNotValid();
			}
		}

		private void ItemPackageNotValid()
		{
			Debug.LogError("ItemPackage assigned to " + base.gameObject.name + " is not valid. Destroying this game object.");
			UnityEngine.Object.Destroy(base.gameObject);
		}

		private void ClearPreview()
		{
			IEnumerator enumerator = base.transform.GetEnumerator();
			try
			{
				while (enumerator.MoveNext())
				{
					Transform transform = (Transform)enumerator.Current;
					if (Time.time > 0f)
					{
						UnityEngine.Object.Destroy(transform.gameObject);
					}
					else
					{
						UnityEngine.Object.DestroyImmediate(transform.gameObject);
					}
				}
			}
			finally
			{
				IDisposable disposable;
				if ((disposable = enumerator as IDisposable) != null)
				{
					disposable.Dispose();
				}
			}
		}

		private void Update()
		{
			if (itemIsSpawned && spawnedItem == null)
			{
				itemIsSpawned = false;
				useFadedPreview = false;
				dropEvent.Invoke();
				CreatePreviewObject();
			}
		}

		private void OnHandHoverBegin(Hand hand)
		{
			ItemPackage attachedItemPackage = GetAttachedItemPackage(hand);
			if (attachedItemPackage == itemPackage && takeBackItem && !requireTriggerPressToReturn)
			{
				TakeBackItem(hand);
			}
			if (!requireTriggerPressToTake)
			{
				SpawnAndAttachObject(hand);
			}
			if (requireTriggerPressToTake && showTriggerHint)
			{
				ControllerButtonHints.ShowTextHint(hand, EVRButtonId.k_EButton_Axis1, "PickUp");
			}
		}

		private void TakeBackItem(Hand hand)
		{
			RemoveMatchingItemsFromHandStack(itemPackage, hand);
			if (itemPackage.packageType == ItemPackage.ItemPackageType.TwoHanded)
			{
				RemoveMatchingItemsFromHandStack(itemPackage, hand.otherHand);
			}
		}

		private ItemPackage GetAttachedItemPackage(Hand hand)
		{
			GameObject currentAttachedObject = hand.currentAttachedObject;
			if (currentAttachedObject == null)
			{
				return null;
			}
			ItemPackageReference component = hand.currentAttachedObject.GetComponent<ItemPackageReference>();
			if (component == null)
			{
				return null;
			}
			return component.itemPackage;
		}

		private void HandHoverUpdate(Hand hand)
		{
			if (requireTriggerPressToTake && hand.controller != null && hand.controller.GetHairTriggerDown())
			{
				SpawnAndAttachObject(hand);
			}
		}

		private void OnHandHoverEnd(Hand hand)
		{
			if (!justPickedUpItem && requireTriggerPressToTake && showTriggerHint)
			{
				ControllerButtonHints.HideTextHint(hand, EVRButtonId.k_EButton_Axis1);
			}
			justPickedUpItem = false;
		}

		private void RemoveMatchingItemsFromHandStack(ItemPackage package, Hand hand)
		{
			for (int i = 0; i < hand.AttachedObjects.Count; i++)
			{
				ItemPackageReference component = hand.AttachedObjects[i].attachedObject.GetComponent<ItemPackageReference>();
				if (component != null)
				{
					ItemPackage itemPackage = component.itemPackage;
					if (itemPackage != null && itemPackage == package)
					{
						GameObject attachedObject = hand.AttachedObjects[i].attachedObject;
						hand.DetachObject(attachedObject);
					}
				}
			}
		}

		private void RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType packageType, Hand hand)
		{
			for (int i = 0; i < hand.AttachedObjects.Count; i++)
			{
				ItemPackageReference component = hand.AttachedObjects[i].attachedObject.GetComponent<ItemPackageReference>();
				if (component != null && component.itemPackage.packageType == packageType)
				{
					GameObject attachedObject = hand.AttachedObjects[i].attachedObject;
					hand.DetachObject(attachedObject);
				}
			}
		}

		private void SpawnAndAttachObject(Hand hand)
		{
			if (hand.otherHand != null)
			{
				ItemPackage attachedItemPackage = GetAttachedItemPackage(hand.otherHand);
				if (attachedItemPackage == itemPackage)
				{
					TakeBackItem(hand.otherHand);
				}
			}
			if (showTriggerHint)
			{
				ControllerButtonHints.HideTextHint(hand, EVRButtonId.k_EButton_Axis1);
			}
			if (!(itemPackage.otherHandItemPrefab != null) || !hand.otherHand.hoverLocked)
			{
				if (itemPackage.packageType == ItemPackage.ItemPackageType.OneHanded)
				{
					RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType.OneHanded, hand);
					RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType.TwoHanded, hand);
					RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType.TwoHanded, hand.otherHand);
				}
				if (itemPackage.packageType == ItemPackage.ItemPackageType.TwoHanded)
				{
					RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType.OneHanded, hand);
					RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType.OneHanded, hand.otherHand);
					RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType.TwoHanded, hand);
					RemoveMatchingItemTypesFromHand(ItemPackage.ItemPackageType.TwoHanded, hand.otherHand);
				}
				spawnedItem = UnityEngine.Object.Instantiate(itemPackage.itemPrefab);
				spawnedItem.SetActive(true);
				hand.AttachObject(spawnedItem, attachmentFlags, attachmentPoint);
				if (itemPackage.otherHandItemPrefab != null && hand.otherHand.controller != null)
				{
					GameObject gameObject = UnityEngine.Object.Instantiate(itemPackage.otherHandItemPrefab);
					gameObject.SetActive(true);
					hand.otherHand.AttachObject(gameObject, attachmentFlags, string.Empty);
				}
				itemIsSpawned = true;
				justPickedUpItem = true;
				if (takeBackItem)
				{
					useFadedPreview = true;
					pickupEvent.Invoke();
					CreatePreviewObject();
				}
			}
		}
	}
}
