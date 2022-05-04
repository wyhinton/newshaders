#version 300 es


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

out vec4 fragColor;

const int[] font = int[](0x75557, 0x22222, 0x74717, 0x74747, 0x11574, 0x71747, 0x71757, 0x74444, 0x75757, 0x75747);
const int[] powers = int[](1, 10, 100, 1000, 10000, 100000, 1000000);

int PrintInt( in vec2 uv, in int value, const int maxDigits )
{
    if( abs(uv.y-0.5)<0.5 )
    {
        int iu = int(floor(uv.x));
        if( iu>=0 && iu<maxDigits )
        {
            int n = (value/powers[maxDigits-iu-1]) % 10;
            uv.x = fract(uv.x);//(uv.x-float(iu)); 
            ivec2 p = ivec2(floor(uv*vec2(4.0,5.0)));
            return (font[n] >> (p.x+p.y*4)) & 1;
        }
    }
    return 0;
}

void main()
{
    vec2 p = vec2( -u_resolution.x + 2.0*gl_FragCoord)/u_resolution.x;
    p = p*2.2 + vec2(1.9,1.4);
    
    int f = PrintInt( p, int(u_time) % 10000, 4 );
    
    vec3 col = vec3( f );

    fragColor = vec4( col, 1.0 );
    // fragColor = vec4( 1.0 );
    
}