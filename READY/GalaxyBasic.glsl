 precision highp float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;

#define PI 3.14159

//PARAMS
//0 100
int ROWS = 5;
//0 500
float CoreSize = 10.;
//0 500
float Radius = 50.;
//0 100
float Speed = 1.;
//0 2
float LightFalloff = .5;
//0 50
int NumberBalls = 7;
//0 100
float RowSpacing = 2.0;
//0 100
float RowLightFallOff = 2.0;
//-2 2
float RowSpeedFallOff = 2.;
//0 100
float SqueezeY = 2.5;
//0 100
float SqueezeX = 1.;
//0 1000
float TimeOffset = 1.;
//-100 100
float XPos = 0.;
//-100 100
float YPos = 0.;
//0 1
float AltMix = 0.;

//ENDPARAMS
float ballProximity(float radius, float time, vec2 fragCoord)
{
    float proximity = 0.0;
	vec2 circleCenter = vec2(0.0,0.0);
  
    //New galaxy center position
    circleCenter = vec2(cos(time)*radius , sin(time)*radius);
    
    //squeeze the galaxy vertically
    circleCenter /= vec2(SqueezeX,SqueezeY);
    float rotationAngle = PI/float(NumberBalls);
    float cosRot = cos(rotationAngle);
    float sinRot = sin(rotationAngle);
    //Rotate
    circleCenter = vec2(cosRot* circleCenter.x + -sinRot*circleCenter.y,
    					sinRot*circleCenter.x + cosRot*circleCenter.y);
    
    //Center on the screen
    circleCenter += vec2(u_resolution.x/2.0,u_resolution.y/2.0);
    circleCenter += vec2(XPos*u_resolution.x/100., YPos*u_resolution.y/100.);
    proximity = distance(fragCoord.xy, circleCenter);
    
    ///lol looks like eyes without this line commented
    // proximity -= distance(gl_FragCoord.xy, (u_resolution.xy/1.0))/10.0;
    float alt = proximity - distance(fragCoord.xy, (u_resolution.xy/1.0))/10.0;
    float final = mix(proximity, alt, AltMix);
    return 1.0/final;
}


void main()
{
    
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    
    float proximity = abs(2.0/(gl_FragCoord.x - u_resolution.x/2.0));
    vec3 col = vec3(0.0);
    
    float local_time= (Speed*u_time)+TimeOffset;
    float radius = Radius;
    float lightReduce = LightFalloff;
    float st = sin(u_time);
    //add center of galaxy
    col = col + vec3(CoreSize*ballProximity(.0, local_time, gl_FragCoord.xy));
    //add all the other planets/Suns/whateveryouwant
    for(int i = 0; i < 100; i++)
    {
        if (i < ROWS){
            for(int j = 0; j < 50; j++){
                if (j < NumberBalls){
                    col = col + vec3(lightReduce*ballProximity(radius, local_time + (2.0*PI*float(j))/ float(NumberBalls), gl_FragCoord.xy));
                };
            }
           
            radius = radius*RowSpacing;
            local_time = local_time/RowSpeedFallOff;
            lightReduce *= RowLightFallOff;
        }
    }
    
    
    gl_FragColor = vec4(col,1.0);
}


