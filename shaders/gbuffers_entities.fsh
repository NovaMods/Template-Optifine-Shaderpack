#version 450 compatibility

in vec4 vertex_color_vs;
in vec3 normal_vs;
in vec2 texcoord_vs;

uniform sampler2D texture;

layout(location = 0) out vec4 color_fs;

void main() {
    vec4 texture_color = texture2D(texture, texcoord_vs);

    color_fs = texture_color * vertex_color_vs;
}
