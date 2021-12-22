Shader "Unlit/Lighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SubTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment hogeFrag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            sampler2D _SubTex;
            float4 _MainTex_ST;

            float2 test(float2 uv)
            {
                return uv * 2.0;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float cosResult = dot(i.normal, normalize(_WorldSpaceLightPos0.xyz));
                fixed4 col1 = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_SubTex, i.uv);
                // col1 * cosResult + col2 * (1 - cosResult)
                float4 result = lerp(col1, col2, cosResult);
                result.a = 0.5;
                return result;
            }
            
            fixed4 hogeFrag (v2f i) : SV_Target
            {
                float2 uv = test(i.uv);
                
                float cosResult = dot(i.normal, normalize(_WorldSpaceLightPos0.xyz));
                fixed4 col1 = tex2D(_MainTex, uv);
                fixed4 col2 = tex2D(_SubTex, uv);
                // col1 * cosResult + col2 * (1 - cosResult)
                float4 result = lerp(col1, col2, cosResult);
                return result;
            }
            ENDCG
        }
    }
}
