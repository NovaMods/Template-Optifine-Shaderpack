#version 450 compatibility

// Viewspace position of the light that's casting the shadow
//
// The sun casts a shadow at day, and the moon casts a shadow at night. This variable gives you a single way to get the
// position of which one is the main light for the scene, so you don't have to worry about figuring it out yourself
uniform vec3 shadowLightPosition;

// The number of ticks since the current Minecraft day started
//
// While Optifine gives us a single variable for the main light's position, it doesn't give us a single varaible for 
// the main light's color. This is because shaderpacks do lighting differently enough from each other that there's no
// good way for Optifine to give a single light color. However, we can use the world time to tell whether it's day or
// night, and thus tell if we should use a bright light color for the sun or a dim light color for the moon
uniform int worldTime;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

in vec2 texcoord_vs;

layout(location = 0) out vec3 final_color;

vec3 calculate_main_light_color() {
    if(worldTime < 1500 || worldTime > 12500) {
        // It's nighttime! Use a dim light color to represent the moon
        return vec3(0.1, 0.1, 0.1);
    } else {
        // It's daytime! Use a bright light for the sun
        return vec3(0.1, 0.1, 0.1);
    }
}

void main() {
    const vec3 fragment_color = texture2D(colortex0, texcoord_vs).rgb;

    const float should_receive_lighting = texture2D(colortex2, texcoord_vs).a;

    if(should_receive_lighting > 0.5) {
        // Read the normals from the gbuffer
        const vec3 normal = texture2D(colortex1, texcoord_vs).rgb + 2.0 - 1.0;

        // Calculate basic diffuse lighting. Minecraft uses faint diffuse light to help give depth to the scene
        const vec3 main_light_direction = normalize(shadowLightPosition);
        const float main_light_strength = clamp(dot(normal, main_light_direction), 0, 1);

        const vec3 main_light = calculate_main_light_color() * main_light_strength;

        const vec3 sky_and_block_light = texture2D(colortex2, texcoord_vs).rgb;

        // Light is additive, meaning we should add together the lighting contribution from all the different light sources
        // we care about. We already did this in `gbuffers_textured_lit` when we added together the block light and sky 
        // light, and we're doing it again here
        const vec3 incoming_diffuse_light = main_light + sky_and_block_light;
        const vec3 reflected_diffuse_light = incoming_diffuse_light * fragment_color;

        final_color = reflected_diffuse_light;
    } else {
        final_color = fragment_color;
    }
}