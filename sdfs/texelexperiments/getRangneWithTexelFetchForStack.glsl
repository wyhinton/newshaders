#version 300 es
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D u_texture_10; //data texture
out vec4 fragColor;

void main(){
    //width and height of our texture
    int numPixels = 100;
    //x position of the pixel from our texture
    float x = mod(gl_FragCoord.x, 100.);
    //y positino of the pixel from our texture
    int y = int(gl_FragCoord.x)/numPixels;
    //pixel color
    vec4 pixel = texelFetch(u_texture_10, ivec2(int(x), y), 0);
    //output
    fragColor = vec4(pixel);
}

