//CBS
//Parallax scrolling fractal galaxy.
//Inspired by JoshP's Simplicity shader: https://www.shadertoy.com/view/lslGWr
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse; 

// http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
float field(in vec3 p,float s) {
	float strength = 7. + .03 * log(1.e-6 + fract(sin(u_time) * 4373.11));
	float accum = s/4.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < 26; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
} 

// Less iterations for second layer
float field2(in vec3 p, float s) {
	    float st = sin(u_time);
	float strength = 7. + .03 * log(1.e-6 + fract(sin(u_time) * 4373.11));
	float accum = s/4.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < 18; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w =  exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 10.2*st));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
}

vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}
vec3 hsv2rgb (in vec3 hsv) {
	hsv.yz = clamp (hsv.yz, 0.0, 1.0);
	return hsv.z * (1.0 + 0.5 * hsv.y * (cos (2.0 * 3.14159 * (hsv.x + vec3 (0.0, 2.0 / 3.0, 1.0 / 3.0))) - 1.0));
}

float rand (in vec2 seed) {
	return fract (sin (dot (seed, vec2 (12.9898, 78.233))) * 137.5453);
}

vec2 rot(vec2 uv,float a){
	return vec2(uv.x*cos(a)-uv.y*sin(a),uv.y*cos(a)+uv.x*sin(a));
}

void main() {
	vec2 m = u_mouse/u_resolution.xy;

    float VSpeed = 1.;
    float CoreSize = m.y;
    float st = sin(u_time);
	vec4 cmult1 = vec4(0.4941, 0.4941, 0.4941, 0.0); 
	vec4 lightcol = vec4(0.9882, 0.9882, 0.9882, 0.5);
    vec2 uv = 2. * gl_FragCoord.xy / u_resolution.xy - 1.;
	vec2 uvs = uv * u_resolution.xy / max(u_resolution.x, u_resolution.y/2.);
	


    vec3 p = vec3(uvs / 1., 0) + vec3(1., -1.3, 0.);
	// p += .2 * vec3(sin(u_time / 6.), sin(u_time / 12.),  sin(u_time / 128.));
	// uv += rot(uv, u_time*VSpeed);
	float freqs[4];
    float b = 0.;
    float inc = .1;
	// float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));
    // float v = .1;
	// vec3 p2 = vec3(uvs/2.);
     vec3 p2 = vec3(uvs / 2., .5+mod(u_time*.1, 500.)) + vec3(0.);
	 
    // vec3 p2 = vec3
    // p2 += 0.25 * vec3(sin(u_time / 16.), sin(u_time / 12.),  sin(u_time / 128.));
    float t2 = field2(p2,freqs[3]);
	// t2 = smoothstep(1.*st, 1., t2);
    vec4 c2 = mix(.99, .01, .1) * cmult1 * t2;
	// c2 = smoothstep(vec4(1.0, 1.0, 1.0, 0.5), c2, vec4(sin(t2)*10.)); 
	// c2 = smoothstep(c2, vec4(sin(t2)*10.), vec4(.19, .5, .6, .5)); 
    // vec4 c2 = mix(.87, .1, v) * vec4(.3 * t2  ,.8  * t2 * t2 , 3., t2);
    vec4 col = vec4(0.8471, 0.6941, 0.6941, 0.0);
	float rr = rand(vec2(mod(500., u_time)));
	float t = field(p,freqs[2]);
    col = mix(1., 1., 1.) +c2;
	col = smoothstep(c2, vec4(length(uv*CoreSize*2.)), lightcol);
	gl_FragColor = col;

}