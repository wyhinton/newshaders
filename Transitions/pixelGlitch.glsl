#version 300 es
precision mediump float;


uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture_0;
uniform sampler2D u_texture_1;

out vec4 fragColor;

bool reset() {
    return texture(u_texture_0, vec2(32.5/256.0, 0.5) ).x > 0.5;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / u_resolution.xy;
    vec2 texel = 1. / u_resolution.xy*3.0;
    
    float step_y = texel.y;
    vec2 s  = vec2(0.0, -step_y);
    vec2 n  = vec2(0.0); //vec2(0.0, step_y);

    vec4 im_n =  texture(u_texture_1, uv+n);
    vec4 im =    texture(u_texture_1, uv);
    vec4 im_s =  texture(u_texture_1, uv+s);
    
    vec4 source = texture(u_texture_0, uv);
    float sourceLum = dot(source, vec4(0.299, 0.587, 0.114, 0.));
    
    vec4 bright = vec4(0.0);
    if (sourceLum > 0.5)
        bright = source;
    
    // use luminance for sorting
    float len_n = dot(im_n, vec4(0.299, 0.587, 0.114, 0.));
    float len = dot(im, vec4(0.299, 0.587, 0.114, 0.));
    float len_s = dot(im_s, vec4(0.299, 0.587, 0.114, 0.));
    
    if(int(mod(float(iFrame) + fragCoord.y, 2.0)) == 0) {
        if ((len_s > len)) { 
            im = im_s;    
        }
    } else {
        if ((len_n < len)) { 
            im = im_n;    
        }   
    }

    vec4 col = vec4(1.0);
    
    // blend with image
    if(iFrame<1 || reset()) {
        fragColor = texture(iChannel1, uv);
    } else {
	    //fragColor = (texture(iChannel1, uv)*5. + im * 94. ) / 100.;
        col = (bright*5. + im * 94. ) / 100.;
        //It's here the crazy stuff happens
        fragColor = mix(source*2.,col,col.a*2.);
    }
    
}