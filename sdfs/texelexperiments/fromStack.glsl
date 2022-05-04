#version 300 es
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_7;
// uniform sampler2D u_texture_9; //data texture
uniform vec2 u_mouse;
uniform sampler2D u_texture_10; //data texture
uniform sampler2D u_texture_11; //data texture
uniform sampler2D u_texture_4; //data texture 512
out vec4 fragColor;




void main(){
    // int numPixels = 211;
    int offset = int(u_mouse.x/u_resolution.x)*10000;
    float offset2 = (u_mouse.x/u_resolution.x)*10000.;
    int numPixels = 512;
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    float zoom = (u_mouse.y/u_resolution.y)* 50.;
    vec2 coord = gl_FragCoord.xy;
    offset2 = u_time*300.;
    coord.x += offset2; 
    coord.x *= zoom;
    float st = sin(u_time);
    // ivec2 texSize = textureSize(u_texture_10, 0);
    int ind = int(coord.x); 
    // int ind = int(coord.x); 
    ind += offset;
    int pixelX = ind % numPixels;
    int pixelY = ind / numPixels;
    vec4 basic = texelFetch(u_texture_4, ivec2(gl_FragCoord.xy), 0);
    // vec4 basic = texelFetch(u_texture_4, ivec2(pixelX, pixelY), 0);
    // vec4 basic = texelFetch(u_texture_11, ivec2(pixelX, pixelY), 0);
    // vec4 basic = texelFetch(u_texture_10, ivec2(pixelX, pixelY), 0);
    // vec4 basic = texelFetch(u_texture_7, ivec2(pixelX, pixelY), 0)*1.5;
    vec4 normal = texelFetch(u_texture_7, ivec2(gl_FragCoord.xy), 0);
    fragColor = basic;
    // fragColor = normal;
    // fragColor = vec4(u_mouse.x/u_resolution.x);
}


//:unsigned integers
uint mod_u32( uint u32_bas , uint u32_div ){

    float   flt_res =  mod( float(u32_bas), float(u32_div));
    uint    u32_res = uint( flt_res );
    return( u32_res );
}

//:signed integers
uint mod_i32( uint i32_bas , uint i32_div ){

    float   flt_res =  mod( float(i32_bas), float(i32_div));
    uint    i32_res = uint( flt_res );
    return( i32_res );
}