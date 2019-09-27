#version 450 compatibility

/*
 * Interpolated values from the vertex shader
 */
out vec3 normal_vs;
out vec2 uv_vs;
out vec2 light_vs;

/*
 * Uniforms
 *
 * I've put layout specifiers on these uniforms to illustrate how to use them. Minecraft doens't really care one way or
 * another about the uniform location, however
 */
 
 // `texture` is a reserved keyword in GLSL 450 core and the fact that Minecraft uses `texture` as a uniform name is 
 // one of two main reasons why shaders can't be written in GLSL 450 core
layout(location = 0) uniform sampler2D texture; 
