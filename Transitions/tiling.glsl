#version 300 es

precision highp float;
uniform vec2 u_resolution;
uniform float u_time;

out vec4 fragColor;

// https://www.shadertoy.com/view/fs23zV
void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    vec2 pos = 256.0*gl_FragCoord.xy/u_resolution.x + u_time;

    vec3 col = vec3(0.0);
    for( int i=0; i<6; i++ ) 
    {
        vec2 a = floor(pos);
        vec2 b = fract(pos);
        
        vec4 w = fract((sin(a.x*7.0+31.0*a.y + 0.01*u_time)+vec4(0.035,0.01,0.0,0.7))*13.545317); // randoms
                
        col += w.xyz *                                   // color
               2.0*smoothstep(0.45,0.55,w.w) *           // intensity
               sqrt( 16.0*b.x*b.y*(1.0-b.x)*(1.0-b.y) ); // pattern
        
        pos /= 2.0; // lacunarity
        col /= 2.0; // attenuate high frequencies
    }
    
    col = pow( col, vec3(0.7,0.8,0.5) );    // contrast and color shape

    float w = sin((uv.x*13.)*sin(uv.y));
    w = smoothstep(w, 0., .05);
    col = vec3(w);
    
    fragColor = vec4( col, 1.0 );
}