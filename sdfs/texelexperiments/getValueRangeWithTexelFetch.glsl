#version 300 es
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_9; //data texture
uniform sampler2D u_texture_10; //data texture
out vec4 fragColor;


vec4 getValueByIndexFromTexture(sampler2D tex, vec2 texSize, float index) {
  float col = mod(index, texSize.x);
  float row = floor(index / texSize.x);
  return texelFetch3(tex, texSize, vec2(col, row));
}
vec4 texelFetch3(sampler2D tex, vec2 texSize, vec2 pixelCoord) {
  vec2 uv = (pixelCoord + 0.5) / texSize;
  return texture(tex, uv);
} 

void main(){
    int numPixels = 100;
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    // vec3 col =  texelFetch(u_texture_9,ivec2(gl_FragCoord.xy/10.),0).rgb;
    float st = sin(u_time);
    // vec4 normal = texelFetch(u_texture_9, ivec2(gl_FragCoord.xy), 0);
    // float x = mod(gl_FragCoord.x, 100.);
    int pixelX = someIndex % texSize.x;
    // int y = int(gl_FragCoord.x)/numPixels*100;
    int y = int(gl_FragCoord.x)/numPixels;
    // vec2 texcoord = gl_FragCoord * numPixels;
    ivec2 coord = ivec2(uv);
    // vec4 topLeft = texelFetch(u_texture_9, ivec2(int(x), y), 0);
    vec4 topLeft = texelFetch(u_texture_10, coord/100, 0);
    // vec4 topLeft = texelFetch(u_texture_9, ivec2(0, x), 0);
    // vec4 topLeft = texelFetch(u_texture_10, ivec2(int(x), y+(int(gl_FragCoord.y))), 0);
    // vec4 topLeft = texelFetch(u_texture_10, ivec2(int(x), int(gl_FragCoord.y/2.)-y), 0);
    // vec4 topLeft = texelFetch(u_texture_10, ivec2(int(x), y+(int(gl_FragCoord.y)-numPixels)), 0);
    // fragColor = vec4(topLeft);
    vec4 basic = texelFetch(u_texture_10, ivec2(gl_FragCoord.xy), 0);
    // vec4 test = getValueByIndexFromTexture(u_texture_10, vec2(100. , 100.), 1);
    fragColor = basic;
    // fragColor = texelFetch(u_texture_10, ivec2(, 0), 0);
    // fragColor = vec4(x/100.);
    // fragColor = vec4(float(y)*.1);
    // fragColor = vec4(gl_FragCoord.x*.001);
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