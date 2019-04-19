
uniform float time;
uniform sampler2D t_audio;
uniform vec4 links[7];
uniform vec4 activeLink;
uniform vec4 hoveredLink;

uniform sampler2D t_matcap;
uniform sampler2D t_normal;
uniform sampler2D t_text;
uniform float textRatio;
uniform float interfaceRadius;

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

varying vec3 vPos;
varying vec3 vCam;
varying vec3 vNorm;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;

vec3 bulbPos[5];


$uvNormalMap
$semLookup
$hsv


// Branch Code stolen from : https://www.shadertoy.com/view/ltlSRl
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

const float MAX_TRACE_DISTANCE = 10.0;             // max trace distance
const float INTERSECTION_PRECISION = 0.01;        // precision of the intersection
const int NUM_OF_TRACE_STEPS = 25;
const float PI = 3.14159;

const vec3 moonPos = vec3( -3. , 3. , -3.);



$smoothU
$opU
$sdCapsule
$sdBox
$sdSphere
$sdHexPrism



float centerBlob1( vec3 pos  ){

  //pos.x += .1 * sin( pos.x * 20. );
  //pos.y += .1 * sin( pos.y * 20. );
  //pos.z += .1 * sin( pos.z * 20. );

  float dis = length( texture2D( t_audio , vec2( length( pos ), 0.) ) );

  float b = sdBox( pos , vec3( .4 ) );
 
  return  b - dis * .2;


}



float centerBlob2( vec3 pos  ){

  float m = 100000.;

  float dis = length( texture2D( t_audio , vec2( abs(sin(length( pos ) * 2.)), 0.) ) );

  for( int i = 0; i < 5; i++ ){

    float d = sdSphere( pos - bulbPos[i], .2 + dis * .1 );

    m = smoothU( vec2( m , 0. ) , vec2( d , 0. ) , .2 ).x;

  }
 
  return  m; //b - dis * .2;
}

float centerBlob3( vec3 pos  ){

  float dis = length( texture2D( t_audio , vec2( abs(sin(length( pos ) * 2.)), 0.) ) );

  float d = sdHexPrism( pos , vec2( .2 + dis * .1 , 1. + dis * .1  )) ;

 
  return  d; //b - dis * .2;
}

//--------------------------------
// Modelling 
//--------------------------------
vec2 map( vec3 pos ){  

    vec3 og = pos;

    vec2 res = vec2( 1000000. , 0. );




    for( int i = 0; i < 7; i++ ){
      float c = sdBox( pos  - links[i].xyz , vec3(.25) );
      res = smoothU( res , vec2(  c , float( i ) + 10. ) , .1 );
    }


    vec2 caps;

    if( hoveredLink.w > .1 ){
      caps = vec2( sdCapsule( pos , hoveredLink.xyz ,  hoveredLink.xyz * .8 , .03 ) , 30. );
      res = smoothU( res , caps , .1 ) ;
    }



    // interface tracing
    if( activeLink.w > .1 ){
      caps = vec2( sdCapsule( pos , normalize( activeLink.xyz ) * 1.9 ,  vec3( 0. ) , .01 ) , 20. );
      res = smoothU( res , caps , .3 ) ;
    }


 
    vec2 cb = vec2( centerBlob1( pos ), 1. );

    res = smoothU( res , cb , .8 );



    //text

    float moon = sdSphere( og -  moonPos , 2.4 );
    res = opU( res , vec2( moon , 1000.));

    float text = sdBox( og - vec3( 0. , -1. , 0. ) , vec3( textRatio * .2 , .2 , .01 ));
    res = opU( res , vec2( text , 100.));

    return res;
    
}


$calcIntersection
$calcNormal
$calcAO




void main(){

  for( int i = 0; i < 5; i++ ){

    float l = float( i );

    vec3 p = vec3( sin( time * ( l + 1. ) * .1 + l ),  cos( time * ( 5. -  l )  * .02  + l ) , sin( .02 * time * ( 3. + l ) + l ) );

    p *= .8;

    bulbPos[i] = p;


  }

  vec3 fNorm = uvNormalMap( t_normal , vPos , vUv , vNorm , 10.6 , .4 );

  vec3 ro = vPos;
  vec3 rd = normalize( vPos - vCam );

  vec3 p = vec3( 0. );
  vec3 col =  vec3( 0. );

  float m = max(0.,dot( -rd , fNorm ));

  //col += fNorm * .5 + .5;

  vec3 refr = refract( rd , fNorm , 1. / 1. ) ;

  vec2 res = calcIntersection( ro , refr );

  if( res.y > -.5 ){

    p = ro + refr * res.x;
    vec3 n = calcNormal( p );

    //col += n * .5 + .5;



    col +=  texture2D( t_matcap , semLookup( refr , n , modelViewMatrix , normalMatrix ) ).xyz;

    col *= hsv( res.y * .1 , 1. , 1. );

    if( res.y == 100. ){

      vec2 lookup = p.xy;
      //lookup.x += .5;
      lookup.x /= textRatio;
      lookup.x /= .4;
      lookup.x += .5;
      lookup.y += 1.2;
      lookup.y *= 2.3;
      //lookup.y *= 1.4;

      col *= texture2D( t_text , lookup ).xyz;
      //col += vec3( 1.1 );
    }

    if( res.y == 1000. ){
      col = vec3( pow( 1. - dot( -n , rd ) , 4.) );
    }

    //col -= texture2D( t_audio , vec2(  abs( n.x ) , 0. ) ).xyz;

  }



  if( abs( vUv.x - .5)> .48 || abs( vUv.y - .5)> .48 ){
    col += vec3( .5 );

  }

  gl_FragColor = vec4( col , 1. );

}










