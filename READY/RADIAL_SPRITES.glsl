#version 300 es
precision highp float;

uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture_9;
uniform sampler2D u_texture_10;
uniform sampler2D u_texture_11;
uniform sampler2D u_texture_12;
// 
out vec4 fragColor;

#define PI      3.1415926535897932
#define HALF_PI 1.5707963267948966

#define COLUMNS 4
#define Count_TILES 16

#define TEXT_MAP u_texture_9



vec4 char(vec2 p, int charIndex) 
{
    charIndex = charIndex % Count_TILES;
    float fCol = float(COLUMNS);
    int start = COLUMNS - 1;
    if (p.x<.0|| p.x>1. || p.y<0.|| p.y>1.) return vec4(0,0,0,0.);
    // if (p.x<.0|| p.x>1. || p.y<0.|| p.y>1.) return vec4(0,0,0,1e5);
    vec2 charP = p/fCol + fract( vec2(charIndex, start-charIndex/COLUMNS) / fCol );
    vec2 dx = dFdx(p/fCol);
    vec2 dy = dFdy(p/fCol);
    vec4 outCol = textureGrad( TEXT_MAP, charP, dx, dy );
	return outCol;
}

//PARAMS
//0 1
float Speed = .5; 
float Alt = 0.;
float Radius = 2.;
int Mode = 0;
float Count = 12.; //should be even :)
int SpriteOffset = 0;
float XPos = 0.; 
float YPos = 0.;
float ScaleX = 1.;
float ScaleY = 1.;
float Zoom = 3.5;
//END_PARAMS

#define PosOffset vec2(XPos, YPos)


vec4 RadialSprite(vec2 uv){
    vec4 OutColor;
    vec2 U = uv;


    float s = (2. * PI) / Count;
    float off = (1. - step(mod(Count, 4.), 0.)) * (s / 2.);
    float angle = off;
    float st = sin(u_time);
    // Radius *= st;
    float tick = u_time*Speed*-1.;
    U+= vec2(0.5,.5);
    float alpha = 0.;
    for (float i = 0.; i < Count; i++) 
    {   
       	float a = mix(angle, angle + s, tick);
    	float x = Radius * cos(a) * ScaleX;
    	float y = Radius * sin(a) * ScaleY;

        vec3 color;
        int ch;
        switch (Mode) {
        case 0:
            ch = int(i);
            // ch = int(i);
            break;
        case 1:
           int ch = int(mix(0., 15., mod(i, 3.0)));
            break;
        }
     
        U+=vec2(x,y);
        // vec4 charColor = char(U,SpriteOffset+ch);
        // OutColor+=char(U,SpriteOffset+ch);
        OutColor+=char(U,0);
        U+=vec2(-x,-y);
        // alpha +=
        // 
        angle += s;
    }
    return OutColor;
    // alpha *= .0000005;
    // vec4 charColor = char(U,10);
    return vec4(alpha);
    // return vec4(1.-charColor.a*.0001);/
    // return charColor;
    // return vec4(min(alpha, .6));
    // return vec4(smoothstep(.1, 1.1, alpha));
}

void main()
{
    vec2 uv = (2. * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;
    uv  *= Zoom;
    float st = sin(u_time);
    float ratio= u_resolution.x/u_resolution.y;
    vec4 t = vec4(0.);

    vec4 rs = RadialSprite(uv);
    fragColor = rs;
    // fragColor = vec4(rs.rgb, rs.r);
    // fragColor = vec4(rs.rgb, rs.r);
    

}