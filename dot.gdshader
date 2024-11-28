shader_type canvas_item;

uniform vec4 dot_color ;
uniform float radius = 0.4;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);

    if (dist < radius) {
        COLOR = dot_color;
    } else {
        discard;
    }
}
