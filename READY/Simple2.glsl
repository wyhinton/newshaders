vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float aastep(float threshold, float value) {
    float afwidth = 10.0f/iResolution.y; // pixel width for smoothstep edge 
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float stroke(float f, float size, float width) {
    return aastep(size, f+width*0.5f) - aastep(size, f-width*0.5f);
}

float fill(float f, float size) {
    return 1.-aastep(size, f);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord/iResolution.y;
    
    uv *= 10.0f;
    
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);
    
    vec2 mDist = vec2(1.0f); // x least point distnace, y 2nd least point distance
    
    for(int j=-1; j<=1; ++j) {
        for(int i=-1; i<=1; ++i) {
            vec2 neighbour = vec2(float(i), float(j));
            vec2 point = random2(iuv + neighbour);
            
            // animate
            point = 0.5f + 0.5f*sin(iTime + 6.2831f*point);
            
            vec2 diff = neighbour + point - fuv;
                        
            float dist = dot(diff, diff); // lenght^2
            
            if(dist < mDist.x) {
                mDist.y = mDist.x;
                mDist.x = dist;
            } else if(dist < mDist.y) {
                mDist.y = dist;
            }
        }
    }
    
    mDist = sqrt(mDist);
    
   vec3 col = vec3(fill(mDist.y - mDist.x, 0.04f)); // F2-F1 Voronoi,
    //vec3 col = vec3(stroke(mDist.y - mDist.x, 0.05f, 0.02f)); // F2-F1 Voronoi,


    fragColor = vec4(1.0f - col,1.0);
}