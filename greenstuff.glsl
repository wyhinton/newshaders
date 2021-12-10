uniform float u_time;
uniform vec2 u_resolution;

vec2 smoothRot(vec2 p,float s,float m,float c,float d){
  s*=0.5;
  float k=length(p);
  float x=asin(sin(atan(p.x,p.y)*s)*(1.0-m))*k;
  float ds=k*s;
  float y=mix(ds,2.0*ds-sqrt(x*x+ds*ds),c);
  return vec2(x/s,y/s-d);
}

mat2 rotate(float a)
{
	float c = cos(a);
	float s = sin(a);
	return mat2(c, s, -s, c);
} 
void main()
{
    vec4 k = vec4(0.);
    vec3 col1 = vec3(0.01,0.03,0.01);
    vec3 col2 = vec3(0.5,0.9,0.3);
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

    uv *= rotate(fract(u_time*0.01)*6.28);

    float dd2 = length(uv);
    float dd1 = smoothstep(0.0,0.3,dd2);

    //if (abs(uv.x)>0.2)
        col2 *= 1.0-abs(uv.x*0.75);
        col1 *= 1.0-abs(uv.x*0.75);

    float dnoise = 15.0*(dd1);
    // uv *= rotate(-dnoise*0.05);
    
    float dns = 0.5+sin(u_time*.45)*0.5;
    dnoise = mix(dnoise,0.0,dns);
    
    float oo = 0.5+sin(dnoise+uv.y+uv.x*12.0+u_time*0.5)*0.5;
    uv = smoothRot(uv,6.0,0.085,16.0,.075*oo);
    vec2 d = uv*5.0;
    d.x += fract(u_time);
    float v1=length(0.5-fract(d.xy))+0.58;
    d = (uv*1.75);			// zoom
    float v2=length(0.5-fract(d.yy))-0.1525;		// border
    v1 *= 1.2-v2*v1;
    v1 = smoothstep(0.1,0.9,v1);
    vec3 col = mix(col2,col1,v1)*dd1;
    k = vec4(col*4.75,1.0);
    gl_FragColor = k;
}