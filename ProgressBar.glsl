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

float getBox(vec2 p, float left, float bottom, float width, float height) {
    float sm = 0.002;
    float x_range = smoothstep(left - sm, left, p.x) - smoothstep(left + width, left + width + sm, p.x);
    float y_range = smoothstep(bottom - sm, bottom, p.y) - smoothstep(bottom + height,bottom + height + sm, p.y);

    return x_range * y_range;
}

float getBoxStroke(vec2 p, float left, float bottom, float width, float height, float strokeWidth) {
    // float sm = 0.002;
    // float x_range = smoothstep(left - sm, left, st.x) - smoothstep(left + width, left + width + sm, st.x);
    // float y_range = smoothstep(bottom - sm, bottom, st.y) - smoothstep(bottom + height,bottom + height + sm, st.y);

    float innerBox = getBox(p, left, bottom, width, height);
    // float innerBox = getBox(p, -.04, -0.04, 0.08, 0.08);
    return innerBox -= getBox(p, left+strokeWidth/2., bottom+strokeWidth/2., width-strokeWidth, height-strokeWidth);
}
//PARAMS
//0 1000000
int TotalPoints = 1000; 
int CurPoints = 500;
float BarWidth = 80.; 
float BarHeight = 4.;
float BarX = 10.;
float BarY = 50.;
//END_PARAMS


vec3 makeFilledBar(vec2 p, float left, float bottom, float width, float height, float strokeWidth, vec3 strokeColor, vec3 fillColor, float fillAmount){
    vec3 color = vec3(0.);
    float d = 0.;
    float outterBox = getBoxStroke(p, left, bottom, width, height, strokeWidth);
  
    float innerBox = getBox(p, left+strokeWidth/2., bottom+strokeWidth/2., fillAmount*(width-strokeWidth), height-strokeWidth);
    
    color += fillColor * innerBox;
    color += strokeColor * outterBox;
    return color;
}



void main()
{
    // vec2 p = vec2( -u_resolution.x + 2.0*gl_FragCoord)/u_resolution.x;
    // p = p*2.2 + vec2(1.9,1.4);
    vec3 color = vec3(0.);
    vec2 p = gl_FragCoord.xy / u_resolution.xy;
    p -= 0.5;
    p.x *= u_resolution.x/u_resolution.y;
    
    int f = PrintInt( p, int(u_time) % 10000, 4 );
    float rx = u_resolution.x/u_resolution.y;
    float bw = BarWidth * .01;
    bw*=rx;
    float bh = BarHeight * .01;
    float bx = -.5+(BarX)/100.;
    bx*=rx;
    float by = -.5+BarY / 100.;

    float d = 0.;

    float strokeWidth = .01; 

    vec3 strokeColor = vec3(0.39,0.61,0.65);
    vec3 fillColor = vec3(1.000,0.345,0.287);
    float st = sin(u_time);
    float fillAmount = 1.;
    // float fillAmount = float(CurPoints)/float(CurPoints)*st;
    // float fillAmount = float(CurPoints)/float(TotalPoints);
    vec3 bc = makeFilledBar(p, bx, by, bw, bh, strokeWidth, strokeColor, fillColor, fillAmount);
    color += bc;
    fragColor = vec4(color,1.0);
    // fragColor = vec4(fill);
    // fragColor = vec4( p.x);
    // fragColor = vec4( 1.0 );
    
}

