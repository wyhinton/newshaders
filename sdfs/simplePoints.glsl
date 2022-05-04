#version 300 es


// #ifdef GL_ES
// precision highp float;
// #endif

uniform vec2 u_resolution;
uniform float u_time;


// in vec2 fragCoord;
out vec4 fragColor;


#define Y0 25.
#define Y1 255.
#define Y2 50.
#define Y3 100.
#define EDGE   0.005
#define SMOOTH 0.0025

// float circleshape(vec2 position, float radius){
//     return step(radius, length(position - vec2(0.5)));
// }

// float map(float value, float min1, float max1, float min2, float max2) {
//   return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
// }

float SDFCircle( in vec2 coords, in vec2 offset )
{
    coords -= offset;
    float v = coords.x * coords.x + coords.y * coords.y - EDGE*EDGE;
    vec2  g = vec2(2.0 * coords.x, 2.0 * coords.y);
    return v/length(g); 
}

float F ( in vec2 coords )
{
    float T = coords.x*6.0 + 2.0;
    return T;
}


float SDF( in vec2 coords )
{
    float v = F(coords);
    // float slope = dFdx(v) / dFdx(coords.x);
    return v;
}
void main(){
    float aspectRatio = u_resolution.x / u_resolution.y;
    vec2 percent = ((gl_FragCoord.xy / u_resolution) - vec2(0.25,0.5));
    percent.x *= aspectRatio;
    vec3 color = vec3(1.0);

    float dist = SDFCircle(percent, vec2(7.0 / 7.0,.25));
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
    

    fragColor = vec4(color, 1.0);

}