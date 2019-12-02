
#ifdef GL_ES
precision highp float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//#define PAL(0,  32, 8,  40, 2,  34, 10, 42, 48, 16, 56, 24, 50, 18, 58, 26, 12, 44, 4,  36, 14, 46, 6,  38, 60, 28, 52, 20, 62, 30, 54, 22, 3,  35, 11, 43, 1,  33, 9,  41,51, 19, 59, 27, 49, 17, 57, 25, 15, 47, 7,  39, 13, 45, 5,  37, 63, 31, 55, 23, 61, 29, 53, 21)

float bayer( vec2 rc )
{
  int dx1 = int(mod(rc.x, 4.));
  int dy1 = int(mod(rc.y, 4.));
  if (dx1 == 0 && dy1 == 0) return  0.;
  else if (dx1 == 1 && dy1 == 0) return  8.;
  else if (dx1 == 2 && dy1 == 0) return  2.;
  else if (dx1 == 3 && dy1 == 0) return 10.;
  else if (dx1 == 0 && dy1 == 1) return 12.;
  else if (dx1 == 1 && dy1 == 1) return  4.;
  else if (dx1 == 2 && dy1 == 1) return 14.;
  else if (dx1 == 3 && dy1 == 1) return 6.;
  else if (dx1 == 0 && dy1 == 2) return 3.;
  else if (dx1 == 1 && dy1 == 2) return 11.;
  else if (dx1 == 2 && dy1 == 2) return  1.;
  else if (dx1 == 3 && dy1 == 2) return  9.;
  else if (dx1 == 0 && dy1 == 3) return 15.;
  else if (dx1 == 1 && dy1 == 3) return  7.;
  else if (dx1 == 2 && dy1 == 3) return 13.;
  else if (dx1 == 3 && dy1 == 3) return  5.;
}

void main( void ) {

float t;
    t = time * 0.91;
    vec2 r = resolution,
    o = gl_FragCoord.xy - r/2.;
    o = vec2(length(o) / r.y - .3, atan(o.y,o.x));
    vec4 s = 0.08*cos(1.5*vec4(0,1,2,3) + t + o.y + sin(o.y) * cos(t)),
    e = s.yzwx,
    f = max(o.x-s,e-o.x);

    vec4 color = dot(clamp(f*r.y,0.,1.), 72.*(s-e)) * (s-.1) + f;
    
    float threshold = bayer(gl_FragCoord.xy)/16.;
    float pr = step(threshold, float(color.r));
    float pg = step(threshold, float(color.g));
    float pb = step(threshold, float(color.b));
    
    gl_FragColor = vec4(pr,pg,pb, 1.0);

}
