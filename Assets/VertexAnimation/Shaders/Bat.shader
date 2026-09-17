Shader "PanicPump/Creepyland/Bat" {
	Properties {
	    _Color ("Main Color", Color) = (.1, .1, .1, 1) 
		_Speed ("Speed", Float) = 5
		_Fly ("Fly", Float) = .2
		_ClothFactor ("Cloth Factor", Float) = 0.1
	}
	SubShader {
		Pass {      
			Tags { "LightMode" = "ForwardBase" } 
 
			Cull Off

			CGPROGRAM
 
			#pragma vertex vert  
			#pragma fragment frag  
			#pragma target 3.0
			#include "UnityCG.cginc"
			uniform fixed4 _LightColor0; 
			uniform fixed4 _Color; 
			uniform fixed _Speed;
			uniform fixed _Fly;
			uniform fixed _ClothFactor;
 
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed4 color: COLOR;
				fixed3 normal : NORMAL;
			};
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed3 viewDir : TEXCOORD5;
				fixed3 normalDir : TEXCOORD6;
				fixed4 posWorld : TEXCOORD7;
			};
 
			vertexOutput vert(vertexInput input) 
			{
				vertexOutput output;
 				fixed4 v = input.vertex;
				v.y += cos((_Time.w + input.color.b * _ClothFactor / _Speed + input.color.g) * _Speed) * _Fly * input.color.r;
				output.pos = UnityObjectToClipPos(v);
				output.normalDir = normalize(mul(fixed4(input.normal, 0.0), unity_WorldToObject).xyz);
				output.posWorld = mul(unity_ObjectToWorld, input.vertex);
				output.viewDir = normalize(_WorldSpaceCameraPos - output.posWorld.xyz);

				return output;
			}
 
			fixed4 frag(vertexOutput input) : COLOR
			{
				fixed3 normalDirection = input.normalDir;
				fixed3 lightDirection = _WorldSpaceLightPos0.xyz;
 
				fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb;
 
				fixed3 diffuseReflection = _LightColor0.rgb * max(0.0, dot(normalDirection, lightDirection));
 
				fixed4 lighting = fixed4(ambientLighting + diffuseReflection * 2, 1.0);
         
				return _Color * lighting;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}