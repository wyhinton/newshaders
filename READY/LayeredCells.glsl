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
//0 1
float RadiusStart = .1;
//0 1
float RadiusEnd = .9;
//0 10
float Scaling  = 1.1;
float ScaleMult = 1.5;
//0 10 
float SpeedMult = 1.5;
//0 10
int NumLayers = 3;
//0 100
float CoverageScale = 30.;
//0 1
float LayeredMix = .0;
//END_PARAMS


float Hash21(vec2 p, float speed) {
    // float t = u_time/100.;
    p = fract(p*vec2(234.35, 935.775));
    p += dot(p, p+24.23+speed);
    return fract(p.x * p.y);
}

float MakeSquares(vec2 p, float t, float s){
        vec2 gv = fract(p)-.5;
        vec2 id = floor(p);

        float n = Hash21(id + 5.364, t*(s/100.)); 
        return n;
}

void main()
{
    vec2 baseUV = gl_FragCoord.xy/u_resolution.xy;
    vec4 base = texture2D(u_texture_0, baseUV);
    float counter = 0.5;
    float inc = 1.;
    // vec4 finalCol = vec4(0.);
    vec3 col = vec3(0);
    float local_time = u_time + TimeOffset; 

    float coverage = 0.;
    {
        vec2 uv = (gl_FragCoord.xy - u_resolution.xy*.5)/u_resolution.y;
        uv*=CoverageScale;
         vec2 gv = fract(uv)-.5;
        vec2 id = floor(uv);

        float n = Hash21(id + 5.364, local_time*(Speed/100.)); 
        // float n = MakeSquares(uv, local_time, )
        // I offset id because the center pixel changed very slow compared to others.
        
        coverage += -n;
        float z = smoothstep(RadiusStart, .1, length(gv));
        // coverage += max(.1, z);
        coverage = floor(smoothstep(coverage, .9, .6)*1.1);
        // coverage += smoothstep(RadiusStart, .1, length(gv));
    }
    for(int i = 0; i < 10; i++){
        if (i < NumLayers){

            vec2 uv = (gl_FragCoord.xy - u_resolution.xy*.5)/u_resolution.y;
            float scaleInc = counter*ScaleMult;
            float speedMult = counter*SpeedMult;
    
            uv *= Scale*counter;
            
            vec2 gv = fract(uv)-.5;
            vec2 id = floor(uv);

            float n = Hash21(id + 5.364, local_time*(Speed/100.)); 
            // float n = MakeSquares(uv, local_time, )
            // I offset id because the center pixel changed very slow compared to others.
            
            col += -n;
            col += smoothstep(RadiusStart, .1, length(gv));
            // col *= smoothstep(RadiusStart, .1, length(gv));
            // vec3 fxCol = base.rgb;
            // // fxCol *= (n, n*.1, n*.3);
            // // vec3 finalCol = mix(base.rgb, fxCol, .5);
            // vec3 finalCol = mix(base.rgb, fxCol, col);
            // float white = ceil(smoothstep(n, WhiteAmount, 1.));
            // finalCol += white;
            counter += inc;     
        }
    }
    
    
    vec3 fxCol = base.rgb*col;
    vec4 g1 = texture2D(u_texture_0, col.rg);
    // fxCol *= (n, n*.1, n*.3);
    // vec3 finalCol = mix(base.rgb, fxCol, .5);
    float colMult = .3;
    // vec3 finalCol = mix(base.rgb, g1.rgb, coverage);
    vec3 finalCol = mix(base.rgb, g1.rgb, mix(col, vec3(coverage), vec3(LayeredMix)));
    // vec3 finalCol = mix(base.rgb, g1.rgb, col*colMult);
    // vec3 finalCol = mix(base.rgb, fxCol, col);
    // float white = ceil(smoothstep(.1, WhiteAmount, 1.));
    // finalCol += white;
    
    // vec4 final = 
    // gl_FragColor = vec4(col, 1.0);
    gl_FragColor = vec4(col, 1.);
    gl_FragColor = vec4(finalCol, 1.);
    // gl_FragColor = vec4(coverage);

}