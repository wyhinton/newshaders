#version 300 es

precision highp float;

const int MAX_MARCHING_STEPS = 64;
const float EPSILON = 0.0015;
const float NEAR_CLIP = 0.0;
const float FAR_CLIP = 100.00;
const float PI = 3.14159265359;

uniform vec2 u_resolution;
uniform float u_time;
out vec4 fragColor;

float clampeddot(vec3 a, vec3 b){
    return max(0.,dot(a, b));
}

vec3 lightDirection = vec3(1.0, 1.0, 1.0);

vec2 rotate(vec2 pos, float angle){
    float c = cos(angle);
    float s = sin(angle);
    return mat2(c, s, -s, c) * pos;
} 

float sdBox( vec3 p, vec3 b ){
    vec3 d = abs(p) - b;
    return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float sphere(vec3 pos, float radius){
    return length(pos) - radius;
}

vec3 opRep( vec3 p, vec3 c ){
    return mod(p,c)-0.5*c;
}

float map(vec3 pos){
    float sph = sphere(pos, 15.);
    return sph;
}

vec3 computeNormal(vec3 pos){
    vec2 eps = vec2(0.01, 0.);
    return normalize(vec3(
        map(pos + eps.xyy) - map(pos - eps.xyy),
        map(pos + eps.yxy) - map(pos - eps.yxy),
        map(pos + eps.yyx) - map(pos - eps.yyx)
    ));
}

float diffuse(vec3 normal){
    float ambient = 0.2;
    return clamp( clampeddot(normal, lightDirection) * ambient + ambient, 0.0, 1.0 );
}

float specular(vec3 normal, vec3 dir){
    vec3 h = normalize(normal - dir);
    float specularityCoef = 40.;
    return clamp( pow(clampeddot(h, normal), specularityCoef), 0.0, 1.0);
}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr ){
    vec3 cw = normalize(ta-ro);
    vec3 cp = vec3(sin(cr), cos(cr),0.0);
    vec3 cu = normalize( cross(cw,cp) );
    vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

vec3 getColor(vec3 eye, vec3 dir,float dist){
        vec3 collision = (eye += (dist*0.995) * dir );
        vec3 normal = computeNormal(collision);
        float diffLight = diffuse(normal);
        float specLight = specular(normal, dir);

        return (diffLight + specLight ) * vec3(0.2392, 0.8118, 0.9529);
}

void main()
{
    vec2 uv = 2.0 * gl_FragCoord.xy / u_resolution.xy - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    
    vec3 eye = vec3(3.5, 3.0, 15.5);
    vec3 ta = vec3( -0.5, -0.9, 0.5 );
    mat3 camera = setCamera( eye, ta, 0.0 );
    float fov = 0.2;
    vec3 dir = camera * normalize(vec3(uv, fov));

    // bg
    vec3 color = vec3(0.6784, 0.4118, 0.1059);

    float depth = NEAR_CLIP;
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
        dist = map(eye + depth * dir);
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
            dist = map(eye + stack[i]*dir);
            color = mix(getColor(eye, dir, stack[i]), color, clamp(dist/(pix*stack[i]), 0.0, 1.0));
        }
    }
    // separation line
    if (uv.y < 0. && uv.y> -0.01) color = vec3(0.);
    //vec3 debug = vec3(s);
    //vec3 debug = vec3(od);
    //gl_FragColor = vec4(clamp(debug,0.0,1.0) , 1.0);
    
    fragColor = vec4(clamp(color,0.0,1.0) , 1.0);
    // fragColor = vec4(1.);
    // fragColor = vec4(test*.1, 1.);
}