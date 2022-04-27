#define PI 3.14159

#define ROWS 3
#define NB_BALLS_PER_ROW 7
#define ROTATION_ANGLE PI/7.0


float ballProximity(float radius, float time, vec2 fragCoord)
{
    float proximity = 0.0;
	vec2 circleCenter = vec2(0.0,0.0);
    
    //New galaxy center position
    circleCenter = vec2(cos(time)*radius , sin(time)*radius);
    
    //squeeze the galaxy vertically
    circleCenter /= vec2(1.0,2.5);
    
    float cosRot = cos(ROTATION_ANGLE);
    float sinRot = sin(ROTATION_ANGLE);
    //Rotate
    circleCenter = vec2(cosRot* circleCenter.x + -sinRot*circleCenter.y,
    					sinRot*circleCenter.x + cosRot*circleCenter.y);
    
    //Center on the screen
    circleCenter += vec2(iResolution.x/2.0,iResolution.y/2.0);
    
    proximity = distance(fragCoord, circleCenter);
    
    ///lol looks like eyes without this line commented
    //proximity -= distance(fragCoord, (iResolution.xy/2.0))/50.0;
    return 1.0/proximity;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    vec2 uv = fragCoord/iResolution.xy;
    
    
    float proximity = abs(1.0/(fragCoord.x - iResolution.x/2.0));
    vec3 col = vec3(0.0);
    
    float time= (1.0*iTime);
    float radius = 50.0;
    float lightReduce = 0.5;
    
    //add center of galaxy
    col = col + vec3(2.0*ballProximity(0.0, time, fragCoord));
    
    //add all the other planets/Suns/whateveryouwant
    for(int i = 0; i < ROWS; i++)
    {
        
        for(int j = 0; j < NB_BALLS_PER_ROW; j++)
        {
            col = col + vec3(lightReduce*ballProximity(radius, time + (2.0*PI*float(j))/ float(NB_BALLS_PER_ROW), fragCoord));
        }
        
        radius = radius*2.0;
    	time = time/2.0;
        lightReduce *= 2.0;
    }
    
    //Mid Clip to negative color
    //col = mix(col, 1.0-col, clamp(fragCoord.x-iResolution.x/2.0,0.0,1.0));
    
    fragColor = vec4(col,1.0);
}


