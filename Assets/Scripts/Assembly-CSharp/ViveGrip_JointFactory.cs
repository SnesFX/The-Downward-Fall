using UnityEngine;

public static class ViveGrip_JointFactory
{
	public static float LINEAR_DRIVE_MULTIPLIER = 1f;

	public static float ANGULAR_DRIVE_MULTIPLIER = 1f;

	public static ConfigurableJoint JointToConnect(GameObject jointObject, Rigidbody desiredObject, Quaternion controllerRotation)
	{
		ViveGrip_Grabbable component = desiredObject.gameObject.GetComponent<ViveGrip_Grabbable>();
		ConfigurableJoint configurableJoint = jointObject.AddComponent<ConfigurableJoint>();
		SetLinearDrive(configurableJoint, desiredObject.mass);
		if (component.anchor.enabled)
		{
			SetAnchor(configurableJoint, desiredObject, component.RotatedAnchor());
		}
		if (component.ApplyGripRotation())
		{
			SetAngularDrive(configurableJoint, desiredObject.mass);
		}
		if (component.SnapToOrientation())
		{
			SetTargetRotation(configurableJoint, desiredObject, component.rotation.localOrientation, controllerRotation);
		}
		configurableJoint.connectedBody = desiredObject;
		return configurableJoint;
	}

	private static void SetTargetRotation(ConfigurableJoint joint, Rigidbody desiredObject, Vector3 desiredOrientation, Quaternion controllerRotation)
	{
		joint.targetRotation = controllerRotation;
		joint.targetRotation *= Quaternion.Euler(desiredOrientation);
		joint.targetRotation *= Quaternion.Inverse(desiredObject.transform.rotation);
	}

	private static void SetAnchor(ConfigurableJoint joint, Rigidbody desiredObject, Vector3 anchor)
	{
		joint.autoConfigureConnectedAnchor = false;
		joint.connectedAnchor = desiredObject.transform.InverseTransformVector(anchor);
	}

	private static JointDrive LinearJointDrive(float strength, float damper, float maxForce)
	{
		JointDrive result = default(JointDrive);
		result.positionSpring = strength;
		result.positionDamper = damper;
		result.maximumForce = maxForce;
		return result;
	}

	private static JointDrive AngularJointDrive(JointDrive baseJointDrive, float strength, float damper)
	{
		JointDrive result = baseJointDrive;
		result.positionSpring = strength;
		result.positionDamper = damper;
		return result;
	}

	private static void SetLinearDrive(ConfigurableJoint joint, float mass)
	{
		float lINEAR_DRIVE_MULTIPLIER = LINEAR_DRIVE_MULTIPLIER;
		float strength = 15000f * mass * lINEAR_DRIVE_MULTIPLIER;
		float damper = 50f * mass * lINEAR_DRIVE_MULTIPLIER;
		float maxForce = 350f * mass * lINEAR_DRIVE_MULTIPLIER;
		joint.xDrive = LinearJointDrive(strength, damper, maxForce);
		joint.yDrive = LinearJointDrive(strength, damper, maxForce);
		joint.zDrive = LinearJointDrive(strength, damper, maxForce);
	}

	private static void SetAngularDrive(ConfigurableJoint joint, float mass)
	{
		float aNGULAR_DRIVE_MULTIPLIER = ANGULAR_DRIVE_MULTIPLIER;
		float strength = 300f * mass * aNGULAR_DRIVE_MULTIPLIER;
		float damper = 10f * mass * aNGULAR_DRIVE_MULTIPLIER;
		joint.rotationDriveMode = RotationDriveMode.XYAndZ;
		joint.angularYZDrive = AngularJointDrive(joint.angularYZDrive, strength, damper);
		joint.angularXDrive = AngularJointDrive(joint.angularXDrive, strength, damper);
	}
}
