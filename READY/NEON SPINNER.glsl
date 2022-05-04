precision mediump float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;

float ncos(float val) {
    return cos(val) * 0.5 + 0.5;
}

mat2 rotate(float angle){
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float random2d(vec2 coord){
    return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

#define NUM_OCTAVES 5

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

float fbm(vec2 x) {
	float v = 0.0;
	float a = 0.5;
	vec2 shift = vec2(100);
	// Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));
	for (int i = 0; i < NUM_OCTAVES; ++i) {
		v += a * noise(x);
		x = rot * x * 2.0 + shift;
		a *= 0.5;
	}
	return v;
}




//PARMAS
//0 100
int Count = 10; 
vec4 Color = vec4(1., 1., 1, 1. );
//0 1
float Speed = .1; 
//0 1 
float Inc = .1;
//0 5 
float Scale = 2.5;
//0 1
float XOff = .0;
//0 1
float YOff = .0;
//0 10
float WiggleSpeed = .0;
//0 1000
float TimeOffset = 0.;
//0 1
float Width1 = .5;
//0 1
float Width2 = 0.;
//-1 1 
float Invert = -1.;//END_PARAMS

vec3 neon(float val, vec3 color) {
    float st = sin(u_time);
	float r = clamp(val, .0, 1.0);
    float r2 = r * r;
    float r4 = r2 * r2;
    float r16 = r4 * r4;
    vec3 c = color;
    vec3 c2 = pow(color, vec3(4.0)); // A darker, more saturated version of color
    
	vec3 outp = vec3(0.0);
	outp += c2 * r2; // Darker color falloff
	outp += c * r4; // Specified Color main part
	outp += vec3(1.0) * r16; // White core
	return outp;
}





void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    uv -= .5;
    // uv.x -= .5;
    float localTime = u_time+TimeOffset;
    uv*=Scale;
    // uv-=Scale*.5;
    float st = sin(localTime);
    float nz = noise(vec2(localTime*WiggleSpeed ));
    uv -= vec2(XOff, YOff);
    uv += vec2(nz);
 
    float counter = 1.;
    vec3 col = vec3(0.);
    for(int i = 0; i < 100; i++){
        if (i<Count){
                uv *= rotate(localTime*Speed );
                // uv *= counter;
                float r = fbm(uv);
                float zq = smoothstep( .1, .19, r)*length(uv);
                // uv*=smoothstep( .1, .19, r);
                // A gradient from white in the center to black at the edges
                float center_bar = (1. - abs(uv.x - 0.))  * 2.0 + (-1.0+Width1);
            
                // Color for the bar
                vec3 color = Color.rgb;
                color *= floor(counter/2.);
                col += neon(center_bar, color);
                counter+=Inc;
                col += length(uv*r);
                col += zq*10.;
                // col = vec3(zq);
                
                // col -= r;
                col = vec3(r);
        }
  
    }
    for(int i = 0; i < 100; i++){
        if (i<Count){
                uv *= rotate(localTime*Speed );
                // uv *= counter;

                // A gradient from white in the center to black at the edges
                float center_bar = (1. - abs(uv.x - 0.5)) * 2.0 + (-1.0+Width2);
                
                // Color for the bar
                vec3 color = Color.rgb;
                color *= floor(counter/2.);
                col += neon(center_bar, color);
                counter+=Inc*Invert;
        }
  
    }


    // Output to screen
    gl_FragColor = vec4(col,length(col));
}