#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_0;
uniform sampler2D u_texture_10;

out vec4 fragColor;


float text(vec2 fragCoord, sampler2D targetTexture, int columns, vec2 imgResolution)
{
    vec2 uv = mod(fragCoord.xy, 16.)*.0625;
    vec2 block = fragCoord*.0625 - uv;
    uv = uv*.8+.1; // scale the letters up a bit
    uv += floor(texture(targetTexture, block/imgResolution) * 16.); // randomize letters
    uv *= .0625; // bring back into 0-1 range
    uv.x = -uv.x; // flip letters horizontally
    return texture(targetTexture, uv);
}

vec4 char(vec2 p, int c, sampler2D targetTexture, int columns) 
{
    float fCol = float(columns);
    int start = columns - 1;
    if (p.x<.0|| p.x>1. || p.y<0.|| p.y>1.) return vec4(0,0,0,1e5);
	return textureGrad( targetTexture, p/fCol + fract( vec2(c, start-c/columns) / fCol ), dFdx(p/fCol),dFdy(p/fCol) );
}




void main(){
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    // uv /= u_resolution.y;
    // uv -= .5;
    // uv *=;
    // uv = u_resolution.xy;
    vec3 col = vec3(0.);
    vec4 t = texture(u_texture_10, uv);
    vec2 position = vec2(.5);
    float FontSize = 8.;
    vec2 U = ( uv - position)*64.0/FontSize;
    // fragColor = vec4(col, 1.0);/
    vec4 c1 = char(U, 1, u_texture_10, 3);
    // vec4 c1 = C(1);
    // fragColor = c1;
    fragColor = vec4(text(fragCoord), u_texture_10, 3, vec2(1200., 400.));
}



// vec3 rain(vec2 fragCoord)
// {
// 	fragCoord.x -= mod(fragCoord.x, 16.);
//     //fragCoord.y -= mod(fragCoord.y, 16.);
    
//     float offset=sin(fragCoord.x*15.);
//     float speed=cos(fragCoord.x*3.)*.3+.7;
   
//     float y = fract(fragCoord.y/iResolution.y + iTime*speed + offset);
//     return vec3(.1,1,.35) / (y*20.);
// }

// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
 
// }