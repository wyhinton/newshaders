#version 300 es
precision mediump float;


float pi = 3.14;
int Lines = 6;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_3;


out vec4 fragColor;

vec3 indexCol(int index)
{
    vec3 aCol = vec3(1.);
    vec3 cCol = vec3(1., 0., 0.);
   
    float indexRate = float(index) / float(Lines);
    return aCol;
    //return mix(mix(aCol, bCol, smoothstep(-0.1, 0.6, indexRate)), cCol, smoothstep(0.4, 1.0, indexRate));
    return mix(aCol, cCol, smoothstep(-0.1, 1.2, indexRate));
    // return mix(aCol, cCol, smoothstep(-0.1, 1.2, indexRate));

}
float mask (vec2 uv, int index){
    float w = 4. /u_resolution.x;
    float amp = texelFetch(u_texture_3, ivec2(index * 512/Lines,.1), 0).x;
    return distance(uv.y-.5, sin(uv.x*float(index+1)*2.*pi)*.49*amp) < w ? 1. : 0.;
}

void main()
{

    vec2 uv = gl_FragCoord.xy/u_resolution.xy; // <0, 1>
    uv.x+=u_time*.1;
        // vec2 uv = fragCoord.xy / u_resolution.xy;
    vec3 baseCol = vec3(0.);
    
    float mask_ = 0.;
    vec3 bufCol = baseCol;
    
    for (int i = 0; i < Lines; ++i)
    {
        mask_ = mask(uv, i);
        bufCol = mix(bufCol, indexCol(i), mask_);
    }
    
    fragColor = vec4(bufCol, 1.);
    vec4 z = texture(u_texture_3);
    vec2 p = uv;
    float s = 50.;
    float k = (cos(2.*u_time+uv.x*uv.y*4.)+1.);
    p.y += k*step(s,mod(p.x,s*2.))*s*.5;
    p.x += k*step(s,mod(p.y,s*2.))*s*.4+30.;
    float d = length(mod(p,s)-0.5*s);    
    float points = smoothstep(d,d*.8,3.);
    fragColor = vec4(points);  
}