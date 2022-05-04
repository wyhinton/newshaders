#version 300 es
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture_0;
uniform sampler2D u_texture_4;

out vec4 fragColor;
float scale = 10.0;

bool flatTop = true;

vec4 rect2hex(vec2 p){
	vec2 var = flatTop ? vec2(1., .5) : vec2(.5, 1.);
    
    vec2 s = flatTop ? vec2(1.7320508, 1.) : vec2(1., 1.7320508);
    
	vec4 hC = floor(vec4(p, p - var)/s.xyxy) + .5;
	vec4 h = vec4(p - hC.xy*s, p - (hC.zw + .5)*s);
    
    //vec4 hC = floor(vec4(p/s, p/s + .5));
	//vec4 h = p.xyxy - vec4(hC.xy + .5, hC.zw)*s.xyxy;

	return dot(h.xy, h.xy) < dot(h.zw, h.zw) ? vec4(h.xy, hC.xy) : vec4(h.zw, hC.zw + .5);
}

float edgeDistance(vec2 p) {
	p = abs(p);
    
	float var = flatTop ? p.y : p.x;
    
    vec2 s = flatTop ? vec2(1.7320508, 1.) : vec2(1., 1.7320508);
    
	return max(dot(p, s*.5), var);
}

float random2d(vec2 coord){
    return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
	vec2 rg = textureLod( u_texture_4, (uv+0.5)/256.0, 0.0 ).yx;
	return mix( rg.x, rg.y, f.z );
}


void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.x;
    
    uv *= scale;
    
    vec4 uvHex = rect2hex(uv);
    
    float ed = edgeDistance(uvHex.xy); // Edge distance.
	float cDist = dot(uvHex.xy, uvHex.xy); // Relative squared distance from the center.

    float fn = noise(vec3(uvHex*2.+u_time*2.));
    // uvHex+=fn;
    // uvHex.z+=u_time*.0000008;
    vec2 noiseT = gl_FragCoord.xy/u_resolution.xy;
    noiseT.x += u_time*.1;
    vec4 text = texture(u_texture_4, noiseT);
    // cDist+=text.x*.8;
    // uvHex.z+=text.x*.0000008;

    vec3 col = vec3(0.);
	col.rg = cos(uvHex.zw + u_time) * 0.5 + 0.5;
    float z = random2d(uvHex.zw);
    
    // outline
	col *= 1.0 - smoothstep(0.48, 0.5, ed);
    cDist*=fn;
    // fragColor = vec4(col,1.0);
    // fragColor = vec4(vec3(cDist),1.0);


    float as = smoothstep(.1, .2,  z);
    as += smoothstep(.0, .5, cDist*ed);
    fragColor = vec4(vec3(smoothstep(.01, .2, cDist*ed)),as);
    // fragColor = vec4(vec3(z),1.0);
    // fragColor = vec4(vec3(smoothstep(.1, .2,  z)),1.0);
    // fragColor = vec4(vec3(as),1.0);
    // fragColor = vec4(vec3(noise(vec3(uvHex*2.+u_time*2.))),1.0);

}