#version 300 es
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

out vec4 fragColor;

#define AA 4.

#define CI vec3(.3,.5,.6)
#define CO vec3(0.0745, 0.0862, 0.1058)
#define CM vec3(.0)
#define CE vec3(.8,.7,.5)

float metaball(vec2 p, float r)
{
	return r / dot(p, p);
}

vec3 samplef(in vec2 uv)
{


    // float 
	// float t0 = sin(u_time * 1.9) * .46;
	// float t1 = sin(u_time * 2.4) * .49;
	// float t2 = cos(u_time * 1.4) * .57;
    float y = .0;
    vec2 p1 = vec2(.5, y);
    vec2 p2 = vec2(.5, y);
    vec2 p3 = vec2(.0, y);

    float mr = .02;

	float r = metaball(uv + p1, mr) +
			  metaball(uv - p2, mr) +
			  metaball(uv + p3, mr);

	vec3 c = (r > .4 && r < .7)
			  ? (vec3(step(.1, r*r*r)) * CE)
			  : (r < .9 ? (r < .7 ? CO: CM) : CI);

	return c;
}

void main()
{
	vec2 uv = (gl_FragCoord.xy / u_resolution.xy * 2. - 1.)
			* vec2(u_resolution.x / u_resolution.y, 1) * 1.25;

    vec3 col = vec3(0);

#ifdef AA
    // Antialiasing via supersampling
    float e = 1. / min(u_resolution.y , u_resolution.x);    
    for (float i = -AA; i < AA; ++i) {
        for (float j = -AA; j < AA; ++j) {
    		col += samplef(uv + vec2(i, j) * (e/AA)) / (4.*AA*AA);
        }
    }
#else
    col += samplef(uv);
#endif /* AA */
    vec2 mx = u_mouse.xy/u_resolution.xy;
    float d =  length(mx-uv);
    fragCoalor = vec4(clamp(col, 0., 1.), 1);
    fragColor = vec4(d);
    
}