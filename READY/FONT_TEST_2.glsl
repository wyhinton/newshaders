#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_0;
uniform sampler2D u_texture_10;
uniform sampler2D u_texture_11;

out vec4 fragColor;


// vec4 text(vec2 fragCoord, sampler2D targetTexture, int columns, vec2 imgResolution)
// {
//     float fCol = float(columns);
//     float mul = 1./fCol;
//     // float mul = 1./fCol;
//     vec2 uv = mod(fragCoord.xy, fCol)*mul;
//     vec2 block = fragCoord*mul - uv;
//     uv = uv*.8+.1; // scale the letters up a bit
//     // vec2 size = vec2(1200., 400.);
//     // imgResolution = vec2(1200., 400.);
//     // imgResolution*=.2;
    
//     uv += floor(texture(u_texture_10, block/imgResolution.xy).xy * fCol); // randomize letters
//     uv *= mul; // bring back into 0-1 range
//     // return vec4(uv.x);
//     // return vec4(uv.x);
//     // return vec4(block.x);
//     // 
//     // return texture(u_texture_10, block/imgResolution.xy + u_time*.002);
//     return vec4(texture(u_texture_10, uv).r);
// }


float text(vec2 fragCoord, sampler2D targetTexture, int columns, vec2 imgResolution)
{
    float col = float(columns);
    // float col = 16.;
    float mul = 1./col;
    vec2 uv = mod(fragCoord.xy, col)*mul;
    vec2 block = fragCoord*mul - uv;
    //uv = uv*.8+.1; // scale the letters up a bit
    // vec2 size= vec2(1024., 1024.);
    // vec2 size= vec2(1200., 400.);
    // block.x /= imgResolution.x;
    // block.y /= imgResolution.y;
    
    uv += floor(texture(targetTexture, block/imgResolution).xy * col); // randomize letters
    uv *= mul; // bring back into 0-1 range
    uv.x = -uv.x; // flip letters horizontally
    //return uv.x;
    // return fragCoord.x*5.*mul;
    // return block.x/100.;
    return texture(targetTexture, uv).r;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    vec4 t = texture(u_texture_10, uv);
    // fragColor = vec4(text(gl_FragCoord.xy, u_texture_10, 3, vec2(1200., 400.)));
    fragColor = vec4(text(gl_FragCoord.xy, u_texture_11, 16, vec2(1024., 1024.)));
    // fragColor = vec4(text(uv, u_texture_10, 3, vec2(1200., 400.)));
    // fragColor = t;
}