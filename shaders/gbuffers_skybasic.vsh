#version 450 compatibility

/*
 * Vertex shader for textured and lit objects - entities and chunks.
 *
 * OpenGL runs a vertex shader once for every vertex a mesh. The vertex shader is responsible for calculating the 
 * position of the vertex and setting up data that gets passed to the next shader stage
 *
 * 
 */

/*
 * Uniform variables
 *
 * Uniform variables are data that an application has sent to the GPU for use in shaders. Minecraft sends a lot of data
 * to the GPU, so there's a lot of uniforms available for you to use. We won't use them all here, but you can find a 
 * list at https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt#L122
 */

/*
 * Vertex shader outputs
 */

 // The color of the current vertex
 //
 // Minecraft uses vertex colors for things that are biome-dependent such as grass color or water color
 out vec4 vertex_color_vs;

/*
 * Vertex processing code
 */

// Main function of the vertex shader. Calculates all vertex shader outputs, including the builtin `gl_Position`
void main() {
    // Retrieve vertex colors from the OpenGL builtin attribute for vertex colors
    //
    // Legacy OpenGL has a number of builtin vertex attributes, and Minecraft makes use of these to provide shaders
    // with a uniform interface for vertex data
    vertex_color_vs = gl_Color;

    // `ftransform` calculates the current vertex's position from the mesh currently being rendered
    //
    // `gl_Position` is a special varaible which outputs the vertex's position, which the rasterizer needs to know 
    // which fragments the current triangle covers
    // 
    // `ftransform` is legacy OpenGL, but we have to use it because Minecraft is built around legacy OpenGL
    //
    // A modern OpenGL renderer would upload the model matrix, view matrix, and projection matrix to shader uniforms 
    // and perform the multiplication itself, instead of doing what Minecraft does and relying on the fixed-function
    // rendering pipeline
    gl_Position = ftransform();
}