using UnityEngine;
using UnityEngine.AI;

public class AiFollow : MonoBehaviour
{
	public Transform destination;

	private NavMeshAgent agent;

	private void Update()
	{
		agent = base.gameObject.GetComponent<NavMeshAgent>();
		agent.SetDestination(destination.position);
	}
}
