#version 300 es

precision highp float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;

out vec4 fragColor;

#define SHOW_BLOCKS

float rand(float x)
{
    return fract(sin(x) * 4358.5453123);
}

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5357);
}

float softBox(vec2 p, vec2 b, float r)
{
  return length(max(abs(p)-b,0.0))-r;
}

float getBox(vec2 p, float left, float bottom, float width, float height) {
    float sm = 0.002;
    // p.x = fract(p.x*10.);
    float x_range = smoothstep(left - sm, left, p.x) - smoothstep(left + width, left + width + sm, p.x);
    float y_range = smoothstep(bottom - sm, bottom, p.y) - smoothstep(bottom + height,bottom + height + sm, p.y);

    return x_range * y_range;
}

float getUvBox(vec2 p, float left, float bottom, float width, float height) {
    float sm = 0.002;
    // p.x = fract(p.x*10.);
    float x_range = smoothstep(left - sm, left, p.x) - smoothstep(left + width, left + width + sm, p.x);
    float y_range = smoothstep(bottom - sm, bottom, p.y) - smoothstep(bottom + height,bottom + height + sm, p.y);
    // return smoothstep(left, p.x+width, p.x+.5);
    // return p.x;
    // float x1 
    return x_range;
    // return x_range * y_range;
}


// float sampleMusic()
// {
// 	return 0.5 * (
// 		//texture( iChannel0, vec2( 0.01, 0.25 ) ).x + 
// 		//texture( iChannel0, vec2( 0.07, 0.25 ) ).x + 
// 		texture( iChannel0, vec2( 0.15, 0.25 ) ).x + 
// 		texture( iChannel0, vec2( 0.30, 0.25 ) ).x);
// }

#define c1 vec4(2.0,2.5,1.4,0)

//PARAMS 
//0 1
float Scale = .1;
//0 1
float Offset = .18;
//0 2
float YSpeed = .0;
//0 1
float XSpeed = 0.;
//0 100
int Iterations1 = 2;
//0 100
int Iterations2 = 9;
//1 2
float Scale2 = 1.05;
//0 1
float FMult = .8;
//0 1000
float TimeOffset = 0.;
//0 1
float FlashSpeed = 2.9;//END_PARAMS


vec2 twave(vec2 a,float scale){
    return abs(fract((a+c1.xy)*scale)-.5);
    // return vec2(.5);
}

float fractal(vec2 p, int seed)
{
    fragColor = vec4(0.0);
    vec3 col;  
    float t1 = Scale/.1;
    float offset = Offset;
    float scale2 = 1.05;
    float localTime = 0.;
    vec2 uv = p/t1/2.0;
    // vec2 uv = (gl_FragCoord.xy-u_resolution.xy)/u_resolution.y/t1/2.0;
    uv += vec2(u_time*XSpeed,u_time*YSpeed)/t1/8.0;
    uv -= p;
    for(int c=0;c<2;c++){
        float scale = c1.z;
        // if (c< seed){
        for(int i=0;i<100;i++)
        {
            if (i < Iterations2){
                uv = twave(uv+offset,scale)+twave(uv.yx,scale);
                uv.x /= -1.;
                uv = twave(uv+c1.w+col.xy,scale);
                scale /= Scale2+col.x;
                offset *= Scale2;
                uv = uv.yx;
            }
        }
        // }

     col[c] = fract((uv.x)-(uv.y));
	}
    float st = sin(u_time);
    float a = smoothstep(.0, .0, 1.-length(col)+localTime*FlashSpeed);
    return a;
}

float makeMandala(vec2 p, float scale, float seed){
    p*=scale;
	// vec2 uv = ((gl_FragCoord.xy - u_resolution.xy/2.)/ u_resolution.y) + vec2(0, 0);
    p = floor(p);
    p = p / (2.5 + u_time*0.02);
    
    float d = 1.0; // + sqrt(length(uv)) / 109.0;
    float t = 10. + u_time + rand(seed+200.)*100.;
    float value = d * t + (t * 0.125) * cos(p.x) * cos(p.y);
    float color = sin(value) * 3.0;

    return color;
}

