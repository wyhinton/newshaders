precision highp float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;


//change this constant to get different patterns
#define c1 vec4(2.0,2.5,1.4,0)


vec2 triangle_wave(vec2 a,float scale){
    return abs(fract((a+c1.xy)*scale)-.5);
}

//PARAMS 
//0 1
float Scale = .1;
//0 1
float Offset = .18;
//0 1
float YSpeed = .1;
//0 1
float XSpeed = 0.;
//0 100
int Iterations1 = 10;
//0 100
int Iterations2 = 9;
//1 2
float Scale2 = 1.05;
//0 1
float FMult = .8;
//0 1000
float TimeOffset = 0.;
//0 1
float FlashSpeed = 2.9; 

//END_PARAMS

void main()
{
    gl_FragColor = vec4(0.0);
    vec3 col;  
    float t1 = Scale/.1;
    float offset = Offset;
    float scale2 = 1.05;
    float localTime = u_time+TimeOffset;
    vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/t1/2.0;
    uv += vec2(u_time*XSpeed,u_time*YSpeed)/t1/8.0;
    for(int c=0;c<10;c++){
        float scale = c1.z;
        if (c< Iterations1){
        for(int i=0;i<100;i++)
        {
            if (i < Iterations2){
                uv = triangle_wave(uv+offset,scale)+triangle_wave(uv.yx,scale);
                uv.x /= -1.;
                uv = triangle_wave(uv+c1.w+col.xy,scale);
                scale /= Scale2+col.x;
                offset *= Scale2;
                uv = uv.yx;
            }
        }
        }

     col[c] = fract((uv.x)-(uv.y));
	}
    float st = sin(u_time);
    float a = smoothstep(.0, .0, 1.-length(col)+localTime*FlashSpeed);
    // float a = smoothstep(.0, .0, 1.-length(col)*FMult*st);
    
    gl_FragColor = vec4(vec3(col),1.0);
    gl_FragColor = vec4(vec3(length(col)),a);
    
}
