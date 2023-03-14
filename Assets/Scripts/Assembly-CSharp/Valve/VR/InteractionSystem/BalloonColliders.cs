using UnityEngine;

namespace Valve.VR.InteractionSystem
{
	public class BalloonColliders : MonoBehaviour
	{
		public GameObject[] colliders;

		private Vector3[] colliderLocalPositions;

		private Quaternion[] colliderLocalRotations;

		private Rigidbody rb;

		private void Awake()
		{
			rb = GetComponent<Rigidbody>();
			colliderLocalPositions = new Vector3[colliders.Length];
			colliderLocalRotations = new Quaternion[colliders.Length];
			for (int i = 0; i < colliders.Length; i++)
			{
				colliderLocalPositions[i] = colliders[i].transform.localPosition;
				colliderLocalRotations[i] = colliders[i].transform.localRotation;
				colliders[i].name = base.gameObject.name + "." + colliders[i].name;
			}
		}

		private void OnEnable()
		{
			for (int i = 0; i < colliders.Length; i++)
			{
				colliders[i].transform.SetParent(base.transform);
				colliders[i].transform.localPosition = colliderLocalPositions[i];
				colliders[i].transform.localRotation = colliderLocalRotations[i];
				colliders[i].transform.SetParent(null);
				FixedJoint fixedJoint = colliders[i].AddComponent<FixedJoint>();
				fixedJoint.connectedBody = rb;
				fixedJoint.breakForce = float.PositiveInfinity;
				fixedJoint.breakTorque = float.PositiveInfinity;
				fixedJoint.enableCollision = false;
				fixedJoint.enablePreprocessing = true;
				colliders[i].SetActive(true);
			}
		}

		private void OnDisable()
		{
			for (int i = 0; i < colliders.Length; i++)
			{
				if (colliders[i] != null)
				{
					Object.Destroy(colliders[i].GetComponent<FixedJoint>());
					colliders[i].SetActive(false);
				}
			}
		}

		private void OnDestroy()
		{
			for (int i = 0; i < colliders.Length; i++)
			{
				Object.Destroy(colliders[i]);
			}
		}
	}
}
