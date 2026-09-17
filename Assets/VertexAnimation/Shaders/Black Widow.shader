Shader "PanicPump/Creepyland/Black Widow" {
	Properties {
		_MainTex ("Diffuse Color (RGB) Gloss (A)", 2D) = "white" {} 
		_Speed ("Speed", Float) = 5
		_Walk ("Walk", Float) = .2
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Shininess ("Shininess", Float) = 10
	}
	SubShader {
		Pass {      
			Tags { "LightMode" = "ForwardBase" } 
 
			Cull Off

			CGPROGRAM
 
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile FOG_EXP FOG_EXP2 FOG_LINEAR
			#pragma target 3.0
			#include "UnityCG.cginc"
			uniform fixed4 _LightColor0;
			uniform fixed4 _SpecColor;
			uniform sampler2D _MainTex;	 
			uniform fixed _Speed;
			uniform fixed _Walk;
			uniform fixed _Shininess;
 
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed4 texcoord : TEXCOORD0;
				fixed4 color: COLOR;
				fixed3 normal : NORMAL;
			};
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				float fogCoord : TEXCOORD1;
				fixed3 viewDir : TEXCOORD5;
				fixed4 posWorld : TEXCOORD7;
				fixed3 normalDir : TEXCOORD6;
			};
 
			vertexOutput vert(vertexInput input) 
			{
				vertexOutput output;

 				fixed4 v = input.vertex;
				fixed speed = input.color.a * _Speed;
				fixed delay = input.color.b * speed;
				fixed c = cos((_Time.w + delay) * speed) * _Walk;
				fixed s = sin((_Time.w + delay) * speed) * _Walk;
				v.z += c * input.color.r;
				v.z += -c * input.color.g;
				v.y += max(0, -s) * input.color.r;
				v.y += max(0, s) * input.color.g;
				
				output.pos = UnityObjectToClipPos(v);
				output.normalDir = normalize(mul(fixed4(input.normal, 0.0), unity_WorldToObject).xyz);
				output.posWorld = mul(unity_ObjectToWorld, input.vertex);
				output.viewDir = normalize(_WorldSpaceCameraPos - output.posWorld.xyz);
				output.tex = input.texcoord;
				
				UNITY_CALC_FOG_FACTOR(output.pos.z);
				output.fogCoord = unityFogFactor;
				
				return output;
			}
 
			fixed4 frag(vertexOutput input) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, input.tex.xy);
				
				fixed3 normalDirection = input.normalDir;
				fixed3 lightDirection = _WorldSpaceLightPos0.xyz;
 
				fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb;
 
				fixed3 diffuseReflection = _LightColor0.rgb * max(0.0, dot(normalDirection, lightDirection));
 
				fixed4 lighting = fixed4(ambientLighting + diffuseReflection * 2, 1.0);

				fixed3 specularReflection = _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot( reflect(-lightDirection, normalDirection), input.viewDir)), _Shininess) * tex.a;

				fixed4 result = tex * lighting + fixed4(specularReflection, 1);

				result.rgb = lerp(unity_FogColor.rgb, result.rgb, saturate(input.fogCoord));
				return result;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}