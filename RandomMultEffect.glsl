precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;

//PARAMS
//0 100
float Scale = 50.;
//0 10
float Speed = 1.;
//0 1000
float TimeOffset = 0.;
float WhiteAmount = .6;
float RadiusStart = .1;
float RadiusEnd = .9;
//END_PARAMS


float Hash21(vec2 p, float speed) {
    // float t = u_time/100.;
    p = fract(p*vec2(234.35, 935.775));
    p += dot(p, p+24.23+speed);
    return fract(p.x * p.y);
}

void main()
{
    vec2 baseUV = gl_FragCoord.xy/u_resolution.xy;
    vec4 base = texture2D(u_texture_0, baseUV);
    vec2 uv = (gl_FragCoord.xy - u_resolution.xy*.5)/u_resolution.y;
    vec3 col = vec3(0);
    float local_time = u_time + TimeOffset; 
    uv *= Scale;
    
    vec2 gv = fract(uv)-.5;
    vec2 id = floor(uv);

    float n = Hash21(id + 5.364, local_time*(Speed/100.)); 
    // I offset id because the center pixel changed very slow compared to others.
    
    col += -n;
    col += smoothstep(RadiusStart, .1, length(gv));
    vec3 fxCol = base.rgb;
    // fxCol *= (n, n*.1, n*.3);
    // vec3 finalCol = mix(base.rgb, fxCol, .5);
    vec3 finalCol = mix(base.rgb, fxCol, col);
    float white = ceil(smoothstep(n, WhiteAmount, 1.));
    finalCol += white;
    // vec4 final = 
    // gl_FragColor = vec4(col, 1.0);
    gl_FragColor = vec4(finalCol, 1.);

}