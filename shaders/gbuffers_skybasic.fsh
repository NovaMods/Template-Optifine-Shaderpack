#version 450 compatibility

/*
 * Interpolated values from the vertex shader. The shader compiler matches these to vertex shader output by their
 * names
 */
in vec4 vertex_color_vs;

/*
 * Fragment shader outputs
 */

// Output to the rendertarget bound to location 0
//
// Fragment shaders can output to special textures called rendertargets. Optifine will automaticlaly create all the
// rendertargets that your shaderpack needs to use
//
// This shaderpack uses rendertarget 0 as the output for the color of the geometry
layout(location = 0) out vec4 color_fs;
layout(location = 2) out vec4 light_color_fs;

/*
 * Fragment processing code
 */

// The GPU will run main once for every fragment that's covered by a the current mesh
void main() {
    color_fs = vertex_color_vs;

    // Objects drawn by this shader should _not_ receive lighting, so we write 0 to all channels of the light color
    // rendertarget
    light_color_fs = vec4(0);
}
