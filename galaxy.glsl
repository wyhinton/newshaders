//CBS
//Parallax scrolling fractal galaxy.
//Inspired by JoshP's Simplicity shader: https://www.shadertoy.com/view/lslGWr
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;

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
	float strength = 7. + .03 * log(1.e-6 + fract(sin(u_time) * 4373.11));
	float accum = s/4.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < 18; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
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

vec3 tile () {
	vec2 frag = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;
	// frag *= 1.0 - 0.2 * cos (frag.yx) * sin (3.14159 * 0.5 * texture (iChannel0, vec2 (0.0)).x);
	frag *= 5.0;
	float random = rand (floor (frag));
	vec2 black = smoothstep (1.0, 0.8, cos (frag * 3.14159 * 2.0));
	vec3 color = hsv2rgb (vec3 (random, 1.0, 1.0));
	color *= black.x * black.y * smoothstep (1.0, 0.0, length (fract (frag) - 0.5));
	color *= 0.5 + 0.5 * cos (random + random * u_time + u_time + 3.14159 * 0.5);
	return color;
}

vec2 rot(vec2 uv,float a){
	return vec2(uv.x*cos(a)-uv.y*sin(a),uv.y*cos(a)+uv.x*sin(a));
}

void main() {

    float VSpeed = 1.;
    
    float st = sin(u_time);

    vec2 uv = 2. * gl_FragCoord.xy / u_resolution.xy - 1.*1.*st;
	vec2 uvs = uv * u_resolution.xy / max(u_resolution.x, u_resolution.y/2.);
	
    vec3 p = vec3(uvs / 1., 0) + vec3(1., -1.3, 0.);
	p += .2 * vec3(sin(u_time / 6.), sin(u_time / 12.),  sin(u_time / 128.));
	uv += rot(uv, u_time*VSpeed);
	float freqs[4];
    float b = 0.;
    float inc = .1;
	// float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));
    float v = .1;
     vec3 p2 = vec3(uvs / (4.+cos(u_time*0.11)*0.2+0.2+sin(u_time*0.15)*0.3+0.4), 1.5) + vec3(2., -1.3, -1.)*b*10.;
    // vec3 p2 = vec3
    p2 += 0.25 * vec3(sin(u_time / 16.), sin(u_time / 12.),  sin(u_time / 128.));
    float t2 = field2(p2,freqs[3]);


    vec4 c2 = mix(1.4, 1., v) * vec4(1.3 * t2  ,1.8  * t2 * t2 , 3., t2);
    vec4 col = vec4(0.);
    vec3 ttt = tile();
    for(int k = 0; k < 5; k++){    
        b+=inc;
        c2 *= b*3.*length(uv.xy)*.78;
        
    }

	float t = field(p,freqs[2]);
    vec4 test = vec4(.1, .5, .1, .9);
    col = mix(uv.x, 1., v) * vec4(test)+c2;
	gl_FragColor = col;

}