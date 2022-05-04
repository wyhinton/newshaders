#define Speed .1

#extension GL_OES_standard_derivatives : enable  
#ifdef GL_ES
precision mediump float;
#endif
#define WB 1.
#ifdef BUFFER_0
uniform vec2 u_resolution;
uniform float u_time;
void main() {
    // vec4 color = texture2D(u_buffer0, uv, 0.0);
    vec2 uv =  gl_FragCoord.xy/u_resolution;
    // vec2 translate = vec2(-0.5, -0.5);
    // uv += translate;
    vec4 color = vec4(.5);
    color += sin((uv.x-.5+u_time*Speed)*50.)*.2;
    // color += clamp(sin(uv.x), .3, .3);
    // color += clamp(sin(uv.x), .3, .3);
    // color += fract(abs(uv.x)*10.);
    
    // ...
    gl_FragColor = color;
}

#else

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_3;
uniform sampler2D u_texture_4;
uniform sampler2D u_texture_5;
uniform sampler2D u_texture_6;
uniform sampler2D u_buffer0;

vec2 matcap(vec3 eye, vec3 normal) {
  vec3 reflected = reflect(eye, normal);
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
  return reflected.xy / m + 0.5;
}

mat4 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

vec3 rotate(vec3 v, vec3 axis, float angle) {
	mat4 m = rotationMatrix(axis, angle);
	return (m * vec4(v, 1.0)).xyz;
}

float stroke(float d, float w, float i) {
    float val = abs(smoothstep(w*0.5, w*0.5+fwidth(d),abs(d)) - i);
    return val;
}

float sdCapsule( vec3 p, vec3 a, vec3 b, float r )
{
  vec3 pa = p - a, ba = b - a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h ) - r;
}

float sdf(vec3 p){
    vec3 p1 = rotate(p, vec3(1.), u_time/5.);
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    vec3 grad = texture2D(u_texture_5,uv/2.).rgb;
    vec3 cp = rotate(p, vec3(1., 1., 0.), 3.154);
    // cp.y = abs(cp.x);
    float t = .25;
    vec2 translate = vec2(-0.5, -0.5);
    vec4 buf = texture2D(u_buffer0, uv);
    float sdCapsule = sdCapsule(p, vec3(-1., -0., -0.), vec3(1., 0., 0.), buf.x);
    float sdStroke = stroke(sdCapsule, .01, WB);
    // return sdCapsule ;
    return sdCapsule;
}


vec3 calcNormal( in vec3 p ) // for function f(p)
{
    const float eps = 0.0001; // or some other value
    const vec2 h = vec2(eps,0);
    return normalize( vec3(sdf(p+h.xyy) - sdf(p-h.xyy),
                           sdf(p+h.yxy) - sdf(p-h.yxy),
                           sdf(p+h.yyx) - sdf(p-h.yyx) ) );
}

float fresnel(vec3 ray, vec3 normal, float ratio){
    return pow(1. + dot(ray, normal), 3.);
}



void main(){
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    vec2 translate = vec2(-0.5, -0.5);
    uv+=translate;
    vec3 col = vec3(0.);
    vec3 camPos = vec3(0., 0., 2.);
    vec3 ray = normalize(vec3(uv, -1.));
    float tMax = 5.;
    float gridLineWidth = 0.05; 
    float divisor = 30.;
    vec2 Coord = uv;

    float dist= length(uv);
    vec3 bg = mix(vec3(0.), vec3(0.3), dist);
    // col += bg;
    float grid = min(
        smoothstep(0.1, 0.25, abs(sin(uv.x * divisor))),
        smoothstep(0.1, 0.25, abs(sin(uv.y * divisor)))
    );
    float gridX =       smoothstep(gridLineWidth, 0., abs(sin((uv.x+Speed*u_time) * divisor )));
    float gridX2 =       smoothstep(gridLineWidth, 0., abs(sin((uv.x+Speed*u_time) * divisor*2. )));
    col += gridX;
    col += gridX2;
    
    vec3 rayPos = camPos;
    float t = 0.;
    vec3 grad = texture2D(u_texture_5,uv).rgb;
    for(int i = 0; i < 256; i++){
        vec3 pos = camPos + t*ray;
        float h = sdf(pos);
        if(h<0.001 || t>tMax) break;
        t+=h;
    }



    if (t<tMax){
        vec3 pos = camPos + t*ray;
        float aaf = fwidth(t);
        // pos *= grad.x;
        col = vec3(1.);
        vec3 normal = calcNormal(pos);
        col = normal;
        float diff = dot(vec3(1.), normal);
        vec2 matcapUV = matcap(ray, normal);
        col = vec3(diff);
        col = vec3(matcapUV, 0.);
        col = texture2D(u_texture_6, matcapUV).rgb;
        vec3 f = vec3(fresnel(ray, normal, 3.));
        col = mix(col, bg, f);
        // col = vec3(aaf);
        // col = pos;
    }
    vec4 buf = texture2D(u_buffer0, uv-translate);
    // vec3 grad = texture2D(u_texture_5,uv/2.).rgb;
    gl_FragColor = vec4(col, 1.0);
    // gl_FragColor = vec4(buf);
    // gl_FragColor = vec4(grad, 1.0);
    // gl_FragColor = vec4();
}

#endif