
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_5;
uniform sampler2D u_texture_4;
uniform sampler2D u_texture_3;
uniform sampler2D u_texture_2;
uniform sampler2D u_texture_1;

#define T(a) texture2D(u_texture_3,p.xz*.1-t*a)


void main() {
    // vec2 p = (2.0*gl_FragCoord.xy / u_resolution.xy)-1.0;
    // vec3 c = gl_FragCoord;
    vec4 p = vec4(gl_FragCoord.xy,0.,1.)/u_resolution.xyxy-.5, d=p, e;
    float t = u_time+6., x;
    d.y -= .2;
    p.z += t*.3;
    vec4 o = vec4(0.);
    for(float i=1.; i>0.; i-=.02)
    {
        e = sin(p*6.+t);
        x = abs(p.y+e.x*e.z*.1-.75)-(e=T(.01)+T(.02)).x*.08;
        o = .3/length(p.xy+vec2(sin(t),-.4)) - e*i*i;
        if(x<.01) break;
        p -= d*x*.5;
     }
    gl_FragColor = o;
}

