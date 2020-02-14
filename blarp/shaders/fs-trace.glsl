#define SONGS 14

uniform float time;
uniform sampler2D t_audio;
uniform vec4 links[SONGS];
uniform vec4 activeLink;
uniform vec4 hoveredLink;

uniform sampler2D t_matcap;
uniform sampler2D t_normal;
uniform sampler2D t_text;
uniform float textRatio;
uniform float interfaceRadius;

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

uniform vec3 dimensions;

uniform float songVal;

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

const float MAX_TRACE_DISTANCE = 2.0;             // max trace distance
const float INTERSECTION_PRECISION = 0.1;        // precision of the intersection
const int NUM_OF_TRACE_STEPS = 10;
const float PI = 3.14159;

const vec3 moonPos = vec3( -3. , 3. , -3.);





float hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

float noise( vec3 x )
{
    // The noise function returns a value in the range -1.0f -> 1.0f

    vec3 p = floor(x);
    vec3 f = fract(x);

    f       = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;

    return mix(mix(mix( hash(n+0.0), hash(n+1.0),f.x),
                   mix( hash(n+57.0), hash(n+58.0),f.x),f.y),
                  mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                   mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*157.0;

    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+157.0), hash(n+158.0),f.x),f.y);
}


float opU( float d1, float d2 )
{
    return min(d1,d2);
}
vec2 opU( vec2 d1, vec2 d2 ){
    return  d1.x < d2.x ? d1 : d2 ;
}


float opS( float d1, float d2 ){
    return max(-d1,d2);
}
vec2 opS( vec2 d1, vec2 d2 ){
    return  -d1.x > d2.x  ? vec2(-d1.x , d1.y) : d2 ;
}


float smax(float a, float b, float k)
{
    return log(exp(k*a)+exp(k*b))/k;
}

