#version 450 compatibility

in vec4 at_tangent;

uniform vec3 shadowLightPosition;

uniform mat4 gbufferModelViewInverse;

out vec4 vertex_color_vs;
out vec3 normal_vs;
out vec2 texcoord_vs;
out float shadow_light_strength;

void main() {
    vertex_color_vs = gl_Color;

    normal_vs = normalize(gl_NormalMatrix * gl_Normal);

    texcoord_vs = gl_MultiTexCoord0.st;

    gl_Position = ftransform();

    shadow_light_strength = max(dot(shadowLightPosition, vec3(0, 1, 0)), 0.1);
}