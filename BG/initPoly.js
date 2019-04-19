
DLD = false;
function initPoly(){

 /* for( var i = 0; i < loopList.length; i++ ){

    POLYS[loopList[i]] = new Poly( i, LOOPS[loopList[i]] );

    console.log(POLYS[loopList[i]]);

  }*/

  
}

function Poly( id , note ){

  this.note = note;
  this.note.gain.gain.value = 0;
  this.id = id;

  this.active = false;


  this.mesh = new THREE.Mesh(
    new THREE.IcosahedronGeometry( 40.1 , 2 ),
      new THREE.ShaderMaterial({
      uniforms:{
        t_audio:{type:"t",value:this.note.texture},
        time:G.uniforms.time,
        jelly:{type:"v3",value:headMesh.position},
        active:{type:"f",value:1}
      },
      vertexShader: shaders.vs.poly,
      fragmentShader: shaders.fs.poly,
      flatShading:true
    })
  );

  this.bgMesh = new THREE.Mesh(
    new THREE.IcosahedronGeometry( 40.1 , 2 ),
      new THREE.ShaderMaterial({
      uniforms:{
        t_audio:{type:"t",value:this.note.texture},
        time:G.uniforms.time,
        jelly:{type:"v3",value:headMesh.position}
      },
      vertexShader: shaders.vs.polyOutline,
      fragmentShader: shaders.fs.polyOutline,
      flatShading:true
    })
  );

  this.organicMesh = new THREE.Mesh(
    new THREE.IcosahedronGeometry( 40.1 , 5 ),
      new THREE.ShaderMaterial({
      uniforms:{
        t_audio:{type:"t",value:this.note.texture},
        time:G.uniforms.time,
        jelly:{type:"v3",value:headMesh.position},
        active:{type:"f",value:1}
      },
      vertexShader: shaders.vs.polyOrg,
      fragmentShader: shaders.fs.polyOrg,
      flatShading:true
    }));


  this.mesh.add(this.bgMesh);




  this.mesh.position.y = 1.3*((((id % 4)+.5)/4)-.5) * window.innerHeight;
  this.mesh.position.x = 1.3*(((Math.floor(id /4)+.5)/5)-.5) * window.innerWidth;
  this.mesh.position.z = 0;//(Math.random()-.5) * 100;


  this.organicMesh.position.copy( this.mesh.position );
  this.mesh.material.map = this.note.texture;

  this.mesh.hoverOver = function(){
    this.hoverOver();
  }.bind( this );

  this.mesh.hoverOut = function(){
    this.hoverOut();
  }.bind( this );

  this.mesh.select = function(){
    this.select();
  }.bind( this );

  this.mesh.deselect = function(){
    this.deselect();
  }.bind( this );

  objectControls.add( this.mesh );

  this.deactivate

}

Poly.prototype = {

  update:function(){

    //this.bgMesh.position.copy( this.mesh.position );
    this.mesh.rotation.x += .01 * Math.sin(this.id * 10);
    this.mesh.rotation.y += .01 * Math.sin(this.id * 10+20);
    this.mesh.rotation.z += .01 * Math.sin(this.id * 10+40);


   
  //this.mesh.add(this.bgMesh);
  },


  play:function(){
    this.note.play();
    scene.add( this.mesh );
  },

  activate:function(){
    this.active = true;
    //this.mesh.material.uniforms.active.value = 1;
    this.organicMesh.material.uniforms.active.value = 1;
 
    scene.remove( this.mesh );
    scene.add( this.organicMesh );

    this.note.gain.gain.value = 1;

    var canDL = true;
    for( var i = 0; i < loopList.length; i++ ){
      if( POLYS[loopList[i]].active == false ){ canDL = false; }
    }


    if( canDL && DLD == false ){
      var url="MaruLoops.zip";
      //window.open(url);


      var zip_file_path = url; //put inside "" your path with file.zip
      var zip_file_name = "Maru Loops" //put inside "" file name or something
      var a = document.createElement("a");
      document.body.appendChild(a);
      a.style = "display: none";
      a.href = zip_file_path;
      a.download = zip_file_name;
      a.click();
      document.body.removeChild(a);
      DLD = true;

    }
  },

  deactivate: function(){
    this.active = false;

    this.mesh.material.uniforms.active.value = 1;
    this.organicMesh.material.uniforms.active.value = 1;
    this.note.gain.gain.value = 0;
    scene.add( this.mesh );
    scene.remove( this.organicMesh );
  },


  hoverOver: function(){
    
    if( this.active == false ){
      this.mesh.scale.x = 1.1;
      this.mesh.scale.y = 1.1;
      this.mesh.scale.z = 1.1;

      this.organicMesh.scale.x = 1.1;
      this.organicMesh.scale.y = 1.1;
      this.organicMesh.scale.z = 1.1;
    }

    console.log( this);
  },


  hoverOut: function(){

    if( this.active == false ){
      this.mesh.scale.x = 1;
      this.mesh.scale.y = 1;
      this.mesh.scale.z = 1;

      this.organicMesh.scale.x = 1;
      this.organicMesh.scale.y = 1;
      this.organicMesh.scale.z = 1;
    }


    console.log( this);
  },

  select:function(){

  if( this.active == false ){
    this.mesh.scale.x = 1.5;
    this.mesh.scale.y = 1.5;
    this.mesh.scale.z = 1.5;

    this.organicMesh.scale.x = 1.5;
    this.organicMesh.scale.y = 1.5;
    this.organicMesh.scale.z = 1.5;
    this.activate();

    Jelly.updateBaitPos( this.mesh.position );
    Jelly.bait.searching = this;

  }else{
    this.mesh.scale.x = 1;
    this.mesh.scale.y = 1;
    this.mesh.scale.z = 1;


    this.organicMesh.scale.x = 1.5;
    this.organicMesh.scale.y = 1.5;
    this.organicMesh.scale.z = 1.5;
    this.deactivate();
  }
  },

  deselect:function(){


  }



}