float smin( float a, float b, float k ){
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

vec2 smin( vec2 a, vec2 b, float k ){
    float h = clamp( 0.5+0.5*(b.x-a.x)/k, 0.0, 1.0 );
    float val = mix( b.x, a.x, h ) - k*h*(1.0-h);
    return vec2(val - k*h*(1.0-h), mix(a.y, b.y, h));
}

vec2 smoothU( vec2 d1, vec2 d2, float k)
{
    float a = d1.x;
    float b = d2.x;
    float h = clamp(0.5+0.5*(b-a)/k, 0.0, 1.0);
    return vec2( mix(b, a, h) - k*h*(1.0-h), mix(d2.y, d1.y, pow(h, 2.0)));
}


vec2 smoothSub( vec2 d1, vec2 d2, float k)
{
    return  vec2( smax( -d1.x , d2.x , k ) , d2.y );
}



$sdCapsule
$sdBox
$sdSphere
$sdHexPrism




float centerBlob1( vec3 pos  ){

  //pos.x += .1 * sin( pos.x * 20. );
  //pos.y += .1 * sin( pos.y * 20. );
  //pos.z += .1 * sin( pos.z * 20. );

  float dis = length( texture2D( t_audio , vec2( mod(length( pos ) *1.,.5) , 0.) ) );

  float b = sdSphere( pos , .3 );
 
  return  b - dis * .1 * ((songVal / float(SONGS))*3.+1.);


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

    vec2 res = vec2( 1000000. , -1. );

 


    vec2 monolith = vec2(sdBox( pos , dimensions * .5 - .1) , 1.);//vec2( sdBox( vec3(0.) , vec3( .0001 ) ) , 10. );
    res = opU(res ,monolith);//smoothU( res , monolith , 10. );



    res.x += noise( pos + vec3(0. , time  * .1, 0.)) * .1;

    res.x += noise( pos  * 4.+ vec3(0. , time  * .2, 0.)) * .05;
    res.x += noise( pos  * 10.+ vec3(0. , time  * .06, 0.)) * .01;




    for( int i = 0; i < SONGS; i++ ){
      vec2 c = vec2( sdSphere( pos  - links[i].xyz , .01 ) , 1.);
     
      res = smoothSub(c,res , 30.1 ) ;
    }
    for( int i = 0; i < SONGS; i++ ){
      vec2 c = vec2( sdSphere( pos  - links[i].xyz , .01 ) , 1.);
      res = opU( res , c  );
    }


    vec2 dot = vec2( sdSphere( pos - vec3( 0. , .84 , 0.05 ) , .2  ) , 3.);
    res = opS( dot , res );
      

    vec2 cut = vec2( sdBox( pos -  vec3( 0. , 0., 0.2 ) , dimensions  * .2 + vec3( 0. , .55 , 0.1 )  ) , 3.);
    res = opS( cut , res );

   


    vec2 caps;

    if( hoveredLink.w > .1 ){
      caps = vec2( sdSphere( pos  - hoveredLink.xyz , .001 ) , 2. );
      //caps = vec2( sdCapsule( pos , hoveredLink.xyz ,  hoveredLink.xyz * .8 , .03 ) , 30. );
      res = smoothU( res , caps , .1 ) ;
    }



    // interface tracing
    if( activeLink.w > .1 ){
      caps = vec2( sdCapsule( pos , activeLink.xyz ,  vec3( 0. ) , .01) , 60. );
      //res = smoothU( res , caps , .3 ) ;
    }


 
    vec2 cb = vec2( centerBlob1( pos ), 1. );

    //res = smoothU( res , cb , 1. + (songVal / float(SONGS))  );



    //text

    float moon = sdSphere( og -  moonPos , 2.4 );
   // res = opU( res , vec2( moon , 1000.));

    float text = sdBox( og - vec3( 0. , -1 , 1.2 ) , vec3( textRatio * .2 , .2 , .01 ));
    //res = opU( res , vec2( text , 100.));


    if( pos.z < 1. ){
      float modA = 1.-(songVal / float(SONGS));
      vec3 newPos = mod( pos , vec3( modA));
      vec3 difxyz = pos.xyz - activeLink.xyz;
      float bg = sdSphere( newPos - vec3( modA * .5 ) ,modA*.5 * .4 / length(difxyz) );
      //res = opU( res , vec2(bg, 10. / length( difxyz)) );
    }





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

  vec3 fNorm = uvNormalMap( t_normal , vPos , vUv , vNorm , 10.6 , .5 * songVal / float(SONGS)  );

  vec3 ro = vPos;
  vec3 rd = normalize( vPos - vCam );

  vec3 p = vec3( 0. );
  vec3 col =  vec3( 0. );

  float m = max(0.,dot( -rd , fNorm ));

  //col += fNorm * .5 + .5;

  vec3 refr = rd;// refract( rd , fNorm , 1. ) ;

  vec2 res = calcIntersection( ro , refr );

  if( res.y > -.5 ){

    p = ro + refr * res.x;
    vec3 n = calcNormal( p );

    //col += n * .5 + .5;


    vec3 mat = texture2D( t_matcap , semLookup( refr , n , modelViewMatrix , normalMatrix ) ).xyz;


    col += mat;
    col *= hsv( res.y * .1 , .3 + (songVal / float(SONGS)) * .7 , 1. );

    if( res.y == 100. ){

      vec2 lookup = p.xy;
      //lookup.x += .5;
      lookup.x /= textRatio;
      lookup.x /= .4;
      lookup.x += .5;
      lookup.y += 1.2;
      lookup.y *= 2.3;
      //lookup.y *= 1.4;

      vec3 tVal = texture2D( t_text , lookup ).xyz;
      col = hsv(length(tVal) * .4 + time ,.5,1.) * tVal;
      //col += vec3( 1.1 );
    }

    if( res.y == 1000. ){
      col = vec3( pow( 1. - dot( -n , rd ) , 4.) );
    }

    if( res.y > 100. ){
      col = vec3(1.,1.,1.) * mat;// normalize(mat);
    }

    vec3 aCol =texture2D( t_audio , vec2( dot( -n , rd ) , 0.) ).xyz;

    col *= aCol;

    //col = n * .5 + .5;
    //col = vec3( 1. , 0., 1.);
    //col -= texture2D( t_audio , vec2(  abs( n.x ) , 0. ) ).xyz;

  }else{
    discard;
  }



  if( abs( vUv.x - .5)> .48 || abs( vUv.y - .5)> .48 ){
   // col += vec3( .5 );

  }

  gl_FragColor = vec4( col , 1. );

}










