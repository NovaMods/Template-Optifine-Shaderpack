#version 450 compatibility

out vec4 vertex_color_vs;
out vec3 normal_vs;
out vec2 texcoord_vs;

void main() {
    vertex_color_vs = gl_Color;
    normal_vs = vec3(0, 1, 0);//gl_Normal.xyz;
    texcoord_vs = gl_MultiTexCoord0.st;

    gl_Position = ftransform();
}