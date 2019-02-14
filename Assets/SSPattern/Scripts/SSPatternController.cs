// (c) 2019 Elie Michel
// This code is part of UnitySsPattern and licensed under MIT license

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class SSPatternController : MonoBehaviour
{
    List<Renderer> ssRenderers;
    Camera cam;

    void Start()
    {
        cam = GetComponent<Camera>();
        Renderer[] renderers = FindObjectsOfType<Renderer>();
        ssRenderers = new List<Renderer>();
        foreach (Renderer r in renderers)
        {
            foreach (Material mat in r.materials) {
                if (mat.shader.name == "FX/SSPattern") {
                    ssRenderers.Add(r);
                    break;
                }
            }
        }
    }

    void OnPreRender()
    {
        foreach (Renderer r in ssRenderers)
        {
            float d = Vector3.Distance(cam.transform.position, r.transform.position);
            Vector3 ssPos = cam.WorldToViewportPoint(r.transform.position);
            foreach (Material mat in r.materials)
            {
                if (mat.shader.name == "FX/SSPattern") {
                    mat.SetFloat("_Distance", d);
                    mat.SetVector("_SSPos", ssPos);
                    mat.SetFloat("_ScreenRatio", cam.aspect);
                }
            }
        }
    }
}
