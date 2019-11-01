#version 450 compatibility

in vec4 vertex_color_vs;
in vec2 texcoord_vs;

uniform sampler2D texture;

layout(location = 0) out vec4 color_fs;
layout(location = 2) out vec4 light_color_fs;

void main() {
    color_fs = vertex_color_vs * texture2D(texture, texcoord_vs);

    // Objects drawn by this shader should _not_ receive lighting, so we write 0 to all channels of the light color
    // rendertarget
    light_color_fs = vec4(0);
}