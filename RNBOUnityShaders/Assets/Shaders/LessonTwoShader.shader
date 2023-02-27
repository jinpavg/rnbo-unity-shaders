Shader "ShaderCourse/LessonTwoShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Color ("Tint Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
        LOD 100

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv = v.uv * float2(2, 1) + float2(0.5, 0);


                // float3 worldNormal = UnityObjectToWorldNormal(v.normal);

                // float3 lightDir = _WorldSpaceLightPos0.xyz;
                // float3 lightColor = _LightColor0;


                // float ndotl = max(0, dot(worldNormal, lightDir));
                // o.display = ndotl * lightColor + ShadeSH9(float4(worldNormal,1));

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
