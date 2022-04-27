#version 300 es
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

out vec4 fragColor;

vec3 Sphere(vec2 uv, vec2 position, float radius)
{
    float h = uv.y/2.;
    h = uv.y;
    float w = uv.x;
    vec2 newuv = vec2(w,h);
    float dist = radius / distance(newuv, position);
    return vec3(dist * dist);
}

void main()
{

    vec2 uv = gl_FragCoord.xy/u_resolution.xy; // <0, 1>
    uv -= 0.5; // <-0.5,0.5>
    uv.x *= u_resolution.x/u_resolution.y; // fix aspect ratio
    
    vec3 pixel = vec3(0.0, 0.0, 0.0);
    
    vec2 positions[4];

    vec2 m = 2.0*vec2(u_mouse.xy - .5 * u_resolution.xy) / u_resolution.y;
    float d = length(uv-m);
    float mult = 1.-abs(d*3.);

    float y = .0;
    float q = (gl_FragCoord.y/u_resolution.y/1000.);
    vec2 p1 = vec2(q-.25, y);
    vec2 p2 = vec2(q+.24, y);
    vec2 p3 = vec2(q, y);

    float radius = .06;

    positions[0] = p1;
    positions[1] = p2;
    positions[2] = p3;
    
    int z = 0;
    for	(int i = 0; i < 3; i++){
        float div = length(positions[i]-m)*.03;
        div = smoothstep(div, .001, .1);
        float rd = min( .1, 1./length(positions[i]-m)*.01);
        pixel += Sphere(uv*1.5, positions[i], radius+rd);
    }
        
    
    pixel = step(1.0, pixel) * pixel;
    float t = fract((gl_FragCoord.xy/u_resolution.xy).x*3.);
    fragColor = vec4(pixel, 1.0);
}