  //function c(val){console.log(val);}
  var container , camera, scene, renderer , stats;
  var clock;


// tmp vecs to reuse
v1 = new THREE.Vector3();
v2 = new THREE.Vector3();

raycaster = new THREE.Raycaster();
mouse = new THREE.Vector2();

  var G = {}
  G.uniforms = {
    time : { type:"f" , value:0 },
    scroll : { type:"f" , value:0 },
    dT : { type:"f" , value:0 },
    t_audio : { type:"t" , value:null },
    dpr:{ type:"f" , value: window.devicePixelRatio || 1 }
  }


  var mouse =  new THREE.Vector2();

  var loader = new Loader({ numberToLoad: 0 });

  var LOOPS = {}
  var POLYS = {}

  //loader.beginLoading();
  var shaders = new ShaderLoader('BG/shaders');
 
  shaders.beginLoad = function(){
    loader.beginLoading();
  }

  shaders.endLoad = function(){
    loader.endLoading();
  }

  shaders.shaderSetLoaded = function(){
    //init();

  }




  
  sceneSize = 10;

  shaders.load( 'ss-furryTail'   , 'furryTail' , 'simulation'  );
  shaders.load( 'fs-furryTail'   , 'furryTail' , 'fragment'  );
  shaders.load( 'vs-furryTail'   , 'furryTail' , 'vertex'  );


  shaders.load( 'ss-mainTail'   , 'mainTail' , 'simulation'  );
  shaders.load( 'fs-mainTail'   , 'mainTail' , 'fragment'  );
  shaders.load( 'vs-mainTail'   , 'mainTail' , 'vertex'  );

  shaders.load( 'ss-furryHead'   , 'furryHead' , 'simulation'  );
  shaders.load( 'fs-furryHead'   , 'furryHead' , 'fragment'  );
  shaders.load( 'vs-furryHead'   , 'furryHead' , 'vertex'  );

  shaders.load( 'fs-furryParticles'   , 'furryParticles' , 'fragment'  );
  shaders.load( 'vs-furryParticles'   , 'furryParticles' , 'vertex'  );



  shaders.load( 'vs-poly'   , 'poly' , 'vertex'  );
  shaders.load( 'fs-poly'   , 'poly' , 'fragment'  );

  shaders.load( 'vs-polyOutline'   , 'polyOutline' , 'vertex'  );
  shaders.load( 'fs-polyOutline'   , 'polyOutline' , 'fragment'  );

  shaders.load( 'vs-polyOrg'   , 'polyOrg' , 'vertex'  );
  shaders.load( 'fs-polyOrg'   , 'polyOrg' , 'fragment'  );
 


  var audioController = new AudioController();

//  audioController.mute.gain.value = 0;

  G.uniforms.t_audio.value = audioController.texture;
  G.uniforms.t_sem = { type:"t",value:THREE.ImageUtils.loadTexture( 'BG/sem_metal.jpg')}//.sem = audioController.texture;


/*
   
  var loopList = [
    "BassKick",
    "BassMod",
    "BellA",
    "BellB",
    "BellBright",
    "BellC",
    "Clap",
    "Hats",
    "Hiup",
    "IMP",
    "Kick",
    "Logrit",
    "Lopan",
    "ModA",
    "ModB",
    "RNL",
    "Roll",
    "Snare",
    "Upmid",
    "Voc"
  ];

  for( var i = 0; i < loopList.length; i++ ){
    loader.beginLoading();
    var newName = "Maru" + loopList[i] + "Loop.mp3";
    var note = new LoadedAudio( audioController , newName , {
      looping:true 
    });

    LOOPS[loopList[i]] = note;
  //   audioController.notes.push( note );
     
    note.onLoad = function(){
      this.endLoading();
    }.bind( loader );

  }


  var looper          = new Looper( audioController , G.uniforms.time , {

    beatsPerMinute: 120,
    beatsPerMeasure: 4,
    measuresPerLoop: 8
    
  });*/


 // var particleTexture = THREE.ImageUtils.loadTexture( 'icons/cabbibo.png');
  var semTexture = THREE.ImageUtils.loadTexture( 'icons/cabbibo.png');




    bait = new THREE.Object3D();



 // initAudio();

  function init(){

var body = document.body,
    html = document.documentElement;

docHeight = Math.max( body.scrollHeight, body.offsetHeight, 
                       html.clientHeight, html.scrollHeight, html.offsetHeight );





    initThree();
    initJelly();
    initPoly();

    mouseRep = new THREE.Mesh( new THREE.BoxGeometry(1,1,1), new THREE.MeshNormalMaterial());
    scene.add( mouseRep );


    camera.position.x = 0;
    camera.position.y = 0;
    camera.position.z = 500;
    camera.rotation.x = 0;
    camera.rotation.y = 0;
    camera.rotation.z = 0;
    Jelly.init();


    window.addEventListener('mousemove', mousemove, false);


    animate();

    //audioController.mute.gain.value = 0;

  }


  var mouseLastMove = 0;
  var canSearch = false;


  function mousemove( e ){

    canSearch = true;
    mouseLastMove = G.uniforms.time.value;
    mouse.x =   ( event.clientX / window.innerWidth ) * 2 - 1;
    mouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1;   


  }

