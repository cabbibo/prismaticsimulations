  function c(val){console.log(val);}
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


  var particleTexture = THREE.ImageUtils.loadTexture( 'icons/cabbibo.png');




    bait = new THREE.Object3D();



 // initAudio();

  function init(){



    initThree();
    initJelly();
    initPoly();

    mouseRep = new THREE.Mesh( new THREE.BoxGeometry(1,1,1), new THREE.MeshNormalMaterial());
    scene.add( mouseRep );


    camera.position.x = 0;
    camera.position.y = 0;
    camera.position.z = 1000;
    camera.rotation.x = 0;
    camera.rotation.y = 0;
    camera.rotation.z = 0;
    Jelly.init();


window.addEventListener('mousemove', mousemove, false);



animate();

    //audioController.mute.gain.value = 0;

  }

  function mousemove( e ){

    mouse.x =   ( event.clientX / window.innerWidth ) * 2 - 1;
    mouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1;   


  }

  function animate(){

    TWEEN.update();

    audioController.update();
    objectControls.update();

     raycaster.setFromCamera( mouse , camera );

    mouseRep.position.copy(camera.position);
    mouseRep.position.add( raycaster.ray.direction.clone().multiplyScalar(1000));
    Jelly.bait.position.copy( mouseRep.position );

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
