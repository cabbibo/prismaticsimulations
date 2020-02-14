
uniform float time;
uniform sampler2D t_audio;
uniform sampler2D t_matcap;
uniform sampler2D t_normal;

uniform vec4 light1;
uniform vec4 light2;
uniform vec4 light3;

varying vec3 vPos;
varying vec3 vCam;
varying vec3 vNorm;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;


varying float vWater;

$uvNormalMap
$semLookup
$hsv



void main(){

  vec3 col =vec3(0.);

  vec3 fCol = vMNorm * .5 + .5;

  vec3 d1 = vMPos - light1.xyz;
  float m1 = -dot( vMNorm , normalize(d1));
  float l1 = length( d1 );
  col  += m1 * hsv(m1  * .4 + .6,1.,m1) / (l1 * l1);

  vec3 d2 = vMPos - light2.xyz;
  float m2 = -dot( vMNorm , normalize(d2));
  float l2 = length( d2 );
  col  +=  m2 * hsv(m2 * .5 + .6 ,1.,m2) / (l2 * l2);


  vec3 d3 = vMPos - light3.xyz;
  float m3 = -dot( vMNorm , normalize(d3));
  float l3 = length( d3 );
  col += m3 * hsv(m3 * .4 + .6 ,1.,m3) / (l3 * l3);


  col *= clamp( 3. * vPos.z + .8 , 0. , 1.);

  /*if( vWater < .15 ){
    col *= vWater/.15;//vec3( 1. );
  }*/

  gl_FragColor = vec4( col , 1. );

}



