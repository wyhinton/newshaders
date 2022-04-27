#version 300 es
precision mediump float;



uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_3;


out vec4 fragColor;
float pattern(vec2 point, float radius, float cellSize) {
    float c = 4.0 * radius * cellSize;
    // half
    float h = c / 2.0;  
    point = mod(point + h, c) - h;
    return length(point) - radius;
}

vec3 dots(vec2 uv){
    uv = mat2(0.707, -0.707, 0.707, 0.707) * uv;
    float radius = 0.005;
    float dist = pattern(uv, radius, 1.5);
    vec3 dotcolor = vec3(0.95, 0.9, 0.8);
    vec3 bg = vec3(0.5, 0.8, 0.75);
 
    float sharpness = 100.;
	float circ = radius * sharpness - dist * sharpness;
    
    float alpha = clamp(circ, 0.0, 1.0);
   
    vec3 color = mix(bg, dotcolor, alpha);
	// fragColor = vec4(color,1.0); 
    return color;

}

void main()
{
    
	vec2 uv = ((gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y) / 0.5;
    uv = mat2(0.707, -0.707, 0.707, 0.707) * uv;
    vec3 color = dots(uv);
    // float radius = 0.005;
    // float dist = pattern(uv, radius, 1.5);
    // vec3 dotcolor = vec3(0.95, 0.9, 0.8);
    // vec3 bg = vec3(0.5, 0.8, 0.75);
 
    // float sharpness = 100.;
	// float circ = radius * sharpness - dist * sharpness;
    
    // float alpha = clamp(circ, 0.0, 1.0);
   
    // vec3 color = mix(bg, dotcolor, alpha);
	fragColor = vec4(color,1.0);
    // fragColor = vec4(0.);
    
}

