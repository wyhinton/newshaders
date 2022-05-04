#version 300 es

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define Y0 25.
#define Y1 255.
#define Y2 50.
#define Y3 100.
#define EDGE   0.005
#define SMOOTH 0.0025

#define P0  0.25
#define P1  (sin(iTime*1.5) * 0.5)
#define P2  0.21
#define P3  -0.1
#define P4  0.2
#define P5  (iMouse.z <= 0.0 ? 0.25 : iMouse.y / iResolution.y - 0.5)
#define P6  -0.25
#define P7  0.0
out vec4 outColor;


float SDFCircle( in vec2 coords, in vec2 offset )
{
    coords -= offset;
    float v = coords.x * coords.x + coords.y * coords.y - EDGE*EDGE;
    vec2  g = vec2(2.0 * coords.x, 2.0 * coords.y);
    return v/length(g); 
}
float F ( in vec2 coords )
{
    // time in this curve goes from 0.0 to 10.0 but values
    // are only valid between 2.0 and 8.0
    float T = coords.x*6.0 + 2.0;
    return SplineValue(T) - coords.y;
}

float SplineValue(in float t)
{
    return
        P0 * N_i_3(t, 0.0) +
        P1 * N_i_3(t, 1.0) +
        P2 * N_i_3(t, 2.0) +
        P3 * N_i_3(t, 3.0) +
        P4 * N_i_3(t, 4.0) +
        P5 * N_i_3(t, 5.0) +
        P6 * N_i_3(t, 6.0) +
        P7 * N_i_3(t, 7.0);      
}

float SDF( in vec2 coords )
{
    float v = F(coords);
    // float slope = dFdx(v) / dFdx(coords.x);
    return v;
}

void main() {
	// vec2 st = gl_FragCoord.xy / u_resolution.xy;
	// st.x *= u_resolution.x / u_resolution.y;
	// vec3 color = vec3(0.0);
	// color = vec3(
	// 	abs(cos(u_time * 0.1)) * st.y,
	// 	abs(cos(u_time * 0.2)) * st.y,
	// 	abs(sin(u_time)) * st.y
	// );

    float aspectRatio = u_resolution.x / u_resolution.y;
    vec2 percent = ((gl_FragCoord.xy / u_resolution) - vec2(0.25,0.5));
    percent.x *= aspectRatio;
    vec3 color = vec3(1.0);

    float dist = SDFCircle(percent, vec2(7.0 / 7.0,.5));
    if (dist < EDGE + SMOOTH)
    {
        dist = max(dist, 0.0);
        dist = smoothstep(EDGE,EDGE + SMOOTH,dist);
        color *= mix(vec3(0.0,0.0,1.0),vec3(1.0,1.0,1.0),dist);
    }

    if (percent.x >= 0.0 && percent.x <= 1.0)
    {
    	dist = SDF(percent);
    	if (dist < EDGE + SMOOTH)
    	{
        	dist = smoothstep(EDGE - SMOOTH,EDGE + SMOOTH,dist);
        	color *= vec3(dist);
    	}
    }

	outColor = vec4(color, 1.0);
	// outColor = vec4(percent.x);
}