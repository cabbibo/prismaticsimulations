uniform sampler2D t_pos;
uniform sampler2D t_oPos;
uniform sampler2D t_audio;

uniform float dpr;
uniform float particleSize;

attribute vec2 uv2;

uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec3 color4;

varying vec3 vColor;
varying vec3 vNorm;

varying vec2 vUv;

varying vec2 vID;

const float size = 1. / 32.;
const float hSize = size / 2.;
const vec3 lightPos = vec3( 1.0 , 1.0 , 1.0 );



// Optimised by Alan Zucconi
vec3 bump3y (vec3 x, vec3 yoffset)
{
 vec3 y = vec3( 1. - x * x );
 y = clamp(y-yoffset,0.,1.);
 return y;
}
vec3 spectral (float w)
{
    // w: [400, 700]
 // x: [0,   1]
 float x = w;// clamp((w - 400.0)/ 300.0,0.,1.);
 
 const vec3 cs = vec3(3.54541723, 2.86670055, 2.29421995);
 const vec3 xs = vec3(0.69548916, 0.49416934, 0.28269708);
 const vec3 ys = vec3(0.02320775, 0.15936245, 0.53520021);
 
 return bump3y ( cs * (x - xs), ys);
}



void main(){

  vec4 a = texture2D( t_audio , vec2( position.y * .5 , 0.));

  vec4 pos    =  texture2D( t_pos , position.xy );
  vec4 oPos    =  texture2D( t_oPos , position.xy );

  vec3 left = vec3(1.,0.,0.);///cross( vView , vec3(0.,1.,0.) );
  vec3 up  = vec3(0.,1.,0.);
  vUv = uv2;
  vID = vec2( position.y , 0. );
  vNorm = normalize(pos.xyz-oPos.xyz);
  vColor = spectral(position.y + vUv.y*.2 );


  vec3 fPos = pos.xyz +  ((uv2.x - .5)  * left + (uv2.y-.5) * up) * 10. * position.y;


  vec4 mvPos = modelViewMatrix * vec4( fPos , 1.0 );
  gl_Position = projectionMatrix * mvPos;

}
