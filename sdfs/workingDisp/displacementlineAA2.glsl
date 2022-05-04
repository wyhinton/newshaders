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

const int MAX_MARCHING_STEPS = 64;
const float EPSILON = 0.0015;
const float NEAR_CLIP = 0.0;
const float FAR_CLIP = 100.00;
const float PI = 3.14159265359;

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_3;
uniform sampler2D u_texture_4;
uniform sampler2D u_texture_5;
uniform sampler2D u_texture_6;
uniform sampler2D u_texture_12;
uniform sampler2D u_texture_13;
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
    float t = .25;
    float sdCylinder = sdCylinder(p1, vec3(t*grad.x, t, t));
    vec2 translate = vec2(-0.5, -0.5);
    vec4 buf = texture2D(u_buffer0, uv);
    float sdCapsule = sdCapsule(p, vec3(-10., -0., -0.), vec3(10., 0., 0.), buf.x);
    return sdCapsule;
    return sdCylinder;
}

vec3 computeNormal(vec3 pos){
    vec2 eps = vec2(0.01, 0.);
    return normalize(vec3(
        sdf(pos + eps.xyy) - sdf(pos - eps.xyy),
        sdf(pos + eps.yxy) - sdf(pos - eps.yxy),
        sdf(pos + eps.yyx) - sdf(pos - eps.yyx)
    ));
}

vec3 getColor(vec3 eye, vec3 dir,float dist){
    vec3 collision = (eye += (dist*0.995) * dir );
    vec3 normal = computeNormal(collision);
    return normal ;
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
mat3 setCamera( in vec3 ro, in vec3 ta, float cr ){
    vec3 cw = normalize(ta-ro);
    vec3 cp = vec3(sin(cr), cos(cr),0.0);
    vec3 cu = normalize( cross(cw,cp) );
    vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}


void main(){
    //UV
    vec2 uv = 2.0 * gl_FragCoord.xy / u_resolution.xy - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    //CAMERA SETUP
    vec3 eye = vec3(0., 0., 2.);
    vec3 ta = vec3( 0., -0.0, 0.0 );
    mat3 camera = setCamera( eye, ta, 0.0 );
    float fov = 0.2;
    vec3 dir = camera * normalize(vec3(uv, fov));

    //BACKGROUND
    vec3 color = vec3(0.3451, 0.3176, 0.2824);

    float depth = 0.;
    float dist = EPSILON;
    
   // ANTIALIAS VARIABLES
    float pix = 4.0/u_resolution.x; // the size of a pixel
    float od = dist;
    float w = 1.8; // what is this variable for? It is a threshold, but why 1.8 and why w?
    float s = 0.0; // what is this variable for?
    vec4 stack = vec4(-1.0); // here 4 distance values are stored.
    bool grab = true;
    vec3 camPos = vec3(0., 0., 2.);
    // END ANTIALIAS VARIABLES
    // vec3 test = eye + depth * dir;
    for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
        dist = sdf(eye + depth * dir);
        // ??
        if (w > 1.0 && (od + dist < s)) {
            s -= w*s;
            w = 1.0;
        } else {
            // ??
            s = dist * w;
        	if (dist <= od) grab = true;
        	else if (grab && stack.w < 0. && od < pix*(depth-od)) {
                // stack.w contains now the new distance
            	stack.w = depth-od;
                // the stack variable get updated and the new distance is pushed in
                stack = stack.wxyz; 
            	grab = false;
        	}
        	if (dist < EPSILON || depth > FAR_CLIP) break;
        }
        od = dist;
        depth += s; 
    }

    if (dist < EPSILON) color = getColor(eye, dir, depth);

    // AA just on the top part of the screen, to see the difference with non AA
    if (uv.y > 0.) {
        for (int i = 0; i < 4; ++i) {
            // if the stored distance is less than 0, abort the loop.
            if (stack[i] < 0.0) break;
            // get the color for the collected distance stack[i]
            // mix it with the color obtained in the previous loop iteration
            dist = sdf(eye + stack[i]*dir);
            color = mix(getColor(eye, dir, stack[i]), color, clamp(dist/(pix*stack[i]), 0.0, 1.0));
        }
    }
    // separation line
    if (uv.y < 0. && uv.y> -0.01) color = vec3(0.);
    //vec3 debug = vec3(s);
    //vec3 debug = vec3(od);
    //gl_FragColor = vec4(clamp(debug,0.0,1.0) , 1.0);
    
    gl_FragColor = vec4(clamp(color,0.0,1.0) , 1.0);
    // fragColor = vec4(1.);
    // fragColor = vec4(test*.1, 1.);
}

#endif