using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ManipulateShader : MonoBehaviour
{
    Renderer rend;
    BufferAnalysisHelper helper;
    const int pluginKey = 1;
    [SerializeField] double lows;
    [SerializeField] double mids;
    [SerializeField] double highs;
    [SerializeField] float scale = 10;
    [SerializeField] System.Int32 param = 5;
    [SerializeField] System.Int32 paramTwo = 8;
    [SerializeField] System.Int32 paramThree = 10;
    [SerializeField] AudioClip buffer;
    System.UInt32 inport;
    System.UInt32 inportTwo;

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();
        helper = BufferAnalysisHelper.FindById(pluginKey);
        rend.material.shader = Shader.Find("ShaderCourse/LessonThreeShader");

        if (buffer)
            {
                float[] samples = new float[buffer.samples * buffer.channels];
                buffer.GetData(samples, 0);
                helper.LoadDataRef("sampleOne", samples, buffer.channels, buffer.frequency);
                inport = BufferAnalysisHelper.Tag("playSampleOne");
                inportTwo = BufferAnalysisHelper.Tag("stopSampleOne");
            }
        helper.SetParamValue(3, 1);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            helper.SendMessage(inport, 1);
        }
        if (Input.GetKeyDown(KeyCode.S))
        {
            helper.SendMessage(inportTwo, 1);
        }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            helper.SendMessage(inport, 1);
        }
        if (Input.GetKeyUp(KeyCode.Space))
        {
            helper.SendMessage(inportTwo, 1);
        }

        helper.GetParamValue(param, out lows);
        rend.material.SetFloat("_Input", ((float)lows) * scale);
        helper.GetParamValue(paramTwo, out mids);
        rend.material.SetFloat("_Amp", ((float)mids) * scale);
        helper.GetParamValue(paramThree, out highs);
        rend.material.SetFloat("_Offset", ((float)highs) * scale);
    }
}
