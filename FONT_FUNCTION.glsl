#version 300 es

precision highp float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_11;

out vec4 fragColor;

float Letter(sampler2D Font,vec2 P,int L, int col)
{
   P *= 10.;
   vec2 position = (P+vec2(L-(L/col)*col,(col-1)-L/col))/float(col);
//    position *= 10.;
   return texture(Font,position).r; 	   
}

void main()
{
    vec2 U = .5+(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;
    // U *= 10.;
    float T = Letter(u_texture_11,U,int(u_time/5.), 15)*step(abs(U.x-.5),.5);
    // float T = Letter(u_texture_11,U,u_time/5)*step(abs(U.x-.5),.5);
    fragColor = vec4(T);
    // fragColor = vec4(smoothstep(.8,.5,T)*vec3(1),1);
}