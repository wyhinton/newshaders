#version 300 es

precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;


out vec4 fragColor;
// Dave Hashkins
vec2 hash22(vec2 p){
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+19.19);
    return fract((p3.xx+p3.yz)*p3.zy);
}

vec2 R;


void main()
{
    float Scale = 24.;
    float Size = 50.;
    R = u_resolution.xy;
    vec2 uv = vec2(gl_FragCoord.xy - 0.5*R.xy)/R.y;
    vec4 col = vec4(1);
    uv += Scale;
    float mouse_x = u_mouse.x/u_resolution.x;
    float mouse_y = u_mouse.y/u_resolution.y;
    vec2 id = floor(uv*Size);
    vec2 ruv = fract(uv*Size)-0.5;
    float tt = 0.;
    vec2 n =  vec2(pow(sin(tt*0.4 + hash22(id).x*1.5),2.0),
                  pow(cos(tt+ hash22(id*3.0 + 2.0).y*5.0),2.0));
    float d = max(dot(vec2(1., -1.), n), 0.01);
    float c = smoothstep(1.51, 0.3, length(ruv));
    vec3 mcol = mix(vec3(0.0, 0.0, 0.0), vec3(1.0, 0.9843, 0.0), d)*c*d;
    col.xyz = mcol;
    col *= mouse_x;
    fragColor = col;
    
}