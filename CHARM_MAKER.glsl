#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_0;
uniform sampler2D u_texture_10;
uniform sampler2D u_texture_11;

out vec4 fragColor;


vec4 char(vec2 p, int c, sampler2D targetTexture, int columns) 
{
    float fCol = float(columns);
    int start = columns - 1;
    if (p.x<.0|| p.x>1. || p.y<0.|| p.y>1.) return vec4(0,0,0,1e5);
	return textureGrad( targetTexture, p/fCol + fract( vec2(c, start-c/columns) / fCol ), dFdx(p/fCol),dFdy(p/fCol) );
}

//PARAMS
//0 1
float ImageSize = 1024.; //END_PARAMS


vec4 getTile(vec2 uv, int ind, float imageSize){
    uv /= vec2(ImageSize);// * ratio;
    uv += 0.5;
    vec3 col = vec3(0.);
    vec4 t = texture(u_texture_10, uv);
    vec2 position = vec2(.5);
    float FontSize = 20.;
    float finalS = 64.0/FontSize;
    vec2 U = ( uv - position )*finalS;
    U += .5;
    vec4 c1 = char(U, 0, u_texture_10, 2);
    return c1;
}


float sdCircle( in vec2 p, in float r ) 
{
    return length(p)-r;
}


float sdBlobbyCross( in vec2 pos, float he )
{
    pos = abs(pos);
    pos = vec2(abs(pos.x-pos.y),1.0-pos.x-pos.y)/sqrt(2.0);


    float p = (he-pos.y-0.25/he)/(6.0*he);
    float q = pos.x/(he*he*16.0);
    float h = q*q - p*p*p;
    
    float x;
    if( h>0.0 ) { float r = sqrt(h); x = pow(q+r,1.0/3.0) - pow(abs(q-r),1.0/3.0)*sign(r-q); }
    else        { float r = sqrt(p); x = 2.0*r*cos(acos(q/(p*r))/3.0); }
    x = min(x,sqrt(2.0)/2.0);
    
    vec2 z = vec2(x,he*(1.0-2.0*x*x)) - pos;
    return length(z) * sign(z.y);
}



void main(){
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    vec2 ratio = vec2(u_resolution.x / u_resolution.y);
    uv = (-1.0 + 2.0 * gl_FragCoord.xy / u_resolution.xy) * vec2(u_resolution.x / u_resolution.y, 1.0);
    uv *= u_resolution.x / 2.0;
    
    vec3 col = vec3(0.);
    float d = sdCircle(uv, 100.);
    col += vec3(d);
    col += getTile(uv, 0, ImageSize).rgb;

    vec4 c1 = getTile(uv, 0, ImageSize);
 
    // fragColor = c1;
    fragColor = vec4(col, 1.);
    // fragColor = vec4(d);
    // fragColor = vec4(col, 1.);
}