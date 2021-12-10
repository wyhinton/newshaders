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

precision mediump float;
#define PI 3.14159265358979323846

vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
	float unit = u_resolution.x/freq;
	vec2 ij = floor(p/unit);
	vec2 xy = mod(p,unit)/unit;
	//xy = 3.*xy*xy-2.*xy*xy*xy;
	xy = .5*(1.-cos(PI*xy));
	float a = rand((ij+vec2(0.,0.)));
	float b = rand((ij+vec2(1.,0.)));
	float c = rand((ij+vec2(0.,1.)));
	float d = rand((ij+vec2(1.,1.)));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

float pNoise(vec2 p, int res){
	float persistance = .5;
	float n = 0.;
	float normK = 0.;
	float f = 4.;
	float amp = 1.;
	int iCount = 0;
	for (int i = 0; i<50; i++){
		n+=amp*noise(p, f);
		f*=2.;
		normK+=amp;
		amp*=persistance;
		if (iCount == res) break;
		iCount++;
	}
	float nf = n/normK;
	return nf*nf*nf*nf;
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
    float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));
    // uv.y*=v*10.;
    // float p = pNoise(uv.xy, 2);
    float z = 0.;

    // uv *= pow(nrand3(uv).y, 4.);
    for(int i=0;i<6;i++)
    {
        vec2 t2 = vec2(0.);
        // uv = rot(uv, u_time*b);
        // uv.yx += smoothstep(.1, 1.*(st*.01), .5);
        // vec3 xxx = rayDirection(, vec2(.1), uv);
        for(int k = 0; k < 9; k++){    
            b+= v*.02;
            uv += pow(v, length(uv.xy));
            // uv += pow(nrand3(uv.xy).y, 2.1);
            // float adder = sin(u_time*.00001);
            // float adder = pNoise(uv.xy)
            vec2 zf = (t2.yx)/(scale*.95);
            
            uv += (t2.yx)/(scale*.95+sin(u_time*.00001));
            t2 = triangle_wave((rot(uv.yx, u_time*.0001)-.5/b*.5+sin(b*u_time*.01)*.5),scale)*scale;
            vec2 t3 = triangle_wave(rot(uv, u_time*.001),scale)/scale;
            uv.yx = -(t2+pow(t3, vec2(.5+pow(b, 1.))))*.9;
            // uv *= pow(nrand3(uv.xy).y, 40.); // uv.xy += rot(vec2(.5+sin(u_time*.0005)), u_time*.0001).x*b;
        }

          for(int k = 0; k < 5; k++){    
              z+= .2;
              uv.xy += sin(ceil(uv.xy/sin(uv.y)*st));
            //   uv.xy += *=mod(u_time, 1000.);
              uv.xy += sin(gl_FragCoord.xy/u_resolution.xy)*(0.1+cos(u_time*.0001)*sin(u_time*.02*z))+-1.*v*z*.001;

            // uv.xy += rot(vec2(.5+sin(u_time*.0005)), u_time*.0001).x*b;
        }
        // uv.xy += pNoise(vec2(u_time), 1);
        // uv.x *= pow(2., cos(uv.y));
        // col.x = length(uv.x);
        // col.y = length(uv.x)*10.;
        // col.x = abs(length(uv.xy)*-uv.x+col.x);
        vec2 c = gl_FragCoord.xy;
        // uv*=fract(u_time*.1);
        // c.y += 100000.;
        // c.x += 1.5;
        // uv += smoothstep(abs(c.xy), uv , vec2(.0001));
        // col.x *= smoothstep(c.x,1 ., col.y);
        col.x = smoothstep(sin(u_time*cos(u_time*.012443)), sin(u_time*.01), uv.x-uv.y);
    
        // float test = smoothstep(1., col.z, st);

        // col = vec3(uv.yx, uv.yx);
        col = col.yzx;
        
        col.x *= sin(length(uv.xy*-1.)*2.);
        // col = vec3(p*.0001);
        // col *= uv.x-(uv.x-1.01);
        col.b -= sin(uv.x);;
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

