precision highp float;

uniform float u_time;
uniform vec2 u_resolution;


float f( vec3 p )
{ 
	p.z += u_time;
    return length(      cos(p)
                  + .05*cos(9.*p.y*p.x)
                  - .1 *cos(9.*(.3*p.x-p.y+p.z))
                  ) - 1.; 
}

vec2 rot(vec2 uv,float a){
	return vec2(uv.x*cos(a)-uv.y*sin(a),uv.y*cos(a)+uv.x*sin(a));
}

void main()
{
    vec4 c = vec4(0.);
    vec2 p = gl_FragCoord.xy;


    float RotationSpeed = .1;
    float Center = .5;
    float RollSpeed = .01;
    float Complexity = .1;
    float FTBlend = .1; 
    float R = 0.;
    float G = 1.;
    float B = 2.;
    float AlphaFallof = .1; 


     p = rot(p, u_time*RotationSpeed);
    vec3 d = Center-vec3(p,1)/u_resolution.x, o = d;    
    float b= 0.;
    float st = sin(u_time*.1);
    float inc = st+Complexity;
    for( int i=0; i<10;i++ ){
        b+=inc;
        o += f(o)*d*b-FTBlend;
    }
      
        
    c = vec4(R,G,B,3.);
    c = abs( f(o-d)*c + f(o-.6)*c.zyxw )*(1.-AlphaFallof*o.z);
    gl_FragColor = vec4(c);
}