float sdCircle( in vec2 p, in float r ) 
{
    return length(p)-r;
}


void main()
{
	// const float speed = 0.0;
	const float speed = 0.1;
	const float ySpread = 1.6;
	const int numBlocks = 20;

	float pulse = .4;
	
	vec2 uv = gl_FragCoord.xy / u_resolution.xy - 0.5;
	float aspect = u_resolution.x / u_resolution.y;
	vec3 baseColor = vec3(0.3216, 0.3373, 0.3569);
	// vec3 baseColor = uv.x > 0.0 ? vec3(0.3216, 0.3373, 0.3569) : vec3(0.6, 0.0, 0.3);
	
	vec3 color = pulse*baseColor*0.5*(0.9-cos(uv.x*8.0));
	uv.x *= aspect;
    float f;
    // float f = fractal(uv);
    vec3 fColor = baseColor *f;
    float blockOpacity = .5;
	// float 
    vec2 ng;
    float qbTest;
    vec4 mapTest;
	for (int i = 0; i < numBlocks; i++)
	{
		float z = 1.0-0.7*rand(float(i)*1.4333); // 0=far, 1=near
		float tickTime = u_time*z*speed + float(i)*1.23753;
		float tick = floor(tickTime);
		
		vec2 pos = vec2(aspect*(rand(tick))-.5*aspect, ySpread*(0.5-fract(tickTime)));
        ng += pos;
		// vec2 pos = vec2(0.6*aspect*(rand(tick)-0.5), sign(uv.x)*ySpread*(0.5-fract(tickTime)));
		// pos.x += 0.24*sign(pos.x); // move aside
		// if (abs(pos.x) < 0.1) pos.x++; // stupid fix; sign sometimes returns 0
        if (z > .9665 ){
            float xMin = 0.004;
            vec2 size = 1.8*z*vec2(xMin, 0.04 + 0.1*rand(tick+0.2));
            float b = softBox(uv-pos, size, 0.01);
            float dust = z*smoothstep(0.22, 0.0, b)*pulse*0.5;
            // #ifdef SHOW_BLOCKS
            float block = blockOpacity*z*smoothstep(0.002, 0.0, b);
            float shine = 0.6*z*pulse*smoothstep(-0.002, b, 0.007);
             f = fractal(uv-pos, int(z)*2);
            block *=f;
            // color = vec3(f*.1);
            color += dust*baseColor + block*z + shine;
        } 
        if (z > .9 ){
   
            // uv = uv * (1.0 - 0.2 * smoothstep(0.25, 0.0, dot(uv, uv)));
            // uv = uv * (1.0 - 0.2 * smoothstep(0.25, 0.0, dot(uv, uv)));
            // uv = uv + vec2(0.5);
            vec2 size = 1.8*z*vec2(0.04, 0.04 + 0.1*rand(tick+0.2));
            // float b = softBox(uv-pos, size, 0.01);
            float b = getBox((uv-pos), .1, .1, size.x, size.y);
            float dust = z*smoothstep(0.22, 0.0, b)*pulse*0.5;
            qbTest = smoothstep(pos.x, pos.x+size.x, uv.x);
            qbTest = smoothstep(pos.x, pos.x+size.x, uv.x);
            qbTest = smoothstep(pos.x, (uv-pos).x, uv.x);
            qbTest = smoothstep(pos.x*size.x, size.x+pos.x, uv.x+pos.x);
            qbTest = smoothstep(pos.x*size.x, pos.x+size.x, uv.x+pos.x);
            qbTest = getUvBox((uv-pos), .1, .1, size.x, size.y);
            mapTest = texture(u_texture_0, vec2(qbTest, uv.y))*b;
            // qbTest = smoothstep(.2, .5, uv.x);
            // uv = vec2(b*.4);
            // uv += b;
            // uv *= 2.;
            // uv.x += .5;
        //     // #ifdef SHOW_BLOCKS
        //     float block = blockOpacity*z*smoothstep(0.002, 0.0, b);
        //     float shine = 0.6*z*pulse*smoothstep(-0.002, b, 0.007);
        //     // block *=f;
        //     vec2 gv = uv/size;
        //     // vec4 c = texture(u_texture_0, gv-pos);
        //     // color = vec3(f*.1);
        //     // block 
        //     // color += block;
        //     color += dust*baseColor + block*z + shine;
         
        //     // color += smoothstep((uv-pos).x, uv.x, 1.1);
        //     // color += dust*baseColor + block*z + shine;
        //     // color += gv.x;
        //     float n = smoothstep(pos.x+size.x, uv.x, pos.x);
        //     vec4 c = texture(u_texture_0, vec2(n, pos.y));
        //     // float n = smoothstep(pos.x, pos.x+size.x, uv.x);
        //     color += n;
        //     color = mix(color, c.rgb, 1.);
        //     // color.rgb += c.rgb*.1;
        //     // color.r*=.5;
        //     // color.r += c.r;
        //     // color.g += pos.y*b;
        } 
        // if (mod(z, .5) > .9 ){
        //     vec2 size = 1.8*z*vec2(0.04, 0.04 + 0.1*rand(tick+0.2));
        //     float b = softBox(uv-pos, size, 0.01);
        //     float dust = z*smoothstep(0.22, 0.0, b)*pulse*0.5;
        //     // #ifdef SHOW_BLOCKS
        //     float block = blockOpacity*z*smoothstep(0.002, 0.0, b);
        //     float shine = 0.6*z*pulse*smoothstep(-0.002, b, 0.007);
        //     block *=f;
        //     // color = vec3(f*.1);
        //     color += dust*baseColor + block*z + shine;
        // } 
        
        
        
        else {
            vec2 size = 1.8*z*vec2(0.04, 0.04 + 0.1*rand(tick+0.2));
            float circ =  sdCircle(uv-pos, .05);
            // uv += circ;
            float b = softBox(uv-pos, size, 0.01);
            // b=fract(b);
            
            // b = mix(1., 09., circ);
            // b = circ;
            // float b = softBox(uv-pos, size, 0.01);
            float dust = z*smoothstep(0.22, 0.0, b)*pulse*0.5;
            // #ifdef SHOW_BLOCKS
            float block = 0.2*z*smoothstep(0.002, 0.0, b);
            // float block = 0.2*z*smoothstep(0.002, 0.0, max(circ, b));
            // float block = 0.2*z*smoothstep(0.002, 0.0, b);
            float shine = 0.1*z*pulse*smoothstep(-0.002, b, 0.007);
            // block += sdCircle(pos, .5);
        //   ;
            // block = mix(block,sdCircle(pos, .5), .4);
            // block = mix(block,sdCircle(pos, .5), .4);
            // block *= fract(uv.x*1000.);
            // color *= f;
            block += makeMandala(uv-pos, 520., z)*circ*block*2.;
            // shine *= makeMandala(uv, 5000., z);
            // shine /= makeMandala(uv, 500., z);
            // shine /= makeMandala(uv, 500., z);
            vec3 ccc = circ*vec3(1., .0, .0);
            color += dust*baseColor + block*z + shine;
            // color += mix(color, ccc, circ);
            // color = circ;
            // color += circ;
            // color *= makeMandala(uv, 120., z);
        }
		

		// #else
		// color += dust*baseColor;
		// #endif
	}
	
	color -= rand(uv)*.04;
	fragColor = vec4(color, 1.0);
	fragColor = vec4(uv.x);
	fragColor = vec4(qbTest);
	// fragColor = mapTest;
	// fragColor = vec4(length(ng.x));
}