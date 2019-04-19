function initThree(){


  floatingMotes = [];
  scene = new THREE.Scene();
  
  camera = new THREE.PerspectiveCamera( 
    50 ,
    window.innerWidth / window.innerHeight,
    sceneSize / 10 ,
    sceneSize * 1000
    );

  // placing our camera position so it can see everything
  //camera.position.y = 150;
  //camera.position.z = 1;
  //camera.position.x = 1;

  camera.lookAt( new THREE.Vector3() );

  objectControls = new ObjectControls(camera);


  var m = new THREE.Mesh(
    new THREE.IcosahedronGeometry( 300 , 1),
    new THREE.MeshBasicMaterial({map:G.uniforms.t_audio.value})
  );


  //scene.add( m);

  //controls = new THREE.TrackballControls(camera);

  clock = new THREE.Clock();
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
    renderer.setClearColor( 0xffffff, 1 );
    container.appendChild( renderer.domElement );

    // Making sure our renderer is always the right size
    window.addEventListener( 'resize', onWindowResize , false );




renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap; // default THREE.PCFShadowMap

//Create a PointLight and turn on shadows for the light
light2 = new THREE.PointLight( 0xffffff, 2, 1000 );
light2.position.set( 0, 0, 0 );
//light2.castShadow = true;            // default false
scene.add( light2 );

//Set up shadow properties for the light
light2.shadow.mapSize.width = 1024;  // default
light2.shadow.mapSize.height = 1024; // default
light2.shadow.camera.near = 1;       // default
light2.shadow.camera.far = 1000      // default




    var geo = new THREE.IcosahedronGeometry(10,1);
    var mat = new THREE.MeshNormalMaterial({color:0xffffff, flatShading:true});
    for( var i = 0; i < 1000; i++ ){
      var m = new THREE.Mesh(geo, mat);
      m.position.x = (Math.random() - .5)  * 2000;
      m.position.y = (Math.random() - .5)  * 1000;
      m.position.z = (Math.random() - .5)  * 1000;
      scene.add( m );
      m.castShadow = true;
      //m.receiveShadow = true;
      floatingMotes.push( m);
    }
   

var mat = new THREE.MeshNormalMaterial({color:0xffffff,side: THREE.BackSide});
    var m = new THREE.Mesh(geo, mat);
    m.scale.multiplyScalar(100);
    //m.receiveShadow =  true ;
    //m.castShadow = false;
      scene.add( m );


}

// Resets the renderer to be the proper size
function onWindowResize(){

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}



