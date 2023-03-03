Shader "ShaderCourse/LessonNineShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _Opp("Operation", Float) = 0
        _DistortionIntensity("Distortion Intensity", Float) = 0
        _DistortionAnimation("Distortion Animation", Vector) = (0, 0, 0, 0)
        _UVTex("UV Texture", 2D) = "white" {}

        _Input("Input", float) = 0
        _Speed("Speed", float) = 0
        _OffsetX("OffsetX", float) = 0
        _OffsetY("OffsetY", float) = 0

        
        
        
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_Opp]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vertex2fragment
            {
                float4 vertex : SV_POSITION;
                float4 uv1_uv2 : TEXCOORD0;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _UVTex;
            float4 _UVTex_ST;          

            float _DistortionIntensity;
            float4 _DistortionAnimation;

            float _Input;
            float _Speed;
            float _OffsetX;
            float _OffsetY;

            vertex2fragment vert (appdata v)
            {
                vertex2fragment o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv1_uv2.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1_uv2.zw = TRANSFORM_TEX(v.uv, _UVTex);

                // not using _OffsetX yet
                o.uv1_uv2.zw += float2(_Speed * _Time.x, _Speed * _OffsetY) * _UVTex_ST.xy;
            

                return o;
            }

            fixed4 frag (vertex2fragment i) : SV_Target
            {
                // sample uv texture
                fixed4 uvTex = tex2D(_UVTex, i.uv1_uv2.zw);
                // sample main tex 
                _DistortionAnimation = float4(_Input + 0.01, _Input + 0.02, 0, 0);
                fixed4 mainTex = tex2D(_MainTex, i.uv1_uv2.xy + _Time.xx * _DistortionAnimation.xy + uvTex * _DistortionIntensity);




                


                fixed3 color = mainTex.rgb; // +secondaryTex.rgb;

          
                fixed alpha = 1;
                return fixed4(color,alpha);
                //return mainTex;
                
            }
            ENDCG
        }
    }
}
