
uniform float time;

varying vec3 vPos;
varying vec3 vNorm;
varying vec3 vCam;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;
varying float vWater;

$simplex



vec3 nP(vec3 n, vec3 p, vec2 uv ){

  float l = length( uv - vec2(.5,.5));
  float noise = snoise( uv + vec2(.7 , 0.3));
  float noise2 = snoise( uv * .4 + vec2(.0 , 1.));


  float noise3 = .03 * snoise(uv * 40. );

  return ((.5-l) * 3.* (noise +noise2)  -.3 + noise3) * n   + p;

}

vec3 nPW(vec3 nor, vec3 p, vec2 uv ){

  float n = .5 * snoise( uv * 10. + time * .2 );
  float n3 = 1. * snoise( uv * 4. + time * .3 );
  float n2 = .3 * snoise( uv * 20. + time * .3 );
  return  .1 * (n + n2 + n3) * nor + p;

}


vec3 getNormal( vec3 nor , vec3 p , vec2 uv ){

  vec3 fU = nP( nor , p + vec3( .1 , 0. , 0. ) , uv + vec2( .01 , 0. ) );
  vec3 fD = nP( nor , p - vec3( .1 , 0. , 0. ) , uv - vec2( .01 , 0. ) );
  vec3 fL = nP( nor , p + vec3( 0. , 0.1 ,0. ) , uv + vec2( .0 , 0.01 ) );
  vec3 fR = nP( nor , p - vec3( 0. , 0.1 ,0. ) , uv - vec2( .0 , 0.01 ) );

  vec3 n  = normalize(cross((fU - fD),(fR-fL)));

  return -n;

}

void main(){

  vUv = uv;



  vec3 fPos = nP(  normal , position , uv );

  vec2 ep = vec2( .1 , 0. );

  vec3 n = getNormal( normal , position , uv );

  vec3 wPos = nPW( normal , position , uv);
  vWater = length(fPos - wPos);


  // length( uv - vec2(.5,.5)) * normal + position;
  vPos = fPos;
  vNorm = n;


  vMNorm = normalMatrix * n;
  vMPos = (modelMatrix * vec4( fPos , 1. )).xyz;


  //vLight = ( iModelMat * vec4(  vec3( 400. , 1000. , 400. ) , 1. ) ).xyz;


  // Use this position to get the final position 
  gl_Position = projectionMatrix * modelViewMatrix * vec4( fPos , 1.);

}