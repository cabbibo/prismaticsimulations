
  uniform vec3 lightPos;
  uniform sampler2D t_pos;
  uniform float time;

  varying vec3 vView;
  varying vec3 vNormal;
  varying vec2 vUv;
  varying vec3 vColor;
  varying vec3 vWorld;

  varying mat3 vNormalMat;
  varying vec3 vLightDir;

  const float size = 1. / 32.;
  const float hSize = size / 2.;


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

    
  void main(void)
  {


    vec3 pos = texture2D( t_pos , position.xy ).xyz;

    vUv = position.xy;
    
    vec2 uvL = vUv;
    uvL.x -= size;
    if( uvL.x < 0. ){
        uvL.x = 1. - hSize;
    }
    vec4 posL = texture2D( t_pos , uvL ); 

    vec2 uvR = vUv;
    uvR.x += size;

    if( uvR.x > 1. ){
        uvR.x = 0. + hSize;
    }
    vec4 posR = texture2D( t_pos , uvR ); 
     
    
    vec2 uvU = vUv;
    uvU.y -= size;
    if( uvU.y < 0. ){
        uvU.y = vUv.y;
    }
    vec4 posU = texture2D( t_pos , uvU ); 

    vec2 uvD = vUv;
    uvD.y += size;

    if( uvD.y > 1. ){
        uvD.y = vUv.y;
    }
    vec4 posD = texture2D( t_pos , uvD ); 


    vec3 difX = posL.xyz - posR.xyz;
    vec3 difY = posD.xyz - posU.xyz;

    vec3 normal = normalize( cross( difX , difY ) );

    vColor = spectral((sin(vUv.y * 2. * 3.14159 - time * .5) + 1.)/2. );
    

    gl_Position = projectionMatrix * modelViewMatrix * vec4( pos , 1.0 );
    
    vView = modelViewMatrix[3].xyz;
    vNormal = normalMatrix *  normal ;
    vNormalMat = normalMatrix;

    vWorld = pos;

    vec3 lightDir = normalize( lightPos -  (modelViewMatrix * vec4( pos , 1.0 )).xyz );

    vLightDir = lightDir;
    
  }
