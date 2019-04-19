
uniform float time;
uniform sampler2D t_audio;
uniform sampler2D t_matcap;
uniform sampler2D t_normal;

varying vec3 vPos;
varying vec3 vCam;
varying vec3 vNorm;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;

varying float vIsland;


$uvNormalMap
$semLookup
$hsv


void main(){

  vec3 col = vMNorm * .5 + .5 ;

  

  float x = dot( vMNorm , normalize(vCam));

  

    //col = vec3( 1., 0.,0.);
  

  x = 1.+x;
  x *= x;

  col = texture2D(t_audio,vec2(x,0.)).xyz;


  col *= .5 - length(vUv- vec2(.5,.5));

  gl_FragColor = vec4( col , x );

}


