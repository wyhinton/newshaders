
precision highp float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;

#define ITERS 12

//PARAMS
//0 1
float Distortion = 0.;
//-1 1
float Speed = .2;
//0 1
float Brightness = .6;
//0 100
float YScale = 15.;
//0 100
float XScale = 13.;
//0 1000
float TimeOffset = 0.;
//0 10
float scale = 2.;
//1 2
float scale1 = 1.275;
//END_PARAMS

void main()
{
    //  = vec4(0.0);
    float localTime = u_time+TimeOffset;
    vec3 col=vec3(0.0),col_prev=vec3(0.0);
    vec2 uv = (gl_FragCoord.xy*XScale-u_resolution.xy)/u_resolution.y/YScale;
    //uv.y += (u_time)/25.0;
    float s1 = scale1*scale+uv.y+localTime*Speed;
    for(int c=0;c<ITERS;c++){
        col_prev = col;
        for(int i=0;i<ITERS;i++)
        {
            uv= -fract(-uv-((vec2(uv.x/scale1-uv.y/scale1,uv.y/scale-uv.x/scale)/(scale))))/scale1;
            uv.x *= -scale1;
            uv = fract(uv.yx/s1)*s1;
            uv.y /= scale1;
        }
        col[2] = abs(fract(uv.y)-fract(uv.x));
        col = ((col+col_prev.yzx))*(Brightness);
	}
    float st = sin(u_time);
    vec2 baseUV = gl_FragCoord.xy/u_resolution.xy;
    vec2 distortionUV = col.rg;
    gl_FragColor = vec4(col, 1.);
    
}
