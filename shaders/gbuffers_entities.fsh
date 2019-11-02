#version 450 compatibility

/*
 * Fragment shader for entities, including tile entities
 */

in vec4 vertex_color_vs;
in vec3 normal_vs;
in vec2 texcoord_vs;
in float shadow_light_strength;

uniform sampler2D texture;

layout(location = 0) out vec4 color_fs;
layout(location = 1) out vec3 normal_fs;
layout(location = 2) out vec4 light_color_fs;

void main() {
    vec4 texture_color = texture2D(texture, texcoord_vs);

    color_fs = texture_color * vertex_color_vs;

    normal_fs = normal_vs * 0.5 + 0.5;

    light_color_fs = vec4(vec3(shadow_light_strength), 1);
}
