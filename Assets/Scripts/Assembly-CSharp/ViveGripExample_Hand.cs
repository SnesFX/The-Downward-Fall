using System.Collections;
using UnityEngine;
using UnityEngine.VR;

public class ViveGripExample_Hand : MonoBehaviour
{
	public Mesh rest;

	public Mesh primed;

	private float fadeSpeed = 3f;

	private void Start()
	{
		bool flag = base.transform.childCount == 0;
		if (UnityEngine.XR.XRDevice.model.Contains("Rift") && !flag)
		{
			base.transform.Rotate(40f, 0f, 0f);
			base.transform.Translate(0f, -0.05f, -0.03f, Space.World);
		}
	}

	private void ViveGripTouchStart()
	{
		GetComponent<MeshFilter>().mesh = primed;
	}

	private void ViveGripTouchStop(ViveGrip_GripPoint gripPoint)
	{
		if (!gripPoint.HoldingSomething())
		{
			GetComponent<MeshFilter>().mesh = rest;
		}
	}

	private void ViveGripGrabStart()
	{
		StopCoroutine("FadeIn");
		StartCoroutine("FadeOut");
	}

	private void ViveGripGrabStop(ViveGrip_GripPoint gripPoint)
	{
		StopCoroutine("FadeOut");
		StartCoroutine("FadeIn");
		if (!gripPoint.TouchingSomething())
		{
			GetComponent<MeshFilter>().mesh = rest;
		}
	}

	private IEnumerator FadeOut()
	{
		if (GetComponent<Renderer>() != null)
		{
			Color color = GetComponent<Renderer>().material.color;
			while (color.a > 0.1f)
			{
				color.a -= fadeSpeed * Time.deltaTime;
				GetComponent<Renderer>().material.color = color;
				yield return null;
			}
		}
	}

	private IEnumerator FadeIn()
	{
		if (GetComponent<Renderer>() != null)
		{
			Color color = GetComponent<Renderer>().material.color;
			while (color.a < 1f)
			{
				color.a += fadeSpeed * Time.deltaTime;
				GetComponent<Renderer>().material.color = color;
				yield return null;
			}
		}
	}
}