function clamp(num , min, max) {
  return Math.min(Math.max(num, min), max);
};

  function animate(){

    //TWEEN.update();

    G.uniforms.scroll.value = document.scrollingElement.scrollTop / ( docHeight- window.innerHeight);


    camera.position.z = 400 * (1-G.uniforms.scroll.value) + 600;

    audioController.update();
    objectControls.update();

    raycaster.setFromCamera( mouse , camera );

    mouseRep.position.copy(camera.position);
    mouseRep.position.add( raycaster.ray.direction.clone().multiplyScalar(camera.position.z));
  

    light2.position.copy( camera.position );
    light2.position.copy( raycaster.ray.direction.clone().multiplyScalar(camera.position.z * .3) );

    //console.log(Jelly.headMesh.position.clone().sub( Jelly.bait.position ).length())

    if( Jelly.headMesh.position.clone().sub( Jelly.bait.position ).length() <50){
      canSearch = false;
      mouseLastMove = G.uniforms.time.value;
    }

        var t = G.uniforms.time.value;
    var move = t - mouseLastMove;

    //console.log( move);

    var baitBase = new THREE.Vector3()
    baitBase.x = Math.sin(t * 2* .131) * window.innerWidth * .3;
    baitBase.y = Math.sin(t * 2*.2442) * window.innerHeight* .3;
     baitBase.z = 200 + Math.sin(t * .3127) * 300 ;


     //console.log(clamp( move , 0, 1) );
     //console.log( mouseRep.position );
     //console.log( canSearch)
     var finalPos = new THREE.Vector3().copy(Jelly.bait.position);
     if( canSearch ){
       finalPos.lerp( mouseRep.position , 1 );
     }else{
      finalPos.lerp( baitBase, 1 );
     }

     //console.log( finalPos );
//mouseRep.position.clone().sub(bait.position).multiplyScalar
    Jelly.bait.position.copy( finalPos );

    //controls.update();

   /* for(var i = 0; i < loopList.length; i++ ){
      POLYS[loopList[i]].update();
    }*/
     
    var delta = clock.getDelta();


    G.uniforms.dT.value = delta;
    G.uniforms.time.value += delta;
    ///stats.update();
    for( var i = 0; i < floatingMotes.length; i++ ){
      floatingMotes[i].rotation.x += Math.sin(i) * .01;
      floatingMotes[i].rotation.y += Math.sin(i*10) * .01;
      floatingMotes[i].rotation.z += Math.sin(i*20) * .01;

      floatingMotes[i].position.x += Math.sin(i+G.uniforms.time.value) * .1;
      floatingMotes[i].position.y += Math.sin(i*10+G.uniforms.time.value) * .1;
      floatingMotes[i].position.z += Math.sin(i*20+G.uniforms.time.value) * .1;

    }

    Jelly.update();
    renderer.render( scene , camera );


    requestAnimationFrame( animate );


    


  }

  $("#startInfo").click( function(){

    loader.liftCurtain();
    //looper.start();
    animate();




   /* for( var i = 0; i < loopList.length;i++){
      POLYS[loopList[i]].play();
     // POLYS[loopList[i]].activate();
    }*/
   
  
  });
