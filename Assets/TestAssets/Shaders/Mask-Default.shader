// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Budge Studios/Mask/Default" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1.0)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SrcTex ("Mask", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Source", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Destination", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 0
		[Toggle(_ZWrite)] _ZWrite ("ZWrite", Float) = 1
		[Toggle(_Invert)] _Invert ("Invert", Float) = 0
	}
	
	SubShader 
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Blend [_BlendSrc] [_BlendDst]
		Cull [_Cull]
		ZWrite [_ZWrite]
		
        Pass 
        {            
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
							
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			sampler2D _SrcTex;
			fixed4 _SrcTex_ST;
			fixed4 _Color;
			float _Invert;
					
			struct v2f 
			{
			    float4 pos : SV_POSITION;
			    float2 uv : TEXCOORD1;
			    float2 uvMask : TEXCOORD2;
			};
			
			v2f vert (appdata_base v)
			{
			    v2f o;			    
			    o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
			    o.uvMask = TRANSFORM_TEX(v.texcoord.xy, _SrcTex);
			    o.pos = UnityObjectToClipPos(v.vertex);
			    
			    return o;
			}
			
			half4 frag( v2f i ) : COLOR
			{
				half4 col = tex2D(_MainTex, i.uv) * _Color;
				col.a *= abs(_Invert - tex2D(_SrcTex, i.uvMask).a);
			    return col;
			}
			
			ENDCG
	  	}
	} 
}
