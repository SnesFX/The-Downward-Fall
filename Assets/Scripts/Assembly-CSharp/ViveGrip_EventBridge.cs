using UnityEngine;
using UnityEngine.Events;

public class ViveGrip_EventBridge : MonoBehaviour
{
	public enum ViveGripEvent
	{
		InteractionStart = 0,
		InteractionStop = 1,
		GrabStart = 2,
		GrabStop = 3,
		HighlightStart = 4,
		HighlightStop = 5,
		TouchStart = 6,
		TouchStop = 7
	}

	public ViveGripEvent viveGripEvent;

	public UnityEvent attachedFunction;

	private void Start()
	{
	}

	private void InvokeIf(ViveGripEvent thisEvent)
	{
		if (attachedFunction != null && viveGripEvent == thisEvent)
		{
			attachedFunction.Invoke();
		}
	}

	private void ViveGripInteractionStart()
	{
		InvokeIf(ViveGripEvent.InteractionStart);
	}

	private void ViveGripInteractionStop()
	{
		InvokeIf(ViveGripEvent.InteractionStop);
	}

	private void ViveGripGrabStart()
	{
		InvokeIf(ViveGripEvent.GrabStart);
	}

	private void ViveGripGrabStop()
	{
		InvokeIf(ViveGripEvent.GrabStop);
	}

	private void ViveGripHighlightStart()
	{
		InvokeIf(ViveGripEvent.HighlightStart);
	}

	private void ViveGripHighlightStop()
	{
		InvokeIf(ViveGripEvent.HighlightStop);
	}

	private void ViveGripTouchStart()
	{
		InvokeIf(ViveGripEvent.TouchStart);
	}

	private void ViveGripTouchStop()
	{
		InvokeIf(ViveGripEvent.TouchStop);
	}
}
