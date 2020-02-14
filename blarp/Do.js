G = {}

  var scene , camera , renderer, clock , controls, objectControls;

  var neededToLoad = 0;
  var numLoaded = 0;

  var iPoint;

  var loader = new THREE.TextureLoader();


  var shaders = new ShaderLoader( 'Mobile/shaders' );

  //shaders.load( 'ss-curlFront'    , 'sim'    , 'simulation' );

  addLoad();

  shaders.load( 'fs-trace'  , 'trace' , 'fragment' );
  shaders.load( 'vs-trace'  , 'trace' , 'vertex'   );


  //TODOOOOO
  shaders.load( 'fs-water'  , 'water' , 'fragment' );
  shaders.load( 'vs-water'  , 'water' , 'vertex'   );

  shaders.load( 'fs-island'  , 'island' , 'fragment' );
  shaders.load( 'vs-island'  , 'island' , 'vertex'   );

  shaders.shaderSetLoaded = function(){
    onLoad();
  }

  /*

  addLoad();
  var matcap = loader.load('img/rough-aluminium.jpg',function ( texture ) {
    onLoad();
  });

  addLoad();
  //var normal = THREE.ImageUtils.loadTexture('img/t_n_mesh.png');
  var normal = loader.load('img/n_water.jpg',function(){
    onLoad();
  });


   


  var manager = new THREE.LoadingManager();
 // var loader = new THREE.OBJLoader( manager );*/

addLoad();
onLoad();
  G.models = {}


  //normal.wrapT = normal.wrapS = THREE.RepeatWrapping;


  var activeLink = undefined;
  var hoveredLink = undefined;

  var finalSongVal = 0;

  var uniforms = {
   // t_audio:  { type:"t"  , value : null },
    dT:       { type:"f"  , value : 0             },
    time:     { type:"f"  , value : 0             },
   /* lightPos: { type:"v3" , value : null          },
    iModelMat:{ type:"m4" , value: new THREE.Matrix4() },
    t_matcap: { type:"t", value: matcap},
    t_normal: { type:"t", value: normal},
    t_text:   { type:"t", value: null },
    textRatio: {type:"f", value: 1 },

    light1 : {type:"v4",value:new THREE.Vector4()},
    light2 : {type:"v4",value:new THREE.Vector4()},
    light3 : {type:"v4",value:new THREE.Vector4()},

    dimensions: {type:"v3", value: new THREE.Vector3() },

    links: { type:"v4v" , value:[] },
    activeLink: { type:"v4" , value:new THREE.Vector4() },
    hoveredLink: { type:"v4" , value:new THREE.Vector4() },
    songVal:{type:"f",value:0},

    interfaceRadius: {type:"f", value:2 }*/
  }


  G.v1 = new THREE.Vector3();
  G.v2 = new THREE.Vector3();

  G.uniforms = uniforms;









  var v1 = new THREE.Vector3();
  
  function init(){

var body = document.body,
    html = document.documentElement;

docHeight = Math.max( body.scrollHeight, body.offsetHeight, 
                       html.clientHeight, html.scrollHeight, html.offsetHeight );



      /*textCreator =  new TextCreator( 100 );


      test = textCreator.createTexture( "test" , {
        size: .03
      });

      uniforms.t_text.value = test;*/

      /*
         Default threejs stuff!
      */
      scene = new THREE.Scene();

      var ar = window.innerWidth / window.innerHeight;

      camera = new THREE.PerspectiveCamera( 40, ar , .01, 40 );
      camera.position.z = 2;
      camera.position.y = 2;

      // Getting the container in the right location
    container = document.createElement( 'div' );
    container.id = "container";


    
    document.getElementById("three").appendChild( container );

 // Getting the stats in the right position
   /* stats = new Stats();

    stats.domElement.style.position  = 'absolute';
    stats.domElement.style.bottom    = '0px';
    stats.domElement.style.right     = '0px';
    stats.domElement.style.zIndex    = '999';

    document.body.appendChild( stats.domElement );*/

    // Setting up our Renderer
    renderer = new THREE.WebGLRenderer();

    var r = window.devicePixelRatio || 1;
    renderer.setPixelRatio(r);


    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.setClearColor( 0x000000, 1 );
    container.appendChild( renderer.domElement );


    console.log( document.getElementById("three"));
    
    document.getElementById("three").appendChild( container );

      window.addEventListener( 'resize', onWindowResize, false );

      clock = new THREE.Clock();




      var globeRad = .8;
      var globePos = new THREE.Vector3( 0.2 , 2.4 , .1);



  var sphere = new THREE.Mesh( new THREE.IcosahedronGeometry( globeRad , 2 ), new THREE.MeshBasicMaterial());
      sphere.position.copy(globePos);
      var params  = {
        material:               new THREE.MeshNormalMaterial(),
        radius:                 .2,
        height:                 2.5,
        sides:                  10,
        numOf:                  10, 
        randomness:             .3,
        slices:                 100,
        lightPosition:          new THREE.Vector3().copy( globePos ) ,
        lightSize:              globeRad,
        startingChance:          20.,
        chanceReducer:           .99,
        randomnessReducer:       .99,
        sliceReducer:            .4,
        numOfReducer:            .9,
        progressionPower:        2.2,
        lengthReduction:         .6,
        maxIterations:           3,
        flattening:              1.2,
        maxVerts:      100000
      }
      


      tree = new Tree( params );

      tree.position.x = 3.5;
      tree.position.z = -1;
      tree.position.y = -1;
      tree.scale.multiplyScalar( .6 );
      

      scene.add( tree );
      tree.add(sphere);



      light= globePos;


  }

  function animate(){

    requestAnimationFrame( animate );

   

    //console.log( document.body.scrollTop );
   
    var scrolledAmount = document.scrollingElement.scrollTop / ( docHeight- window.innerHeight);

  //  console.log( scrolledAmount );

    camera.position.x = Math.sin( scrolledAmount ) * 10;
    camera.position.z = -Math.cos( scrolledAmount ) * 10;
    
    camera.lookAt( tree.position.clone().add(new THREE.Vector3(0,1,0)));

  
  
    renderer.render( scene , camera );
  

  }



  function onWindowResize() {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );
   // grain.play();

  }

  function addLoad(){
    neededToLoad ++;
  }

  function onLoad(){
    numLoaded ++;
    console.log( numLoaded);
    console.log( neededToLoad);
    if( numLoaded == neededToLoad ){
      init();
      animate();
    }
  }
