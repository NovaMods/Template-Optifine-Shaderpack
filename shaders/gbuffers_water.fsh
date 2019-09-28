#version 450 compatibility

/*
 * Interpolated values from the vertex shader. The shader compiler matches these to vertex shader output by their
 * names
 */
in vec4 vertex_color_vs;
in vec3 normal_vs;
in vec2 texcoord_vs;
in vec2 light_levels_vs;

/*
 * Uniforms
 */

// Minecraft's texture atlas
uniform sampler2D texture;

// A look-up-table (LUT) from block and sky light strength to light color
//
// When Minecraft sends block and sky light levels to the GPU, it's only sending their intensities. It does this 
// instead of sending the full light color because the full light color is three times as much data. 
uniform sampler2D lightmap;

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

/*
 * Fragment processing code
 */

// The GPU will run main once for every fragment that's covered by a the current mesh
void main() {
    // Combine the color in the texture atlas with the vertex color. Minecraft stores biome-specific colors in the
    // vertex color, and we can multiply that with the texture color to get the block's final color
    vec4 texture_color = texture2D(texture, texcoord_vs);
    vec3 color = texture_color.rgb * vertex_color_vs.rgb;
    float alpha = texture_color.a * vertex_color_vs.a;

    // Convert the light level, which ranges from 0 to 255, into texture coordinates, which range from 0 to 1
    vec2 light_lookup_coordinates = light_levels_vs / vec2(255);
    // Get the light color for the current light level
    vec3 block_sky_light = texture2D(lightmap, light_lookup_coordinates).rgb;

    vec3 lit_color = color * block_sky_light;

    color_fs = vec4(lit_color, alpha);
}
