#version 300 es
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_9; //data texture
out vec4 fragColor;

void main(){
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    vec3 col =  texelFetch(u_texture_9,ivec2(gl_FragCoord.xy/10.),0).rgb;
    float st = sin(u_time);
    // ivec2 pos = ivec2(sin(u_time)*10.*st);
    // float topLeft = texelFetch(u_texture_9,pos,0).r;
    // float topLeft = texelFetch(u_texture_9,ivec2(gl_FragCoord.x*st, 0),0).r;
    vec4 normal = texelFetch(u_texture_9, ivec2(gl_FragCoord.xy), 0);
    float x = mod(gl_FragCoord.x, 100.);
    vec4 topLeft = texelFetch(u_texture_9, ivec2(int(x), 0), 0);
    // float mult = 
    // fragColor = vec4(col, 1.);
    fragColor = vec4(1.*topLeft);
    // fragColor = vec4(gl_FragCoord.x/u_resolution.x);
    // fragColor = topLeft;
    // fragColor = gl_Fr
    // fragColor = vec4(1.);
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