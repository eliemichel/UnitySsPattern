using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeController : MonoBehaviour
{
    Vector3 p;

    void Start()
    {
        p = transform.position;
    }
    
    void Update()
    {
        float t = Time.timeSinceLevelLoad;
        transform.position = p + (new Vector3(1, 0, 0)) * Mathf.Sin(t) + (new Vector3(0, 0, 1)) * Mathf.Cos(t);
    }
}
