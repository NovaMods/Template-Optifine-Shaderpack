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

// The normal of the current vertex
//
// A normal is a vector that points directly away from its vertex. It's used in lighting calculations and many other 
// effects
out vec3 normal_vs;

// The texture coordinate of the current vertex
//
// A texture coordinate, here abbrebiated as `texcoord`, is a coordinate on a texture that a mesh uses. You can think 
// of this like latitude and longitute on a rectangular map, except that the map is your texture and the latitude and
// longitude go from 0 to 1 instead of 0 to 360
//
// Minecraft uses a texture atlas, which puts the textures for many different materials into one large texture. This 
// is the right decision for Minecraft, but it means that the texture coordinated for an individual block face won't
// range from 0 to 1, they'll have a much smaller range inside that range based on their position in the texture atlas
out vec2 texcoord_vs;

// The strength of block and sky light at the current vertex*
//
// Minecraft calculates two light levels for every vertex*: 
// - Light from emissive blocks such as torches or glowstone
// - Light from ths sky. This is a combination of if there's a clear path from the current vertex* to the sky and the 
//   time of day
// 
// Both of these light levels range from 0 to 255
//
// Minecraft stores in the light levels in the chuck mesh's vertex data, which we access with this variable
//
// * Minecraft calcualtes light per vertex is you have smooth lighting enabled, but it calcualtes it per block if you
// don't
out vec2 light_levels_vs;

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

    // Retrieve vertex normals from the OpenGL builtin attribute for normals
    normal_vs = gl_Normal.xyz;

    // Retrieve texture coordinates from the OpenGL builtin attribute for the first set of texture coordinates
    //
    // Legacy OpenGL provides a few vertex attributes for texture coordinates
    texcoord_vs = gl_MultiTexCoord0.st;
    
    // Retrieve block and sky light levels from the OpenGL builtin attribute for the second set of texture coordinates
    //
    // Texture coordinates are actually a vector with four components. You can store any kind of data you want in these
    // components, not just texture coordinates. Minecraft uses the first two components of the second set of "texture
    // coordinates" - aka four-component vectors - to the block and sky light level, respectively
    light_levels_vs = gl_MultiTexCoord1.st;

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