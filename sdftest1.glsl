
precision mediump float;
#define MAX_STEPS 100

#define MAX_DIST 100.
#define MIN_DIST 0.0002
uniform float u_time;
uniform vec2 u_resolution;


float sdfSphere( vec3 p, float s )
{
  return length(p)-s;
}
float getDist(vec3 p)
{
    // Setup scene
    return sdfSphere(vec3(-.0), 0.8);
}

float rayMarch(vec3 ro, vec3 rd)
{
    float dist = 0.;
    
    for (int i = 0; i < MAX_STEPS; i++)
    {
        vec3 itPos = ro + rd * dist;
        float itDist = getDist(itPos);
        
        dist += itDist;
        
        if (dist > MAX_DIST || dist < MIN_DIST)  
            break;
    }    
    
    return dist;
}

vec3 getNormal(vec3 p)
{
    vec2 e = vec2(0.01, 0.);    
    return normalize(vec3(getDist(p + e.xyy), getDist(p + e.yxy), getDist(p + e.yyx)));    
}

float getLight(vec3 p)
{
    vec3 lightPos = vec3(sin(u_time * 3.), 3., -2.2);
    vec3 lightDir = normalize(p - lightPos);
    
    return -dot(getNormal(p), lightDir);    
}

void main()
{    
    // vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/2.0;
    // vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/2.0;
    // vec2 uv = gl_FragCoord.xy/u_resolution.xy - .5;
    // uv.x *= u_resolution.x / u_resolution.y;
    
    float focalDist = 0.6;
    vec3 ro = vec3(0., 0., 0.6);
    vec3 rd = vec3(uv.x, uv.y, focalDist);   
    
    vec3 col = vec3(0.);
    
    float dist = rayMarch(ro, rd);
    if (dist < MAX_DIST)
    {
        vec3 pHit = ro + rd * dist;
        col = vec3(0.5, 0.6, 0.6);
        col *= vec3(getLight(pHit)) + vec3(0.1);
        
    }    

    // Output to screen
    // gl_FragColor = vec4(col,1.0);
    gl_FragColor = vec4(uv.x);
}