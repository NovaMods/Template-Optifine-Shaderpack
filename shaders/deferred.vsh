#version 450 compatibility

out vec2 texcoord_vs;

void main() {
    texcoord_vs = gl_MultiTexCoord0.st;

    gl_Position = ftransform();
}