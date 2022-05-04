#version 300 es

precision highp float;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

out vec4 fragColor;

// https://www.shadertoy.com/v

void main()
{
    vec3 metaballs[5];
    float size = .1;
    // metaballs[0] = vec3(sin(u_time) * 0.1 + 0.4, cos(u_time) * 0.1 + 0.4, 0.2);
    vec2 um = u_mouse.xy/u_resolution.xy;
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    float dist = length(uv-um);
    // metaballs[3] = vec3(0.4, 0.5, 0.02);
    vec2 p1 = vec2(0.1, 0.5);
    metaballs[0] = vec3(p1, size/pow(length(p1-um), .1));
    metaballs[1] = vec3(0.5, 0.5, size);
    metaballs[2] = vec3(.9, 0.5, size);
    
    // metaballs[4] = vec3(u_mouse.xy / u_resolution.y, 0.1);

	vec2 ssnormal = gl_FragCoord.xy / u_resolution.y;
    
    float frag = 0.0;
    
    for(int i = 0; i < 5; i++)
        frag += metaballs[i].z / distance(metaballs[i].xy, uv);
    
    frag = clamp(frag, 0.0, 1.0);
    frag = frag == 1.0 ? 1.0 : 0.0;
    
    fragColor = vec4(frag, frag, frag, 1.0);

    // float t = length(uv-um);
    // fragColor = vec4(t);
    // fragColor = vec4(ssnormal.x);
}