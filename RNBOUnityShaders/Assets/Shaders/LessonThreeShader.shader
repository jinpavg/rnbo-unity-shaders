Shader "ShaderCourse/LessonThreeShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Color ("Tint Color", COLOR) = (1,1,1,1)
        _Input("Input", float) = 0.1
        _Speed ("Speed", Range(0.0, 100.0)) = 1
        _Interval ("Interval", Range(0.0, 10.0)) = 0.5
        _Amp ("Amplitude", Range(0.0, 10.0)) = 0.5
        _Offset ("Offset", Range(0.0, 10.0)) = 0.5
        //_Scale("Scale", Range(0.1, 10.0)) = 1.0

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _Opp("Operation", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "LightMode"="ForwardBase"}
        LOD 100

        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_Opp]
        // FinalValue = SrcFactor(srcalpha) * SrcValue +(opp) DstFactor (1-srcalpha) * DstValue
        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 display : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Speed;
            //float _Scale;
            float _Interval;
            float _Offset;
            float _Amp;
            float _Input;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float scale = sin(_Interval * _Input) / _Amp + _Offset;
                o.uv = (o.uv - 0.5) * (1 / scale) + 0.5;
                // sliding uvs 
                //o.uv += float2(_Time.x * _Speed, _Time.x * _Speed) * _MainTex_ST.xy;
                

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(i.uv, 0, 1);
                fixed4 tex = tex2D(_MainTex, i.uv);

                return tex * _Color;
                //return fixed4(tex.rgb * i.display, 1);
            }
            ENDCG
        }
    }
}
