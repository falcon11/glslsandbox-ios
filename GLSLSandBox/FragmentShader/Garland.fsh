precision highp float;
uniform float time; // time
uniform vec2  resolution; // resolution

void main(void){
    vec3 destColor = vec3(0.9, 0.2, 0.1);
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y); // 正規化
    float a = atan(p.y / p.x) * 20.0;
    float l = 0.05 / abs(length(p) - 0.8 + sin(a + time * 3.5) * 0.1);
    
    destColor *= 0.5 + sin(a + time * 00.03) * 0.03;
    
    vec3 destColor2 = vec3(0.5, 0.2, 0.9);
    vec2 p2 = (gl_FragCoord.xy * 3.0 - resolution) / min(resolution.x, resolution.y); // 正規化
    float a2 = atan(p.y / p.x) * 1.0;
    float l2 = 0.05 / abs(length(p) - 0.9 + sin(a + time * 13.5) * (0.1 * l));
    destColor2 *= 0.5 + sin(a + time * 00.03) * 0.03;
    
    vec3 destColor3 = vec3(0.2, 0.9, 0.5);
    vec2 p3 = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y); // 正規化
    float a3 = atan(p.y / p.x) * 10.0;
    float l3 = 0.05 / abs(length(p) - 0.9 + sin(a + time * 23.5) * (0.1 * l2));
    destColor3 *= 0.5 + sin(a + time * 00.03) * 0.03;
    
    gl_FragColor = vec4(l*destColor + l2*destColor2 + l3*destColor3, 1.0);
}
