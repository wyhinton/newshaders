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
    // col = vec4(0.0);
    vec3 col;  
    float t1 = 36.*16.;
    float st = sin(u_time);
    vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/t1/2.0;
    uv += vec2(u_time/2.0,u_time/3.0)/t1/8.0;
    float scale = c1.z;
    float b = 0.;
    float inc = 0.001;
    // uv = rot(uv, u_time*.001);
    for(int i=0;i<6;i++)
    {
        vec2 t2 = vec2(0.);
        // uv = rot(uv, u_time*b);
        // uv.yx += smoothstep(.1, 1.*(st*.01), .5);
        for(int k = 0; k < 9; k++){    
            b+= inc;
            uv += (t2.yx)/(scale);
            t2 = triangle_wave((rot(uv.yx, u_time*.0001)-.5/b*.5+sin(b*u_time*.01)*.5),scale)*scale;
            //  t2 = triangle_wave((rot(uv.yx, u_time*.001)-.5/b),scale)*scale;
            // t2 += rot(t2, u_time)*b;
            vec2 t3 = triangle_wave(rot(uv, u_time*.001),scale)/scale;
            // uv.yx = -(t2+pow(t3, vec2(.5)))*.9;
            uv.yx = -(t2+pow(t3, vec2(.5+b)))*.9;
            // uv.yx = -(t2+pow(t3, vec2(.5+b)))*.9;
            // uv.yx += sin(rot(uv*.000, u_time*.1*b));
            // uv.yx *= floor(sin(uv.x)+.5);
            // uv.yx += max(fract(uv.xy), 2.5+st*.01)*(uv.x*b*.0005);
            // uv.yx -= min(fract(uv.xy), 2.5+st*.05)*(uv.y*b);
            // uv.yx += rot(t2, u_time)*.0001;
            //    uv.yx += max(fract(uv.xy), 2.5+st*.0001);
            // uv = rot(uv, u_time*b*.01);
            //  uv.yx *= .99;
        }
        col.x = abs(uv.y-uv.x+col.x);
        // float test = smoothstep(1., col.z, st);

        // col.xyz = vec3(1.0);
        // col.y += sin((uv.y-.5+st)-uv.x+col.y*st*.001);
        // col.x *= abs(pow(uv.x, uv.y)+col.x*st);
        // col.y *= st*gl_FragCoord.y;
        // col.x = smoothstep(uv.y, triangle_wave((uv.yx-.5),scale).x, .1);
        col = col.yzx;
        col.x *= sin(length(col.xz)*2.);
        col.z *= cos(length(col.xz*.3)*2.+u_time)*2.;
        // col.y *= log(length(col.xz*.3)*2.+u_time)*2.;
            // float test = col.z;
        // float test = smoothstep(.5, 0., sin(col.z+st));
        // vec3 ttc = vec3(test*1.5, test*.2, test*1.6+uv.y);
        // col = vec3(col.z);
        // col = vec3(test);
        // col += ttc;
        // col = ttc;
    }
    gl_FragColor = vec4(col,1.0);   
}

