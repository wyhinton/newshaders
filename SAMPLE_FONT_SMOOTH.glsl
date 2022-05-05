#version 300 es

precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture_10;

out vec4 fragColor;

float sampleFontSmooth(in vec2 uv) {
    // vec2 st = uv * iChannelResolution[0].xy;
    vec2 st = uv * vec2(1200., 400.).xy;
    ivec2 xy = ivec2(st);

    float bl = texelFetch(u_texture_10, xy, 0).w;
    float br = texelFetch(u_texture_10, xy + ivec2(1, 0), 0).w;
    float tl = texelFetch(u_texture_10, xy + ivec2(0, 1), 0).w;
    float tr = texelFetch(u_texture_10, xy + 1, 0).w;

    vec2 local = fract(st);
    //local *= local * (3.0 - 2.0 * local);
    return mix(mix(bl, br, local.x), mix(tl, tr, local.x), local.y);
}

vec4 mapScene(in vec3 p) {
    float c = cos(u_time), s = sin(u_time);
    p.xz *= mat2(c, -s, s, c);
    p.yz *= mat2(c, -s, s, c);

    float ww = 30.0, wh = 25.0, wd = 1.0;

    float font = sampleFontSmooth((p.xy + vec2(ww, wh)) / vec2(2.0 * ww, 2.0 * wh)) - 0.5;
    font = max(font, max(max(abs(p.x) - ww, abs(p.y) - wh), abs(p.z) - wd));

    return vec4(font, vec3(1.0));
}

vec3 getNormal(in vec3 p) {
    vec3 e = vec3(0.001, 0.0, 0.0);
    return normalize(vec3(mapScene(p + e.xyy).x - mapScene(p - e.xyy).x,
                          mapScene(p + e.yxy).x - mapScene(p - e.yxy).x,
                          mapScene(p + e.yyx).x - mapScene(p - e.yyx).x));
}

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
    fragColor = vec4(0.0, 0.0, 0.0, 1.0);

    vec3 ro = vec3(0.0, 0.0, 50.0);
    vec3 rd = normalize(vec3(uv, -1.0));

    float t = 0.0;
    for (float iters=0.0; iters < 150.0; iters++) {
        vec3 p = ro + rd * t;
        vec4 scene = mapScene(p);
        if (scene.x < 0.001) {
            vec3 n = getNormal(p);
            vec3 l = vec3(-0.58, 0.58, 0.58);
            fragColor.rgb += scene.yzw;
            fragColor.rgb *= max(0.2, dot(n, l));
            break;
        }

        if (t > 200.0) {
            break;
        }

        t += scene.x;
    }

    //gl_FragColor = smoothstep(0.05, 0.0, vec4(texture(iChannel0, gl_FragCoord / u_resolution.xy).w - 0.5));
}