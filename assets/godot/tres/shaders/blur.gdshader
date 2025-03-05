shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float blur_amount : hint_range(0.0, 10.0); // Avoid negative values
uniform float mix_amount : hint_range(0.0, 1.0);
uniform vec4 color_over : source_color;

void fragment() {
    vec2 tex_size = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 uv = SCREEN_UV;
    
    vec4 sum = vec4(0.0);
    float weight_sum = 0.0;
    
    // Sample weights for a simple 5-tap Gaussian approximation
    float weights[5] = float[](0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

    for (int i = -2; i <= 2; i++) {
        vec2 offset = vec2(float(i)) * (blur_amount / tex_size);
        sum += texture(SCREEN_TEXTURE, uv + offset) * weights[i + 2];
        sum += texture(SCREEN_TEXTURE, uv - offset) * weights[i + 2];
        weight_sum += 2.0 * weights[i + 2];
    }

    sum /= weight_sum;

    vec4 fin = mix(sum, color_over, mix_amount);
    COLOR = fin;
}
