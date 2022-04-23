// Copyright (c) 2022 Guilty
// MIT License
// GitHub : https://github.com/GuiltyWorks
// Twitter : @GuiltyWorks_VRC
// EMail : guiltyworks@protonmail.com

Shader "Guilty/StandardSquareDot" {
    Properties {
        _DotColor ("Dot Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _BackgroundColor ("Background Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Glossiness ("Smoothness", Range(0.0, 1.0)) = 0.5
        _Metallic ("Metallic", Range(0.0, 1.0)) = 0.0
        _Resolution ("Resolution", Range(1.0, 64.0)) = 8.0
        _DotSize ("Dot Size", Range(0.0, 1.0)) = 0.5
        _Ratio ("Ratio", Range(-1.0, 1.0)) = 0.0
        [MaterialToggle] _Shift ("Shift", Float) = 1.0
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
        }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input {
            float3 worldPos;
        };

        float4 _DotColor;
        float4 _BackgroundColor;
        float _Glossiness;
        float _Metallic;
        float _Resolution;
        float _DotSize;
        float _Ratio;
        float _Shift;

        void surf(Input IN, inout SurfaceOutputStandard o) {
            float3 worldPos = mul(UNITY_MATRIX_V, float4(IN.worldPos, 1.0)).xyz;
            float2 screenPos = -(round(worldPos.xy / worldPos.z * 100000000.0) / 100000000.0);
            screenPos = abs(((frac(((screenPos * _Resolution) - 0.5)) - 0.5) * 2.0));
            screenPos = abs(((frac((float2(screenPos.x, (screenPos.y + ((step(0.5, fmod(round(abs((screenPos.x / 1.0))), 2.0)) * 0.5) * _Shift))) - 0.5)) - 0.5) * 2.0));
            float isInPixel = (step(screenPos.r, (saturate((_Ratio * 1.0 + 1.0)) * _DotSize)) * step(screenPos.y, (saturate((_Ratio * -1.0 + 1.0)) * _DotSize)));
            float4 c = (_DotColor * isInPixel) + (_BackgroundColor * (1.0 - isInPixel));
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
