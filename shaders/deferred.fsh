#version 450 compatibility

/*
 * Calculates lighting for opaque objects
 */

// Viewspace position of the light that's casting the shadow
//
// The sun casts a shadow at day, and the moon casts a shadow at night. This variable gives you a single way to get the
// position of which one is the main light for the scene, so you don't have to worry about figuring it out yourself
uniform vec3 shadowLightPosition;

// The number of ticks since the current Minecraft day started
uniform int worldTime;

// Color texture
uniform sampler2D colortex0;

// Viewspace normals
uniform sampler2D colortex1;

// Color of blockcombined block and sky light
uniform sampler2D colortex2;

in vec2 texcoord_vs;

layout(location = 0) out vec3 final_color;

vec3 calculate_main_light_color() {
    if(worldTime < 1500 || worldTime > 12500) {
        // It's nighttime! Use a dim light color to represent the moon
        return vec3(0.01);
    } else {
        // It's daytime! Use a bright light for the sun
        return vec3(1);
    }
}

void main() {
    // Read the color texture, bringing it into linear space for lighting
    const vec3 fragment_color = pow(texture2D(colortex0, texcoord_vs).rgb, vec3(2.2));

    // skip lighting calculatations for e.g. the sky
    const bool should_receive_lighting = texture2D(colortex2, texcoord_vs).a > 0.5;

    if(should_receive_lighting) {
        // Read the normals from the gbuffer
        const vec3 normal = texture2D(colortex1, texcoord_vs).rgb * 2.0 - 1.0;

        // Calculate basic diffuse lighting. Minecraft uses faint diffuse light to help give depth to the scene
        const vec3 main_light_direction = normalize(shadowLightPosition);
        const float main_light_strength = clamp(dot(normal, main_light_direction), 0, 1);   // Lambertian diffuse
        const vec3 main_light = calculate_main_light_color() * main_light_strength;

        const vec3 block_and_sky_light = texture2D(colortex2, texcoord_vs).rgb;

        const vec3 incoming_diffuse_light = main_light + block_and_sky_light;
        const vec3 reflected_diffuse_light = incoming_diffuse_light * fragment_color;

        final_color = reflected_diffuse_light / (vec3(1) + reflected_diffuse_light);
    } else {
        final_color = fragment_color;
    }

    // Correct for gamma before sending the final color to the render target
    final_color = pow(final_color, vec3(1.0 / 2.2));
}