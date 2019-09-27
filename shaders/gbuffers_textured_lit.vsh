#version 450 compatiblity

/*
 * Vertex attributes
 */
in vec3 position_in;
in vec3 normal_in;
in vec2 uv_in;
in vec2 light_in;

/*
 * Vertex shader outputs
 */
out vec3 normal_vs;
out vec2 uv_vs;
out vec2 light_vs;

void main() {
    normal_vs = normal_in;
    uv_vs = uv_in;
    light_vs = light_in;

    // ftransform is legacy OpenGL, but we have to use it because Minecraft is built around legacy OpenGL
    //
    // A modern OpenGL renderer would upload the model matrix, view matrix, and projection matrix to shader uniforms 
    // and perform the multiplication itself, instead of relying on the fixed-function matrix stack like Minecraft
    gl_Position = ftransform(vec4(position_in, 1));
}