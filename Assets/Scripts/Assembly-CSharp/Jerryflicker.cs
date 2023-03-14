using System.Collections;
using UnityEngine;

public class Jerryflicker : MonoBehaviour
{
	private Light testlight;

	public float minWaitTime;

	public float maxWaitTime;

	private void Start()
	{
		testlight = GetComponent<Light>();
		StartCoroutine(Flashing());
	}

	private IEnumerator Flashing()
	{
		while (true)
		{
			yield return new WaitForSeconds(Random.Range(minWaitTime, maxWaitTime));
			testlight.enabled = !testlight.enabled;
		}
	}
}
