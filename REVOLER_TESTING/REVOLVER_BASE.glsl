precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;
/**
*	ray marching tools adapted from hughsk's 2D SDF Toy https://www.shadertoy.com/view/XsyGRW
*/

#define TRACE_STEPS 20
#define TRACE_RAY

// 0 = Distance Field Display
// 1 = Raymarched Edges
// 2 = Resulting Solid
// 3 = Distance Field Polarity
#define DISPLAY 0

// 0 = Angle controlled By u_time
// 1 = Angle controlled By u_mouse
#define MOUSE 0
const float PI = 3.14159265359;

float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

vec2 squareFrame(vec2 screenSize, vec2 coord) {
    vec2 position = 2.0 * (coord.xy / screenSize.xy) - 1.0;
    position.x *= screenSize.x / screenSize.y;
    return position;
}

// translational symmetry
vec2 tsym(vec2 p, float m) {
    return mod(p + m*.5, m) - m*.5;
}

float tsym(float p, float m) {
    return mod(p + m*.5, m) - m*.5;
}

// rotational symmetry
vec2 rsym(vec2 p, float n){
	float pr = length(p);
    float pa = atan(p.y, p.x);
    pa = tsym(pa, 2.*PI/n);
    p = vec2(pr*cos(pa), pr*sin(pa));
    return p;
}

vec2 rotate(vec2 p, float a) {
    return vec2(p.x*cos(a) - p.y*sin(a),
                p.x*sin(a) + p.y*cos(a));   
}

float add(float a, float b) {
    return min(a, b);
}

float sub(float a, float b) {
	return max(a, -b);
}



float shape_circle(vec2 p, float r) {
    return length(p) - r;
}

float shape_rect(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) +  min(max(d.x, d.y), 0.0);  // out + in
}

float shape_line(vec2 p, vec2 a, vec2 b) {
    vec2 dir = b - a;
    return abs(dot(normalize(vec2(dir.y, -dir.x)), a - p));
}

float shape_segment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}

//https://iquilezles.org/articles/distfunctions2d
float shape_trapezoid(vec2 p, float r1, float r2, float he ) {
    vec2 k1 = vec2(r2,he);
    vec2 k2 = vec2(r2-r1,2.0*he);
    p.x = abs(p.x);
    vec2 ca = vec2(p.x-min(p.x,(p.y<0.0)?r1:r2), abs(p.y)-he);
    vec2 cb = p - k1 + k2*clamp( dot(k1-p,k2)/dot(k2, k2), 0.0, 1.0 );
    float s = (cb.x<0.0 && ca.y<0.0) ? -1.0 : 1.0;
    return s*sqrt( min(dot(ca, ca),dot(cb, cb)) );
}



float shape_revolver_base(vec2 p) {
    return shape_trapezoid(p + vec2(0, .5), .15, .1, .8) - .05;
}

float shape_revolver_cylinder_fill(vec2 p) {
    vec2 p1 = rotate(p, u_time);
    return shape_circle(p1, .4);
}

float shape_revolver_cylinder_cut(vec2 p) {
    float cbig = shape_circle(p, .4);
    float cmid  = shape_circle(p, .03);
    
    vec2 p11 = abs(rsym(rotate(p, PI/6.), 6.)) - vec2(.25, 0);
    float cin  = shape_circle(p11, .075);
    
    vec2 p12 = abs(rsym(p, 6.)) - vec2(.4, 0);
    float cout = shape_circle(p12, .075);
	
    return sub(add(add(cmid, cin), cout), -cbig-.03);
}

float shape_revolver_barrel(vec2 p) {
    p.x = abs(p.x);
    float rect1 = shape_rect(p - vec2(0, .45), vec2(.04, .06)) - .01;
    float rect2 = shape_rect(p - vec2(.08, .42), vec2(.04, .04)) - .01;
	float circle = abs(shape_circle(p - vec2(0, 0.25), 0.15)) - .025;
    return add(sub(add(rect1, rect2), circle), circle);
}

float shape_revolver_frame(vec2 p) {
    float rect = shape_rect(p+vec2(0, .25), vec2(.06, .2));
    float circle = shape_circle(p, .1);
	return add(rect, circle) - .025;
}

float shape_revolver_trigger(vec2 p) {
    float rect1 = shape_rect(p+vec2(0, .55), vec2(.06, .05));
    float trap = shape_trapezoid(p+vec2(0, .7), .03, .06, .08);
    return add(trap, rect1) - .025;
}

