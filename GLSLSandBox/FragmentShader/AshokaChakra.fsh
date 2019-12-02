/**
Ashoka chakra is one of the most common depictions of the dharma chakra,
which in turn is one of the oldest known symbols in Buddhism and Hinduism.
Ashoka Chakra was adopted by India in 1947 and is present at the center of the
Indian Flag today.

Best viewed in fullscreen mode.
*/

precision highp float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415926535

#define ROT(x) mat2(cos(x), -sin(x), sin(x), cos(x))

#define RADIUS .7
#define HALF_RADIUS RADIUS * .5
#define NAVY_BLUE vec3(0., 0., .534)

// iq's 2d sdf for iscosceles triangles (https://www.shadertoy.com/view/MldcD7)
float isoscelesTriangle(in vec2 q, in vec2 p)
{
    p.y -= .5;
    p.x = abs(p.x);
    
    vec2 a = p - q * clamp(dot(p, q) / dot(q, q), 0., 1.);
    vec2 b = p - q * vec2(clamp(p.x / q.x, 0., 1.), 1.);
    
    float s = -sign(q.y);

    vec2 d = min(vec2(dot(a, a), s * (p.x * q.y - p.y * q.x)),
                  vec2(dot(b, b), s * (p.y - q.y)));

    return -sqrt(d.x) * sign(d.y);
}

float getChakra(vec2 uv)
{
    float outerCircle = smoothstep(.005, -.005, abs(length(uv) - RADIUS - .22) - .06);
    float innerCircle = smoothstep(.22, .21, length(uv));
    float spokes = 0., spokeThickness = .03, notches = 0., theta = 2. * PI / 24.;
    for (int i = 0; i < 24; ++i)
    {
        vec2 suv = ROT(float(i) * theta) * uv;
        // shorter inward pointing triangle
        suv.y += HALF_RADIUS;
        spokes += smoothstep(.005, .0,
                    isoscelesTriangle(vec2(spokeThickness, RADIUS * .334), suv));
        // longer outward pointing triangle
        suv.y -= RADIUS + .005;
        spokes += smoothstep(.005, .0,
                    isoscelesTriangle(vec2(spokeThickness, -RADIUS * .666), suv));
        
        // boundary notches
        vec2 nuv = ROT(float(i) * theta + theta * .5) * uv;
        nuv.y -= RADIUS + .16;
        notches += smoothstep(.04, .039, length(nuv));
    }
    
    float chakra = notches + innerCircle + outerCircle + spokes;
    return max(0., 1. - chakra);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (2. * fragCoord - resolution.xy) / min(resolution.x, resolution.y);
    
    // oscillate the chakra's rotation
    uv = ROT(sin(time * .2)* PI) * uv;

    vec3 col = vec3(0.);
    col += getChakra(uv) + NAVY_BLUE;

    fragColor = vec4(col,1.0);
}

void main(void)
{
    mainImage(gl_FragColor, gl_FragCoord.xy);
    gl_FragColor.a = 1.0;
}
