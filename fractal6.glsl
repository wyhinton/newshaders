// #version 300 es
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;

#define c1 vec3(2.,0.5,1.5)

vec2 triangle_wave(vec2 a,float scale){
    return abs(fract((a+c1.xy)*scale)-.5);
}

vec2 rot(vec2 uv,float a){
	return vec2(uv.x*cos(a)-uv.y*sin(a),uv.y*cos(a)+uv.x*sin(a));
}

vec3 hsl2rgb( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}

vec3 HueShift (in vec3 Color, in float Shift)
{
    vec3 P = vec3(0.55735)*dot(vec3(0.55735),Color);
    
    vec3 U = Color-P;
    
    vec3 V = cross(vec3(0.55735),U);    

    Color = U*cos(Shift*6.2832) + V*sin(Shift*6.2832) + P;
    
    return vec3(Color);
}


precision mediump float;

void main()
{
    vec3 col;  
    float t1 = 26.*16.;
    float st = sin(u_time);
    vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/t1/2.0;
    uv += vec2(u_time/2.0,u_time/3.0)/t1/8.0;
    float scale = c1.z;
    float b = 0.;
    float q = 0.;
    float inc = 0.001;
    for(int i=0;i<6;i++)
    {
        vec2 t2 = vec2(0.0);
        for(int k = 0; k < 9; k++){    
            b+= inc;
            vec2 zf = (t2.yx*st)/(scale);
            uv += (t2.yx)/(scale*.95+sin(u_time*.00001));
            t2 = triangle_wave((rot(uv.yx, u_time*.0001)-.5/b*.5+sin(b*u_time*.01)*.5),scale)*scale;
            vec2 t3 = triangle_wave(rot(uv, u_time*.001),scale)/scale;
            uv.yx = -(t2+pow(t3, vec2(.5+pow(b, 1.))))*.899;
        }
          for(int k = 0; k < 9; k++){    
              q+= inc;
                uv.xy += sin(rot(vec2(gl_FragCoord.y), u_time*.01)/u_resolution.yx)*1.55*q;
        }
        //  uv.x += mod(uv.y,.1);
        col.x = abs(uv.y-uv.x+col.x);
        // col.y += abs(uv.y-uv.x/2.)*.4;
        // col.y = sin(uv.y*inc*100.+u_time);
        col = col.yzx;
        // col.r += st*gl_FragCoord.y-.5*.01;
    }
    // vec3 tttt = hsl2rgb(col);
    vec3 tttt = HueShift(col, sin(uv.x+u_time)); 
    // col *= abs(tttt)*.1;
    col += tttt;
    gl_FragColor = vec4(col,1.0);   
}

