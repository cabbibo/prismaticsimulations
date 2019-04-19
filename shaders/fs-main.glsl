
uniform float time;

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

varying vec3 vPos;
varying vec3 vCam;
varying vec3 vNorm;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;


$uvNormalMap
$semLookup
$hsv


// Branch Code stolen from : https://www.shadertoy.com/view/ltlSRl
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

const float MAX_TRACE_DISTANCE = 50.0;             // max trace distance
const float INTERSECTION_PRECISION = 0.01;        // precision of the intersection
const int NUM_OF_TRACE_STEPS = 25;
const float PI = 3.14159;



$smoothU
$sdCapsule

float sdTriPrism( vec3 p, vec2 h )
{
    vec3 q = abs(p);
    return max(q.z-h.y,max(q.x*0.866025+p.y*0.5,-p.y)-h.x*0.5);
}




// ROTATION FUNCTIONS TAKEN FROM
//https://www.shadertoy.com/view/XsSSzG
mat3 xrotate(float t) {
    return mat3(1.0, 0.0, 0.0,
                0.0, cos(t), -sin(t),
                0.0, sin(t), cos(t));
}

mat3 yrotate(float t) {
    return mat3(cos(t), 0.0, -sin(t),
                0.0, 1.0, 0.0,
                sin(t), 0.0, cos(t));
}

mat3 zrotate(float t) {
    return mat3(cos(t), -sin(t), 0.0,
                sin(t), cos(t), 0.0,
                0.0, 0.0, 1.0);
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float opS( float d1, float d2 )
{
    return max(-d1,d2);
}

$opU
//--------------------------------
// Modelling 
//--------------------------------
vec2 map( vec3 pos ){  

    vec2 res = vec2( 1000000. , 0. );

    mat3 xR = zrotate( time );
    mat3 yR = xrotate( .5* PI );
    vec3 rP = xR*yR*pos;
    vec2 centerBlob = vec2( sdTriPrism(rP,vec2(2.,3.)), 1. );

    float p;
    p = sdPlane( rP , vec4(normalize(vec3(.3,1.,3.)), 2.));
    centerBlob.x = opS( p , centerBlob.x );

    p = sdPlane( rP , vec4(normalize(vec3(-3.,1.,.4)), 2.));
    centerBlob.x = opS( p , centerBlob.x );

    p = sdPlane( rP , vec4(normalize(vec3(4.,1.,3.)), 2.));
    centerBlob.x = opS( p , centerBlob.x );

      p = sdPlane( rP , vec4(normalize(vec3(2.,-4.,3.)), 2.));
    centerBlob.x = opS( p , centerBlob.x );


    p = sdPlane( rP , vec4(normalize(vec3(2.,-4.,-1.)), 1.));
    centerBlob.x = opS( p , centerBlob.x );

        p = sdPlane( rP , vec4(normalize(vec3(-2.,-4.,-1.)), 2.));
    centerBlob.x = opS( p , centerBlob.x );

        p = sdPlane( rP , vec4(normalize(vec3(-2.,4.,-1.)), 2.));
    centerBlob.x = opS( p , centerBlob.x );


    /*mat3 rX = xrotate( .3 * PI );


    centerBlob = opU( vec2(sdTriPrism(rX * (rP-vec3(1.,1.,1.)) , vec2(.3 , 3.)),.2) , centerBlob );
    centerBlob = opU( vec2(sdTriPrism(rX * (rP-vec3(2.,1.,1.)) , vec2(.3 , 3.)),.2) , centerBlob );
    centerBlob = opU( vec2(sdTriPrism(rX * (rP-vec3(3.,1.,1.)) , vec2(.3 , 3.)),.2) , centerBlob );
*/

    res = opU( res , centerBlob  );

    return res;
    
}


$calcIntersection
$calcNormal
$calcAO
$triNoise3D
$simplex



float getCol( vec3 p , vec3 r){
    return triNoise3D((p + r * (5.+4.*triNoise3D(p * .1,2.,time)))  * .1, 1.,time);//normalize(refract) * .5 + .5;// n * .5 + .5;

}
void main(){

  vec3 fNorm = vNorm;// uvNormalMap( t_normal , vPos , vUv , vNorm , .6 , -.1 );

  vec3 ro = vMPos;
  vec3 rd = normalize(vMPos - cameraPosition);//normalize( vPos - vCam );
  //vec3 rd = normalize( vPos - vCam );

  vec3 p = vec3( 0. );
  vec3 col =  vec3( 0. );

 // float m = max(0.,dot( -rd , fNorm ));

  //col += fNorm * .5 + .5;

  vec3 refr = refract( rd , fNorm , 1. / 1.) ;

  vec2 res = calcIntersection( ro , rd );

  if( res.y > -.5 ){

    p = ro + refr * res.x;
    vec3 n = calcNormal( p );
    vec3 r1 = refract( rd , n , .9 );
    vec3 r2 = refract( rd , n , .85 );
    vec3 r3 = refract( rd , n , .8 );


    //float c = getCol( p,r1);
    col = 3.* vec3(getCol(p,r1),getCol(p,r2),getCol(p,r3));

  }


  if( abs( vUv.x - .5)> .48 || abs( vUv.y - .5)> .48 ){
    col += vec3( .5 );

  }

  gl_FragColor = vec4( col , 1. );

}