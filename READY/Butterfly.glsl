precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;
// The sdf and cloud rendering was inspired of another shader on the site, but i lost it!
vec2 hash23(vec3 p3)
{
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

vec3 getRd(vec3 ro, vec3 lookAt, vec2 uv ){
    vec3 dir = normalize(lookAt - ro);
    vec3 right = normalize(cross(dir,vec3(0,1,0)));
    vec3 up = normalize(cross(dir,right));
    return normalize(dir + right*uv.x + up * uv.y);
}

#define rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))

#define NUM_OCTAVES 5

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}


float fbm(vec3 x) {
    float v = 0.0;
    float a = 0.5;
    vec3 shift = vec3(100);
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(x);
        x = x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

//PARMAS
//0 100
float Fill = 3.; 
float Smoothness = 2.5;
float PMult1 = .5;
float Step1 = .1;
float Step2 = .9;
float MaxD = 1.;
float RotationSpeed = 1.1;
float RotationSpeed2 = 1.1;
//-5 5
float Attenuation = 1.;
//END_PARAMS


vec3 map(vec3 p){
    vec3 d = vec3(0);
    
    p *= 2.;
    vec3 op = p;
        float st = sin(u_time);
    float att = Attenuation;

    for(float i = 0.; i < 3.; i++){
        
        p = abs(p);
        p *= PMult1;
        
        p -= 0.;
        p /= clamp(dot(p,p),-.5,2.4);
        
        p += sin(dot(p,cos(p*1. + i + u_time*RotationSpeed)))*att*.4;
        p.yz *= rot(.6 + i*0.);
        p.xy *= rot(.6*u_time*RotationSpeed2);
        
        
        
        d += exp(-abs(dot(op,p))*40.)*att*2.;
        //d += abs(dot(sin(p*1.),cos(p*1.5 + 15.)))*att;
        att *= 0.7;
    }
    //d = clamp(d,0.,1.);
    //d = max(d,0.);
    d *= 1.4;
    if(false){
        d = d/(d+1.);
        d = pow(d,vec3(4.4))*25.;
    }//d = 1.-abs(d);
    //d = abs(d);
    //d = clamp(d,0.,1.);
    //d = max(d,0.);
    //d = mix(vec3(1,0.5,1)*0.1,vec3(1,1.5,1),d*5.);
    
    //d = mix(vec3(1.4,0.1,0.4),vec3(0,0.4,0.2),d*0.5)*d;
    d = (0.5 + 0.5*sin(vec3(1,2,5)*1. - cos(d*29.)*0. + 4. + d.x*0.4))*d*1.;
    // d *= fbm(d);
    //d = exp(d*1000.);
    //d = pow(d,vec3(5.));
    return d;
}

vec3 getMarch(vec3 ro, vec3 rd, vec2 uv){

    vec3 col = vec3(0);
    
    float iters = 400.;
    float maxD = MaxD;
    vec3 accum = vec3(0);
    //float stepSz = 1./iters*maxD*mix(0.99,1.,hash23(vec3(uv*2000.,110.)).x);
    
    ro -= rd * hash23(vec3(uv*2000.,510. + RotationSpeed)).x*1./iters*maxD;
    vec3 p = ro;
    
    float t = 0.;
    float stepSz = 1./iters*maxD;
    float st = sin(u_time);
    p*=fbm(p);
    for(float i = 0.; i < 300.; i++){
        // if (i< iters){
            vec3 d = map(p);
                    
            accum += d*stepSz*(Fill-dot(accum,accum));
            stepSz = 1./iters*maxD*mix(1.,Smoothness,exp(-dot(d,d)*44.));
        
            if(dot(accum,accum) > 0.9 || t > maxD)
                break;
            t += stepSz; 
            p += rd*stepSz;
        // }
       
    }
    
    //col += accum;
    col = mix(col,accum,dot(accum,accum)*15.);
    //col = mix(col,accum,pow(dot(accum,accum)*4.,1.)*144.);
    
    col = col/(2. + col*0.7)*1.4;
    col = pow(col,vec3(0.8235, 0.5333, 0.5333));
    return col;
}

void main()
{
    vec2 uv = (gl_FragCoord.xy - 0.5*u_resolution.xy)/u_resolution.y;

    vec3 col = vec3(0);
    
    
    vec3 ro = vec3(0,0,-2);
    ro.xz *= rot((u_time + sin(u_time*1.4))*0.2);
    ro.xy *= rot((u_time*0.8 + sin(u_time*1.7)*0.6)*0.1);
    
    vec3 lookAt = vec3(0);
    vec3 rd = getRd(ro,lookAt,uv);
    
    
    col = getMarch(ro, rd, uv);
    // vec3 rd = normalize(vec3(uv,1));
    
    
    
    // col+=sin(smoothstep(col.g, .1, .5)+u_time);

    float st = sin(u_time);
    gl_FragColor = vec4(col,1.0);
    gl_FragColor = vec4(sin(smoothstep(Step1, Step2, length(col))));
} 