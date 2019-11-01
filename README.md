# Optifine Shaderpack Template

This is an example shaderpack I made which implements vanilla Minecraft lighting. It's intended to help beginners learn about graphics programming both in the sense of developing Minecraft shaders and in the sense of the broader industry

## Getting Started

### Optifine's Rendering Pipeline

Optifine dives shaderpack developers some flexibility in how they light the scene. You can use pure forward lighting, pure defrerred lighting, or a hybrid approach with deferred lighting for opaque geometrey and forward lighting for transparent geometry. This shaderpack uses the third option

We can think of the rendering pipeline in terms of passes. Each pass performs a specific task, and each pass can read from and write to different resources. Here's the passes we'll be using:

#### Shadow pass

The first pass in either lighting pipeline is the shadow pass. In the shadow pass, Optifine renders a shadowmap from the perspective of the main light in the sky. This is the sun during the day and the moon during the night. The shadow pass uses the shader `shadow` for all geometry. It can write to up to two color rendertargets

The shadow pass produces a two shadow maps: one from before transparents Optifine renders transparent objects, and one from after. This allows you to do things like refraction or cloudy water

#### GBuffer pass

A deferred lighting pipeline doesn't calculate lighting when an object is drawn. Instead, it writes the object's material's parameters to a set of rendertargets called a _geometry buffer_, or "gbuffer" for short. Your gbuffer can have up to seven rendertargets of any format you choose, but this shaderpack only uses three rendertargets

In the gbuffer pass, Optifine renders all opaque geometry. It does this by using the shaders whose names begin with `gbuffers_`, except for `gbuffers_water` and `gbuffers_hand_water`. Shaders in the gbuffer pass can read from the shadowmapa or the shadow color rendertargets, and they can write to the gbuffer. If we were implementing forward lighting we'd read from those shadowmaps and possibly the shadow color images, but we'll save that for later

#### Deferred lighting pass

The deferred lighting pass is where we calculate lighting for opaque geometry

### Fallback hierarchy

Optifine allows you to override many different shaders, but it doesn't require you to override every single one. In order to do that, Op~tifine defines a fallback for many of the optional shaders, so that they geometry that would have used a missing shader instead uses that shader's fallbck (or the fallback's fallback, if the fallback is also missing). 

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
        - gbuffers_block
        - gbuffers_water
        - gbuffers_hand_water


Optifine defines a hierarchy of shaders with each one rendering more specific kinds of geometry. If your shaderpack doesn't have a shader from the bottom of the hierarchy, Optifine with attempt to load that shader's fallback. Foe example, if your shaderpack doesn't have `gbuffers_hand`, Optifine will try to load `gbuffers_textured_lit`. If that shader is also missing, Optifine will then try `gbuffers_textured`, then `gbuffers_basic`

This hierarchy of shader fallbacks allows you to implement a specific shader for specific kinds of geometry, while also letting you implement a couple of "base" shaders that will render 90% of what you need. You can implement `gbuffers_textured_lit` and `gbuffers_water`, which would allow you to do one thing for most geometry in Minecraft while doing something different for the water, such as water waves

_Generally speaking_, the names of the shaders correspond

### gbuffers_textured
gbuffers_textured renders all geometry that has a texture, but doesn't receive block or sky light. Additionally, this shader is a fallback for `gbuffers_textured_lit`, `gbuffers_skytextured`, `gbuffers_clouds`, `gbuffers_armorglint`, `gbuffers_beaconbeam`, and `gbuffers_spidereyes`. Optifine will, at a bare minimum, use `gbuffers_textured` for particles. Because of the exact shaders present in this shaderpack, Optifine will use `gbuffers_textured` for particles, the sun and moon, clouds, armor glint, beacon beams, and spider eyes

### gbuffers_textured_lit
gbuffers_textures_lit renders geometry which has a texture and has lighting. Additionally, it's a fallback for `gbuffers_entities`, `gbuffers_hand`, `gbuffers_water`, and `gbuffers_terrain`. Optifine uses this shader for lit particles, the world border, and any