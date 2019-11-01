#version 450 compatibility

/* 
 * Vertex shaders for objects in the sky that have a texture - aka the sun and the moon
 */

/*
 * Vertex shader outputs
 */

out vec4 vertex_color_vs;
out vec2 texcoord_vs;

void main() {
    vertex_color_vs = gl_Color;
    texcoord_vs = gl_MultiTexCoord0.xy;
    
    gl_Position = ftransform();
}