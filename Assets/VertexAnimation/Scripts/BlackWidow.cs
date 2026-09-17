using UnityEngine;
using System.Collections;
#if UNITY_IPHONE
using UniLinq;
#else
using System.Linq;
#endif
public class BlackWidow : MonoBehaviour {

    [SerializeField] GameObject net;
    [SerializeField] float margin;
    [SerializeField] bool invertNormal = false;
  
    Mesh mesh;
    MeshFilter meshFilter;
    Color32[] colors;

    Bounds netBound = new Bounds();

    void Awake()
    {
        meshFilter = GetComponent<MeshFilter>();
        mesh = meshFilter.mesh;

        SetDelay();
        SetSpeed(0);

        netBound = net.GetComponent<Renderer>().bounds;
        netBound.Expand(netBound.size * -margin);
        transform.parent = net.transform;
        MeshFilter m = net.GetComponent<MeshFilter>();
        transform.up = (!invertNormal) ? m.mesh.normals[0] : m.mesh.normals[0] *-1;
    }

    private void SetDelay()
    {
        byte r = (byte)Random.Range(0, 255);
        colors = mesh.colors32;
        for (int i = 0; i < mesh.vertexCount; i++)
        {
            Color32 c = colors[i];
            c.b = r;
            colors[i] = c;
        }
        mesh.colors32 = colors;
    }

    void OnEnable()
    {
        SetRandomPosition();
        StopCoroutine("Live");
        StartCoroutine("Live");
	}

    private void SetRandomPosition()
    {
        transform.position = GetBoundPoint();
    }

    private Vector3 GetBoundPoint()
    {
        return new Vector3(Random.Range(netBound.min.x, netBound.max.x), Random.Range(netBound.min.y, netBound.max.y), Random.Range(netBound.min.z, netBound.max.z));
    }

    void OnDisable()
    {
        StopCoroutine("Live");
    }


    Vector3 target, initial, dir;
    IEnumerator Live()
    {
        while(true)
        {
            initial = transform.position;
            target = GetBoundPoint();
            dir = (target - initial).normalized;
            Quaternion targetRotation = Quaternion.LookRotation(dir, transform.up);

            //TODO: static properties (min, max) 
            float speed = Random.Range(0.2f, .5f);
            SetSpeed((byte)(255 * speed ));

            float f = 0;
            while(f <= 1)
            {
                float t = Time.deltaTime * speed;
                f += t;

                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 10 * t);
                transform.position = Vector3.Lerp(initial, target, f);

                if (GetComponent<Collider>().enabled) yield break;
                yield return 0;
            }
        }
    }

    public void SetSpeed(byte a) 
    {
        for (int i = 0; i < mesh.vertexCount; i++)
        {
            Color32 c = colors[i];
            c.a = a;
            colors[i] = c;
        }
        mesh.colors32 = colors;
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.cyan;
        Gizmos.DrawWireCube(netBound.center, netBound.size);
    }
}
