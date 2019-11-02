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
uniform sampler2D lightmap;

/*
 * Fragment shader outputs
 */

layout(location = 0) out vec4 color_fs;
layout(location = 1) out vec3 normal_fs;
layout(location = 2) out vec4 light_color_fs;

/*
 * Fragment processing code
 */

// The GPU will run main once for every fragment that's covered by a the current mesh
void main() {
    // Combine the color in the texture atlas with the vertex color. Minecraft stores biome-specific colors in the
    // vertex color, and we can multiply that with the texture color to get the block's final color
    vec4 texture_color = texture2D(texture, texcoord_vs);
    color_fs = texture_color * vertex_color_vs;

    // Output the normals
    //
    // Each component of a normal vector ranges from [-1, 1], but rendertargets (by default) range from [0, 1], so we 
    // have to do a little math to bring the normals into the correct range
    normal_fs = normal_vs * 0.5 + 0.5;

    // Convert the light level, which ranges from 0 to 255, into texture coordinates, which range from 0 to 1
    vec2 light_lookup_coordinates = light_levels_vs / vec2(255);
    // Get the light color for the current light level
    vec3 light_color = texture2D(lightmap, light_lookup_coordinates).rgb;

    // We use the fourth component of the light color rendertarget to mark if we should receive lighting or not. 
    // Objects drawn by this shader shoudl receive lighting, so we write 1 to the fourth channel of the light color
    // rendertarget
    light_color_fs = vec4(light_color, 1);
}
