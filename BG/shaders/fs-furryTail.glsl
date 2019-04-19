#ifdef GL_OES_standard_derivatives
    #extension GL_OES_standard_derivatives : enable
#endif  

uniform sampler2D t_audio;
uniform sampler2D t_sem;

varying vec3 vColor;
varying vec3 vNorm;

varying vec3 vView;
varying vec3 vWorld;
varying vec3 vLightDir;
varying vec2 vUv;
varying vec2 vID;
varying vec2 vSEM;

void main(){

  vec3 nNormal = vNorm;


  vec3 x = dFdx(vWorld);
  vec3 y = dFdy(vWorld);

  vec3 nNormal2 = normalize(cross(x,y));



  vec3 nReflection = normalize( reflect( vView , nNormal )); 

  float nViewDot = dot( normalize( nNormal ), normalize( vView ) );
  float iNViewDot = 1.0 - max( nViewDot  , 0.0);
  
  vec3 refl = reflect( vLightDir , nNormal );
  float facingRatio = abs( dot(  nNormal, refl) );



  vec4 aColor = texture2D( t_audio , vec2( vUv.y * .2 + vID.y * .5, 0.0));
  vec4 aSEM= texture2D( t_sem , vSEM);

  vec3 aC = ((aColor.xyz * aColor.xyz * aColor.xyz) - .2) * 1.4 ;

  if( abs(vUv.x - .5) > .5 - length( aC ) ){ discard;}
  vec3 a2 = vec3(0.,1.,0.);
  gl_FragColor = vec4( nNormal2 * .5 + .5 , 1.0 );
  //gl_FragColor = vec4(aSEM.xyz, 1.0 );

}
