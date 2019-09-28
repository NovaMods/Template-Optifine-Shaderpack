# Optifine Shaderpack Template

This is an example shaderpack I made which implements vanilla Minecraft lighting. It's intended to help beginners learn about graphics programming both in the sense of developing Minecraft shaders and in the sense of the broader industry

## Getting Started

This shaderpack implements a few key Minecraft shader programs: `gbuffers_textured`, `gbuffers_textured_lit`, and `composite`. These programs show how one might structure a Minecraft shaderpack. We're only overriding a handful of shaders, but there's many more:

- shadow
- gbuffers_basic
  - gbuffers_skybasic
  - gbuffers_textured
    - gbuffers_skytextured
    - gbuffers_clouds
    - gbuffers_beaconbeam
    - gbuffers_armor_glint
    - gbuffers_spidereyes
    - gbuffers_textured_lit
      - gbuffers_entities
      - gbuffers_hand
      - gbuffers_water
      - gbuffers_terrain
        - gbuffers_damagedblock
        - gbuffers_water
        - gbuffers_hand_water


Optifine defines a hierarchy of shaders with each one rendering more specific kinds of geometry. If your shaderpack doesn't have a shader from the bottom of the hierarchy, Optifine with attempt to load that shader's fallback. Foe example, if your shaderpack doesn't have `gbuffers_hand`, Optifine will try to load `gbuffers_textured_lit`. If that shader is also missing, Optifine will then try `gbuffers_textured`, then `gbuffers_basic`

This hierarchy of shader fallbacks allows you to implement a specific shader for specific kinds of geometry, while also letting you implement a couple of "base" shaders that will render 90% of what you need. You can implement `gbuffers_textured_lit` and `gbuffers_water`, which would allow you to do one thing for most geometry in Minecraft while doing something different for the water, such as water waves

### gbuffers_textured
gbuffers_textured renders all geometry that has a texture, but doesn't receive block or sky light. Additionally, this shader is a fallback for `gbuffers_textured_lit`, `gbuffers_skytextured`, `gbuffers_clouds`, `gbuffers_armorglint`, `gbuffers_beaconbeam`, and `gbuffers_spidereyes`. Optifine will, at a bare minimum, use `gbuffers_textured` for particles. Because of the exact shaders present in this shaderpack, Optifine will use `gbuffers_textured` for particles, the sun and moon, clouds, armor glint, beacon beams, and spider eyes

### gbuffers_textured_lit
gbuffers_textures_lit renders geometry which has a texture and has lighting. Additionally, it's a fallback for `gbuffers_entities`, `gbuffers_hand`, `gbuffers_water`, and `gbuffers_terrain`. Optifine uses this shader for lit particles, the world border, and any