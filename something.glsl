uniform float u_time;
uniform vec2 u_resolution;

#define R(p,a,r)mix(a*dot(p,a),p,cos(r))+sin(r)*cross(p,a)
#define H(h)(cos((h)*6.3+vec3(0,23,21))*.5+.5)
#define M(p)vec2(asin(sin(atan(p.x,p.y)*6.))/8.,1)*length(p)
void main()
{
    vec4 O=vec4(0);
    vec3 p;
    vec2 r=u_resolution.xy;
    vec3 d=normalize(vec3((C-.5*r.xy)/r.y,1.));
    for(float i=0.,g=0.,e,t=u_time;++i<99.;){
        p=g*d-vec3(2,2,9);
        p=R(p,
            normalize(R(vec3(1,2,3),vec3(.577),t*.3))
            ,t*.2);
        for(int j=0;j++<4;){
            p.xy=M(p.xy);
            p.y-=3.2+sin(t*.2)*.6;
            p.yz=M(p.yz);
            p.z-=6.5;
        }
        g+=e=dot(sqrt(p*p+.005),normalize(vec3(1.6,2.1,.9)))-1.;
        O.xyz+=mix(vec3(1),H(length(p)*3.),.3)*.015*exp(-3.*i*i*e);
    }
    O*=O;
    gl_FragColor = O;
}