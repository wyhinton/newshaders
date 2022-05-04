#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_3;

vec2 matcap(vec3 eye, vec3 normal) {
  vec3 reflected = reflect(eye, normal);
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
  return reflected.xy / m + 0.5;
}


float smin( float a, float b, float k )
{
    float res = exp2( -k*a ) + exp2( -k*b );
    return -log2( res )/k;
}


float sdSphere(vec3 p, float r){
    vec3 newP = vec3(sin(p.x), p.y, p.z);
    return length(p)-r;
}


float sdf(vec3 p){
    float sphere =  sdSphere(p, 0.5);
    return sphere;
}


vec3 calcNormal( in vec3 p ) // for function f(p)
{
    const float eps = 0.0001; // or some other value
    const vec2 h = vec2(eps,0);
    return normalize( vec3(sdf(p+h.xyy) - sdf(p-h.xyy),
                           sdf(p+h.yxy) - sdf(p-h.yxy),
                           sdf(p+h.yyx) - sdf(p-h.yyx) ) );
}

void main(){
    vec2 uv =  (-u_resolution.xy + 2.0 * gl_FragCoord.xy)/u_resolution.y;
    vec3 col = vec3(0.);
    vec3 camPos = vec3(0., 0., 2.);
    vec3 ray = normalize(vec3(uv, -1.));
    float tMax = 5.;


    vec3 rayPos = camPos;
    float t = 0.;
    for(int i = 0; i < 256; i++){
        vec3 pos = camPos + t*ray;
        float h = sdf(pos);
        if(h<0.001 || t>tMax) break;
        t+=h;
    }
    if (t<tMax){
        vec3 pos = camPos + t*ray;
        col = vec3(1.);
        vec3 normal = calcNormal(pos);
        col = normal;
        float diff = dot(vec3(1.), normal);
        vec2 matcapUV = matcap(ray, normal);
        col = texture2D(u_texture_3, matcapUV).rgb;
        col = normal;
    }

    gl_FragColor = vec4(col, 1.0);
}