float SAMPLER(vec2 p) {
    float scale = .8;
    p.y -= .25;
    
    p /= scale;
    
    vec2 p1, p2;
    float time = mod(u_time/PI, 2.);
    if (time > 1.){
        p1 = rotate(p + vec2(0, .4), abs(sin(u_time))*PI*.25) - vec2(0, .4);
        p2 = rotate(p1, u_time);
    }else{
        if (time > .11 && time < .2 && length(p - vec2(0, .25)) < pow(time, 2.)*120.) return 0.;
        p.y -= (time > .1)? exp(-time*5.)*.75 : 0.;
        p1 = p;
        p2 = p;
    }
    
    float cylinder_back = shape_circle(p, .425);
    float cylinder_cut = shape_revolver_cylinder_cut(p2);
    float cylinder_fill = shape_revolver_cylinder_fill(p2);
    float base = shape_revolver_base(p);
    float s1 = sub(add(add(cylinder_fill, cylinder_back), base), cylinder_cut);
    
    float trigger = shape_revolver_trigger(p);
    float s2 = add(sub(s1, trigger - .025), trigger);
    
    float frame_still = shape_revolver_frame(p);
    float frame_move = shape_revolver_frame(p1/.9)*.9;
    float s3 = add(sub(s2, frame_move - .025), frame_move);
    float s4 = add(sub(s3, frame_still - .025), frame_still);

    
    float barrel = shape_revolver_barrel(p);
    float s5 = add(sub(s4, barrel - .025), barrel);
    

    return s5*scale;
}


vec3 draw_line(float d, float thickness) {
    const float aa = 3.0;
    return vec3(smoothstep(0.0, aa / u_resolution.y, max(0.0, abs(d) - thickness)));
}

vec3 draw_line(float d) {
    return draw_line(d, 0.0025);
}

float draw_solid(float d) {
    return smoothstep(0.0, 3.0 / u_resolution.y, max(0.0, d));
}

vec3 draw_polarity(float d, vec2 p) {
    p += u_time * -0.1 * sign(d) * vec2(0, 1);
    p = mod(p + 0.06125, 0.125) - 0.06125;
    float s = sign(d) * 0.5 + 0.5;
    float base = draw_solid(d);
    float neg = shape_rect(p, vec2(0.045, 0.0085) * 0.5);
    float pos = shape_rect(p, vec2(0.0085, 0.045) * 0.5);
    pos = min(pos, neg);
    float pol = mix(neg, pos, s);

    float amp = abs(base - draw_solid(pol)) - 0.9 * s;

    return vec3(1.0 - amp);
}

vec3 draw_distance(float d, vec2 p) {
    float t = clamp(d * 0.85, 0.0, 1.0);
    vec3 grad = mix(vec3(1, 0.8, 0.5), vec3(0.3, 0.8, 1), t);

    float d0 = abs(1.0 - draw_line(mod(d + 0.1, 0.2) - 0.1).x);
    float d1 = abs(1.0 - draw_line(mod(d + 0.025, 0.05) - 0.025).x);
    float d2 = abs(1.0 - draw_line(d).x);
    vec3 rim = vec3(max(d2 * 0.85, max(d0 * 0.25, d1 * 0.06125)));

    grad -= rim;
    grad -= mix(vec3(0.05, 0.35, 0.35), vec3(0.0), draw_solid(d));

    return grad;
}

vec3 draw_trace(float d, vec2 p, vec2 ro, vec2 rd) {
    vec3 col = vec3(0);
    vec3 line = vec3(1, 1, 1);
    vec2 _ro = ro;

    for (int i = 0; i < TRACE_STEPS; i++) {
        float t = SAMPLER(ro);
        col += 0.8 * line * (1.0 - draw_line(length(p.xy - ro) - abs(t), 0.));
        col += 0.2 * line * (1.0 - draw_solid(length(p.xy - ro) - abs(t) + 0.02));
        col += line * (1.0 - draw_solid(length(p.xy - ro) - 0.015));
        ro += rd * t;
        if (t < 0.01) break;
    }

    #ifdef TRACE_RAY
    col += 1.0 - line * draw_line(shape_segment(p, _ro, ro), 0.);
    #endif

    return col;
}

void main() {
    float t = u_time * 0.5;
    vec2 uv = squareFrame(u_resolution.xy, gl_FragCoord.xy);
    float d;
    vec3 col;
    vec2 ro = vec2(u_mouse.xy / u_resolution.xy) * 2.0 - 1.0;
    ro.x *= squareFrame(u_resolution.xy, u_resolution.xy).x;

    vec2 rd = normalize(-ro);

    d = SAMPLER(uv);

    #if DISPLAY == 0
    col = vec3(draw_distance(d, uv.xy));
    #if MOUSE == 0
    // col -= (u_mouse.z > 0.0 ? 1.0 : 0.0) * vec3(draw_trace(d, uv.xy, ro, rd));
    #endif
    #endif
    // #if DISPLAY == 1
    // col = vec3(0) + 1.0 - vec3(draw_line(d));
    // #if MOUSE == 0
    // col += (u_mouse.z > 0.0 ? 1.0 : 0.0) * vec3(1, 0.25, 0) * vec3(draw_trace(d, uv.xy, ro, rd));
    // #endif
    // col = 1. - col;
    // #endif
    // #if DISPLAY == 2
    // col = vec3(draw_solid(d));
    // #endif
    // #if DISPLAY == 3
    // col = vec3(draw_polarity(d, uv.xy));
    // #endif

    gl_FragColor.rgb = col;
    gl_FragColor.a   = 1.0;
}