using UnityEngine;

public class ViveGripExample_Bubble : MonoBehaviour
{
	private float life = 5f;

	private float bounces = 2f;

	private void Start()
	{
		life += Random.Range(0f, 4f);
	}

	private void Update()
	{
		life -= Time.deltaTime;
		if (life < 0f)
		{
			Object.Destroy(base.gameObject);
		}
	}

	private void OnCollisionEnter()
	{
		bounces -= 1f;
		if (bounces < 0f)
		{
			Object.Destroy(base.gameObject);
		}
	}
}
