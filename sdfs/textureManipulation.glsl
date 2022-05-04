#version 300 es
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texture_7; //data texture
out vec4 fragColor;

void main(){
    //data texture dimensions
    vec2 dims = vec2(44487., 1.0);
    //amount by which to translate the data texture
    vec2 offset = vec2(u_time*.5, 0.);
    //canvas coords
    vec2 uv =  gl_FragCoord.xy/u_resolution.xy;
    //textuer asspect ratio, w/h
    float textureAspect = 44487. / 1.;
    vec3 col = vec3(0.);
    //texture width is 44487*larger than uv, I guess?
    vec2 textCoords = vec2(uv.x*textureAspect+offset.x, uv.y);
    //get texture values
    vec3 text = texture(u_texture_7, vec2(uv.x*dims.x, uv.y*dims.y)).rgb;
    //output
    fragColor = vec4(text, 1.);
}

export const vs = GLSL`
#version 300 es    
in vec4 position;
void main() {
  gl_Position = position;
}
`;
