precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_0;

// DOT SIZE
const int DS=3;
// DRAW DOT

bool DOT(int x, int y, ivec2 p)
{
    return x==int(p.x) && y==int(p.y);
}
// DRAW NUM
bool DRAW(int i, int sx, int sy, ivec2 p){

    //ivec2 p = ivec2(gl_FragCoord)/DS;
    
    if (i==0) return//Num 0
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)
    ;

    if (i==1) return//Num 1
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+2,sy+2,p)||
    DOT(sx+2,sy+3,p)||
    DOT(sx+2,sy+4,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+1,sy+4,p)
    ;
    
    if (i==2) return//Num 2
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+2,sy+3,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+2,sy+5,p)
    ;
    
    if (i==3) return//Num 3
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)||
    DOT(sx+2,sy+3,p)
    ;
    
    if (i==4) return//Num 4
    DOT(sx+3,sy+1,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)||
    DOT(sx+2,sy+3,p)
    ;   

    if (i==5) return//Num 5
    DOT(sx+3,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+1,sy+1,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+2,sy+3,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+2,sy+5,p)
    ;

    if (i==6) return//Num 6
    DOT(sx+3,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+1,sy+1,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+2,sy+3,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+1,sy+2,p)
    ;
    
    if (i==7) return//Num 7
    DOT(sx+3,sy+1,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+4,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+3,sy+5,p)
    ;

    if (i==8) return//Num 8
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)||
    DOT(sx+2,sy+3,p)
    ;

    if (i==9) return//Num 9
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)||
    DOT(sx+2,sy+3,p)
    ;
    
    if (i==10) return//Num A
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+3,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)
    ;
    
    
    if (i==11) return//Num B
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+4,p)||
    DOT(sx+2,sy+3,p)
    ;
    
    if (i==12) return//Num C
    DOT(sx+2,sy+1,p)||
    DOT(sx+3,sy+1,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)
    ;
    
    if (i==13) return//Num D
    DOT(sx+1,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+3,sy+2,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+3,sy+4,p)
    ;
    
    if (i==14) return//Num E
    DOT(sx+3,sy+1,p)||
    DOT(sx+2,sy+1,p)||
    DOT(sx+1,sy+1,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+2,sy+3,p)
    ;
    
    if (i==15) return//Num F
    DOT(sx+1,sy+1,p)||
    DOT(sx+3,sy+5,p)||
    DOT(sx+2,sy+5,p)||
    DOT(sx+1,sy+5,p)||
    DOT(sx+3,sy+3,p)||
    DOT(sx+1,sy+2,p)||
    DOT(sx+1,sy+3,p)||
    DOT(sx+1,sy+4,p)||
    DOT(sx+2,sy+3,p)
    ;
    return false;
}
//LOG FLOAT VALUE
vec4 LOG(float n, bool flt, int sys, int str, vec4 inCol, vec2 inCoord) {
    // fps speed up
    ivec2 p = ivec2(inCoord)/DS;
    if(p.y<(2+6*(str+1))&&p.y>=(2+6*(str))&&p.x<=(4*45)) 
    {
        vec4 res = inCol;
        vec4 res0 = 1.0-inCol;//out color
        
        str=str*6;
        int pos = 1; float num = 0.0; float m; int s=-1;

        //draw first minus of float n
        if (n < 0.0) {
            n = abs(n);
            if(DOT(2, str+4, p)) res=res0;
            if(DOT(3, str+4, p)) res=res0;
            pos+=3;
        }

        //length before dot of float n
        int k=1;
        for (int i=1;i<=38&&n/pow(float(sys), float(i))>=1.0;i++) {
            k=i+1;
        }

        //draw float n before dot
        for(int j = k; j>=1; j--) {
            m=pow(float(sys),float(j));
            num = mod(n, m)*float(sys)/m;
            if(int(floor(num))>=0)
            {
                if (num>=0.0) {
                    if (DRAW(int(floor(num)), pos, str+1, p)) {
                        res=res0; //color invert
                    } pos+=4;
                }

            }
        }
        
        if (flt) {

            // draw dot
            if (DOT(pos+1, str+2, p))
                res=res0;//color invert

            //length after dot of float n
            float nn=mod(n, 1.0); k=0;
            for (int i=1;i<=38&&mod(nn*pow(float(sys), float(i)),1.0)!=0.0;i++) {
                    k=i;
            } n = nn*pow(float(sys), float(k));

            // draw float n after dot
            pos = pos+2;
            for(int j = k; j>=0; j--) {
                m=pow(float(sys),float(j));
                num = mod(n, m)*float(sys)/m;
                if(int(floor(num))>=0)
                {
                    if (num>=0.0) {
                        if (DRAW(int(floor(num)), pos, str+1, p)) {
                            res=res0;//color invert
                        } pos+=4;
                    }


                }
            }
        }

        return res; //color invert
    }
    else {
        return gl_FragColor;
    }
}
vec4 LOG(float n, int str, vec4 inCol, vec2 inCoord) {
    return LOG(n, true, 10, str, inCol, inCoord);
}

vec4 LOG(int n, int sys, int str, vec4 inCol, vec2 inCoord) {
    return LOG(float(n), false, sys, str, inCol, inCoord);
}
vec4 LOG(int n, int str, vec4 inCol, vec2 inCoord) {
    return LOG(float(n), false, 10, str, inCol, inCoord);
}

// START
void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    // vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    // // Time varying pixel color
    // vec3 col = 0.5 + 0.5*cos(u_time+uv.xyx+vec3(0,2,4));
    // // Output to screen
    // vec4 finalCol = vec4(col,1.0);
    
    // // Mouse: Normalized pixel coordinates (from 0 to 1)
    // vec2 uvm = u_mouse.xy/u_resolution.xy;
    // // Mouse: Time varying pixel color
    // vec3 colm = 0.5 + 0.5*cos(u_time+uvm.xyx+vec3(0,2,4));
    // // Mouse: Output to buffer
    // vec4 mouseColor = vec4(colm,1.0);
    
    // // Logging. Int val for string number, started from bottom
    // gl_FragColor = LOG(mouseColor.z, 0, finalCol, gl_FragCoord.xy);
    // gl_FragColor = LOG(mouseColor.y, 1, finalCol, gl_FragCoord.xy);
    // gl_FragColor = LOG(mouseColor.x, 2, finalCol, gl_FragCoord.xy);
    
    // gl_FragColor = LOG(-int(u_mouse.y), 4, finalCol, gl_FragCoord.xy);
    // gl_FragColor = LOG(-int(u_mouse.x), 5, finalCol, gl_FragCoord.xy);
    
    // gl_FragColor = LOG(0xFF1234, 16, 7, finalCol, gl_FragCoord.xy);
    gl_FragColor = vec4(1.);
    // gl_FragColor = LOG(16, 2, 8, finalCol, gl_FragCoord.xy);


}