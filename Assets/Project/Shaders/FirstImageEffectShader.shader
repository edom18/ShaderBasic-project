Shader "Hidden/FirstImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size("Size", Float) = 9.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Size;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float iSize = _Size;
                uv = floor(uv * iSize * 15.0) / 15.0 / iSize;
                fixed4 col = tex2D(_MainTex, uv);
                return col * float4(1, 1, 1, 1);
            }
            ENDCG
        }
    }
}
