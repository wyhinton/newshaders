// #version 300 es
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;

#define c1 vec3(2.,0.5,1.5)

vec2 triangle_wave(vec2 a,float scale){
    // scale *= .9999;
    return abs(fract((a+c1.xy)*scale)-.5);
}

vec2 rot(vec2 uv,float a){
	return vec2(uv.x*cos(a)-uv.y*sin(a),uv.y*cos(a)+uv.x*sin(a));
}

precision mediump float;

void main()
{
    // col = vec4(0.0);
    vec3 col;  
    float t1 = 26.*16.;
    float st = sin(u_time);
    vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/t1/2.0;
    uv += vec2(u_time/2.0,u_time/3.0)/t1/8.0;
    float scale = c1.z;
    float b = 0.;
    float q = 0.;
    float inc = 0.001;
    // uv = rot(uv, u_time*.001);
    for(int i=0;i<6;i++)
    {
        vec2 t2 = vec2(0.0);
        // uv = rot(uv, u_time*b);
        // uv.yx += smoothstep(.1, 1.*(st*.01), .5);
        // vec3 xxx = rayDirection(, vec2(.1), uv);
        for(int k = 0; k < 9; k++){    
            b+= inc;
            vec2 zf = (t2.yx*st)/(scale);
            uv += (t2.yx)/(scale*.95+sin(u_time*.00001));
            t2 = triangle_wave((rot(uv.yx, u_time*.0001)-.5/b*.5+sin(b*u_time*.01)*.5),scale)*scale;
            vec2 t3 = triangle_wave(rot(uv, u_time*.001),scale)/scale;
            uv.yx = -(t2+pow(t3, vec2(.5+pow(b, 1.))))*.899;
            // uv.xy += rot(vec2(.5+sin(u_time*.0005)), u_time*.0001).x*b;
        }
          for(int k = 0; k < 9; k++){    
              q+= inc;
                uv.xy += sin(rot(vec2(gl_FragCoord.y), u_time*.01)/u_resolution.yx)*1.55*q;
               
            // uv.xy += rot(vec2(.5+sin(u_time*.0005)), u_time*.0001).x*b;
        }
         uv.x += mod(uv.y,.1);
        // uv*=length(uv*10.);
        // uv.x *= pow(2., cos(uv.y));
        // col.x = length(uv.x);
        // col.y = length(uv.x)*10.;
        // col.x = abs(length(uv.xy)*-uv.x+col.x);
        // vec2 c = gl_FragCoord.xy;
        // c.y += 100000.;
        // c.x += 1.5;
        // uv += smoothstep(abs(c.xy), uv , vec2(.0001));
        // col.x *= smoothstep(c.x,1 ., col.y);
        col.x = abs(uv.y-uv.x+col.x);
        col.y += abs(uv.y-uv.x/2.)*.4;
    
        // float test = smoothstep(1., col.z, st);

        // col = vec3(uv.yx, uv.yx);
        col = col.yzx;
        // col.z += pow(uv.y,.5);
        // col.x += pow(uv.y,2.)+col.x;
        // col.y += abs(uv.y-uv.x+col.x);
    //    
        // col.x *= sin(length(uv.xy*-1.)*2.);
        // col *= uv.x-(uv.x-1.01);
        // col.z *= cos(length(col.xz*.3)*2.+u_time)*2.;

    }
    // vec3 dir = rayDirection(45.0, u_resolution.xy, gl_FragCoord.xy);
    // vec3 eye = vec3(0.0, 0.0, 5.0);
    // float dist = shortestDistanceToSurface(eye, dir, MIN_DIST, MAX_DIST);
    // // vec4 col = vec4(0.);
    // if (dist > MAX_DIST - EPSILON) {
    //     // Didn't hit anything
    //     col = vec3(0.2784, 0.1725, 0.1725);
	// 	return;
    // }
    
    // col = vec4(1.0, 0.0, 0.0, 1.0);
    // gl_FragColor = col;
    gl_FragColor = vec4(col,1.0);   
}

