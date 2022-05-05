#define Speed .1

#ifdef GL_ES
precision mediump float;
#endif

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
uniform sampler2D u_texture_12;
// uniform sampler2D u_texture_13;
uniform sampler2D u_buffer0;

vec2 matcap(vec3 eye, vec3 normal) {
  vec3 reflected = reflect(eye, normal);
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
  return reflected.xy / m + 0.5;
}
// displacement example below is using 

float displacement(vec3 p, float scale){
    return sin(scale*p.x)*sin(scale*p.y)*sin(scale*p.z);
}

float opDisplace( float shape , in vec3 p, float amount )
{
    // float d1 = primitive(p);
    float d2 = displacement(p, amount);
    return shape+d2;
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

float smin( float a, float b, float k )
{
    float res = exp2( -k*a ) + exp2( -k*b );
    return -log2( res )/k;
}




float sdCylinder( vec3 p, vec3 c )
{
  return length(p.xz-c.xy)-c.z;
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

// void mirror(inout float2 position){
//     position.x = abs(position.x);
// }

float sdCapsule( vec3 p, vec3 a, vec3 b, float r )
{
  vec3 pa = p - a, ba = b - a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h ) - r;
}

float sdf(vec3 p){
    vec3 p1 = rotate(p, vec3(1.), u_time/5.);
    float box = sdBox(p1, vec3(0.2));
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    vec3 grad = texture2D(u_texture_5,uv/2.).rgb;
    vec3 cp = rotate(p, vec3(1., 1., 0.), 3.154);
    // cp.y = abs(cp.x);
    float t = .25;
    float sdCylinder = sdCylinder(cp, vec3(t*grad.x, t, t));
    vec2 translate = vec2(-0.5, -0.5);
    vec4 buf = texture2D(u_buffer0, uv);
    float sdCapsule = sdCapsule(p, vec3(-1., -0., -0.), vec3(1., 0., 0.), buf.x);
    // float dispc = opDisplace(sdCylinder, p, 1.);
    // return dispc;
    return sdCapsule;
    return sdCylinder;
    // return max(box, sphere);
    // return smin(box, sphere, 32.);
    // return box;
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
    return pow(ratio + dot(ray, normal), 3.);
}

float grid(vec2 uv, float width, float steps){
      float gridX =       smoothstep(width, 0., abs(sin((uv.x+Speed*u_time) * steps )));    
    float gridX2 =       smoothstep(width, 0., abs(sin((uv.x+Speed*u_time) * steps*2. )));
    return gridX + gridX2;
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
    col += grid(uv, gridLineWidth, divisor);
    bool active = false;
    vec3 rayPos = camPos;
    float t = 0.;
        vec3 grad = texture2D(u_texture_5,uv).rgb;
    
    for(int i = 0; i < 256; i++){
        vec3 pos = camPos + t*ray;
        float h = sdf(pos);
        if(h<0.001 || t>tMax) break;
        t+=h;
    }


    vec3 col2 = vec3(0.);
    if (t<tMax){
        vec3 pos = camPos + t*ray;
        // pos *= grad.x;
        col = vec3(1.);
        vec3 normal = calcNormal(pos);
        col = normal;
        float diff = dot(vec3(1.), normal);
        vec2 matcapUV = matcap(ray, normal);
        col = vec3(diff);
        col = vec3(matcapUV, 0.);
        if (active){}
        // matcapUV.r *= sin(u_time);
        col = texture2D(u_texture_12, matcapUV).rgb;
        col2 = texture2D(u_texture_13, matcapUV).rgb;
        // col = texture2D(u_texture_6, matcapUV).rgb;
        vec3 f = vec3(fresnel(ray, normal, 1.5));
        // col = mix(col, bg, f);
        // col = vec3(f);
        col = mix(col, col2, f);
    }
    vec4 buf = texture2D(u_buffer0, uv-translate);
    // vec3 grad = texture2D(u_texture_5,uv/2.).rgb;
    gl_FragColor = vec4(col, 1.0);
    // gl_FragColor = vec4(buf);
    // gl_FragColor = vec4(grad, 1.0);
    // gl_FragColor = vec4();
}

#endif