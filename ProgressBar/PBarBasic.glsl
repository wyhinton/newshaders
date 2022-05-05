#version 300 es


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

out vec4 fragColor;

const int[] font = int[](0x75557, 0x22222, 0x74717, 0x74747, 0x11574, 0x71747, 0x71757, 0x74444, 0x75757, 0x75747);
const int[] powers = int[](1, 10, 100, 1000, 10000, 100000, 1000000);

int PrintInt( in vec2 uv, in vec2 p, in int value, const int maxDigits )
{
    float xPos = 0.;
    float Scale = 40.;
    uv*=Scale;
    // uv.x+=1.15;
    uv.x += .5*Scale;
    uv.y += .5*Scale;
    uv -= p*Scale;
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
    // p.x = fract(p.x*10.);
    float x_range = smoothstep(left - sm, left, p.x) - smoothstep(left + width, left + width + sm, p.x);
    float y_range = smoothstep(bottom - sm, bottom, p.y) - smoothstep(bottom + height,bottom + height + sm, p.y);

    return x_range * y_range;
}

float getBoxDashes(vec2 p, float left, float bottom, float width, float height) {
    float sm = 0.002;
    // p.x = fract(p.x*10.);
    float x_range = smoothstep(left - sm, left, p.x) - smoothstep(left + width, left + width + sm, p.x);
    float y_range = smoothstep(bottom - sm, bottom, p.y) - smoothstep(bottom + height,bottom + height + sm, p.y);
    float q = ceil(smoothstep(.2, .08, fract(p.x*100.)));
    float z = ceil(smoothstep(.4, .09, fract(p.y*100.)));
    return x_range*q * y_range*z;
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
mat2 rotate(float angle){
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

vec3 makeFilledBar(vec2 p, float left, float bottom, float width, float height, float strokeWidth, vec3 strokeColor, vec3 fillColor, float fillAmount){
    vec3 color = vec3(0.);
    float d = 0.;
    float outterBox = getBoxStroke(p, left, bottom, width, height, strokeWidth);
  
    float innerBox = getBox(p, left+strokeWidth/2., bottom+strokeWidth/2., fillAmount*(width-strokeWidth), height-strokeWidth);
    float dashes = getBoxDashes(p, left+strokeWidth/2., bottom+strokeWidth/2., (width-strokeWidth), height-strokeWidth);
    
    color += fillColor * innerBox;
    color += strokeColor * outterBox;
    color += strokeColor * dashes;

    color += mix(innerBox, dashes, .01);
    p *= rotate(1.);
    // color += ceil(smoothstep(.01, .0, fract(p.x*100.)));
    return color;
}

float GetCurve(float x)
{
	return sin( x * 3.14159 * 4.0 );
}

float GetCurveDeriv(float x) 
{ 
	return 3.14159 * 4.0 * cos( x * 3.14159 * 4.0 ); 
}


#define A 2.1 // Amplitude
#define V 8. // Velocity
#define W  .6// Wavelength
#define T 3. // Thickness
#define S 1.011 // Sharpness

float sine(vec2 p, float o)
{
    return pow(T / abs((p.y + sin((p.x * W + o)) * A)), S);
}

// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
// 	vec2 p = fragCoord.xy / iResolution.xy * 2. - 1.;
// 	fragColor = vec4(vec3(sine(p, iTime * V)), 1);
// }

vec3 makeSinBox(vec2 p, float left, float bottom, float width, float height, float strokeWidth, vec3 strokeColor, vec3 fillColor, float fillAmount){

    vec3 color = vec3(0.);
    float d = 0.;
    float outterBox = getBoxStroke(p, left, bottom, width, height, strokeWidth);
  
    float innerBox = getBox(p, left+strokeWidth/2., bottom+strokeWidth/2., fillAmount*(width-strokeWidth), height-strokeWidth);
    float dashes = getBoxDashes(p, left+strokeWidth/2., bottom+strokeWidth/2., (width-strokeWidth), height-strokeWidth);
    vec2 bp = p;
    bp += .5;
    float st = sin(u_time);
    bp.x -= left;
    bp.x /= width;
    bp.y += height;
    // bp.y += bottom+.2;
    bp.y /= height;
    
    // float n = bp.x
    // //  n = fract(n*10.)*sin(bp.y);
    // float n = fract(bp.y)*innerBox;
    bp.y = fract(bp.y);
    bp.x = fract(bp.x);
    float n = fract((bp.x*2.));
    // float n = fract(bp.y);
    // float n = fract(bp.y);
    // float n = sin(fract(bp.y));

    vec3 vColour = vec3(0.);

    // float scale = 3.;
    float nq = 0.;

    
    vec2 uv = bp;
    // uv.x += -10.5;
    float thickness = .01;
    uv.y += -2.5;
    // uv *= rotate(3);
    float t = sin(uv.x*1.) * .5;
    
    if (uv.y >= t - thickness && uv.y <= t + thickness) {
        
    	nq = 1.;
    } else {
        nq = 0.;
    }
    // nq += sine(bp, u_time);
    // vec2 uv = bp;
    // uv.y-=bottom*10;
    // uv.y/=height;

    // uv.y-= height;
    // // vec2 uv = gl_FragCoord.xy/u_resolution.xy*scale-1.5;
    // // vec2 uv = gl_FragCoord.xy/u_resolution.xy*scale-1.5;
    // uv.x += u_time;
    // uv.y -= sin(uv.x);
    // float w = abs(cos(uv.x))/3.141;
    // uv.y /= sqrt(1.+w);
    // nq += step(abs(uv.y), .1);
	// // float fCurveX = n;
	// float fSinY = (GetCurve(fCurveX) * 0.25 + 0.5) * u_resolution.y;
	// float fSinYdX = (GetCurveDeriv(fCurveX) * 0.25) * u_resolution.y / u_resolution.x;
	// float fDistanceToCurve = abs(fSinY - gl_FragCoord.y) / sqrt(1.0+fSinYdX*fSinYdX);
	// float fCurveX = n;
	// float fSinY = (GetCurve(fCurveX) * .25 + .5) * .4;
	// float fSinYdX = (GetCurveDeriv(fCurveX) * 0.25) * u_resolution.y / u_resolution.x;
	// float fDistanceToCurve = abs(fSinY - gl_FragCoord.y) / sqrt(1.0+fSinYdX*fSinYdX);
	float fCurveX = gl_FragCoord.x / u_resolution.x;
    float amp =  (u_resolution.y/100.)*height*100.;
    float yPos = u_resolution.y*bottom/.3;
    // float yPos = 1000.;
	float fSinY = (GetCurve(fCurveX) * amp - 2.) * 1.;
	float fSinYdX = (GetCurveDeriv(fCurveX) * 0.25) * u_resolution.y / u_resolution.x;
	float fDistanceToCurve = abs(fSinY - gl_FragCoord.y) / sqrt(1.0+fSinYdX*fSinYdX);
	float fSetPixel = fDistanceToCurve - 1.0; // Add more thickness
	vColour = mix(vec3(1.0, 0.0, 0.0), vColour, clamp(fSetPixel, 0.0, 1.0));
    // float n = bp.x;
    // float n = sin();
    // color += fillColor * innerBox;
    color += strokeColor * outterBox;
    // color += strokeColor * n;
    // color += nq;
    // color += strokeColor * n;
    // color += strokeColor * smoothstep(.1, .1 , n*sin(bp.x*4.));
    color += vColour;

    // p *= rotate(1.);
    
    // color += ceil(smoothstep(.01, .0, fract(p.x*100.)));
    return color;
}



void main()
{
    // vec2 p = vec2( -u_resolution.x + 2.0*gl_FragCoord)/u_resolution.x;
    // p = p*2.2 + vec2(1.9,1.4);
    vec3 color = vec3(0.0);
    vec2 p = gl_FragCoord.xy / u_resolution.xy;
    p -= 0.5;
    p.x *= u_resolution.x/u_resolution.y;
    
    vec2 textP = vec2(.4);
    // vec2 textP = vec2(0.5, 0.5);
    // vec2 textP = vec2(0.5, 0.5);

    float rx = u_resolution.x/u_resolution.y;
    float bw = BarWidth * .01;
    bw*=rx;
    float bh = BarHeight * .01;
    float bx = -.5+(BarX)/100.;
    bx*=rx;
    float by = -.5+BarY / 100.;

    float d = 0.;

    float strokeWidth = .01; 

    vec3 strokeColor = vec3(1.0, 1.0, 1.0);
    vec3 fillColor = vec3(1.0, 1.0, 1.0);
    float st = sin(u_time);
    // float fillAmount = 1.;
    float fillAmount = float(CurPoints)/float(CurPoints)*abs(st);

    // float text =
    // float fillAmount = float(CurPoints)/float(TotalPoints);
    
    vec3 bc = makeFilledBar(p, bx, by, bw, bh, strokeWidth, strokeColor, fillColor, fillAmount);
    color += bc;
    int f = PrintInt( p, vec2(bx+.5, by+.55), int(fillAmount*float(TotalPoints)), 3 );
    color += float(f)*vec3(1.0, 1.0, 1.0);
    vec3 sb = makeSinBox(p, bx+.1, by+.1, .1, .3, strokeWidth, strokeColor, fillColor, 1.);
    color += sb;
    fragColor = vec4(color,1.0);

    // fragColor = vec4(f);
    // fragColor = vec4(fill);
    // fragColor = vec4( p.x);
    // fragColor = vec4( 1.0 );
    
}

