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

void main()
{
    float st = sin(u_time);
    float Width = 16.; 
    Width += st;
    // col = vec4(0.0);
    vec3 col;  
    float t1 = Width*16.;
  
    vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/t1/2.0;
    uv += vec2(u_time/2.0,u_time/3.0)/t1/8.0;
    float scale = c1.z;
    float b = 0.;
    float inc = 0.001000;
    // uv = rot(uv, u_time*.001);
    for(int i=0;i<6;i++)
    {
        vec2 t2 = vec2(0.);
        // uv = rot(uv, u_time*b);
        // uv.yx += smoothstep(.1, 1.*(st*.01), .5);
        for(int k = 0; k < 9; k++){    
            b+= inc;
            uv += (t2.yx)/(scale);
            t2 = triangle_wave((uv.yx-.5/b),scale)*scale;
            // t2 += rot(t2, u_time)*b;
            vec2 t3 = triangle_wave(rot(uv, u_time*.001),scale)/scale;
            uv.yx = -(t2+t3)+(-(t2+t3))*.002;
     
            uv.yx += max(fract(uv.xy), 2.5+st*.01)*(uv.x*b*.0005);
            uv.yx -= min(fract(uv.xy), 2.5+st*.05)*(uv.y*b);
            // uv.yx += rot(t2, u_time)*.0001;
            //    uv.yx += max(fract(uv.xy), 2.5+st*.0001);
            // uv = rot(uv, u_time*b*.01);
            //  uv.yx *= .99;
        }
        col.x = abs(uv.y-uv.x+col.x*st);
        // col.x = smoothstep(uv.y, triangle_wave((uv.yx-.5),scale).x, .1);
        col = col.yzx;
    }
    gl_FragColor = vec4(col,1.0);   
}

