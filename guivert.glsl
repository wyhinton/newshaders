#version 300 es
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

out vec4 fragColor;

/** repeat the position in 'pos' every 'q' degree in polar space */
vec2 fan(in vec2 pos, in float q) 
{
    q = q / 180. * 3.14159265;
    float ang = atan(pos.x, pos.y),
    len = length(pos.xy);
    ang = mod(ang + q/2., q) - q/2.;
    pos.xy = len * vec2(sin(ang), cos(ang));
    return pos;
}

/** repeat the position in 'pos' every 'q' units */
vec2 repeat(in vec2 pos, in vec2 q) 
{
    pos.xy = mod(pos.xy + q/2., q) - q/2.;
    return pos;
}

/** combination of fan and repeat calls, controlled by the 'scene' parameter. 
    scene is range 0 to 3*5*6*7*11-1
*/
vec2 fan_repeat(in vec2 uv, in int scene) 
{
    uv = fan(uv, float[5](120., 90., 60., 45., 30.)[scene % 5]);
    uv = repeat(uv, vec2(
        float[3](2., 3., 4.)[scene%3],
        float[7](1., 3., 5., 2., 4., 5., 2.)[scene%7]));
    uv = fan(uv, float[11](120., 90., 60., 30., 45., 12.5, 120., 180., 60., 30., 45.)[scene % 11]);
    uv = repeat(uv, vec2(
        float[6](1., 3., 1., 4., 3., 5.)[scene%6],
        float[5](1., 4., 1., 3., 2.)[scene%5]));
    
	return uv;
}


/** a dull image with some variation through 'scene' */
vec3 img(in vec2 uv, in int scene)
{
    vec3 col = vec3(0.);
    
    vec3 c1 = vec3[3](
        vec3(1., .7, .4), vec3(.4, .9, .3), vec3(.2, .5, 1.)
    )[scene%3];
    vec3 c2 = vec3[4](
        vec3(.3, .5, .6), vec3(.4, .2, .3), vec3(.1, 1., .2), vec3(.2, .5, 1.)
    )[scene%4];
    vec3 c3 = vec3[5](
        vec3(.9, .5, .1), vec3(.4, .9, .1), vec3(.1, .6, 1.), vec3(.9, .3, 1.), vec3(.5, .5, .5)
    )[scene%5];
    
    float step1 = float[3](.01, .02, .1)[scene%3];
    float step2 = float[4](.01, .02, 0.05, .1)[scene%4];
    float step3 = float[5](.01, .02, 0.2, 0.03, .1)[scene%5];
    float step4 = float[6](.01, .02, 0.03, 0.04, 0.05, .1)[scene%6];
    
    col += c1 * smoothstep(step2,0., length(uv.xy) - float[3](0., 0.1, .2)[scene%3]);
    col += c1 * smoothstep(step1,0., abs(uv.y-.6)-0.02);
    col += c2 * smoothstep(step4,0., abs(uv.x)-0.02);
    col += c3 * smoothstep(step3,0., abs(uv.y-.3)-0.02);
    
    return col;
}

void main()
{
	vec2 uv = (gl_FragCoord.xy - .5*u_resolution.xy) / u_resolution.y * 2.;
	    
    uv *= 5.;
    
    float colMult = 1.;
    float val = 2.5;
    vec2 m = u_mouse/u_resolution;
    float mx = m.y;

    // val*=mx;
    uv = fan_repeat(uv, int(val));
    uv*=3.;
    vec3 col = img(uv, int(val*colMult));

    //     uv = fan_repeat(uv, int(u_time*3.));
    // vec3 col = img(uv, int(u_time*6.));

    fragColor = vec4(col,col.b);
    // fragColor = vec4(col,1.0);
    // fragColor = vec4(mx);
    // fragColor = vec4(u_mouse.x);
}