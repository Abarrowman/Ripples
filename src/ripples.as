var video:Video=new Video();
var camera:Camera=Camera.getCamera();
video.attachCamera(camera);
addChild(video);

var loader:URLLoader = new URLLoader();
loader.dataFormat=URLLoaderDataFormat.BINARY;
loader.addEventListener(Event.COMPLETE, onLoadComplete);
loader.load(new URLRequest("wave.pbj"));
var shader:Shader;
var stag:Number=1;
var waves:Vector.<Shader>=new Vector.<Shader>();

function onLoadComplete(event:Event):void {
	this.addEventListener(Event.ENTER_FRAME, refilter);
	stage.addEventListener(MouseEvent.CLICK, addWave);
	
}

function refilter(event:Event):void{
	var filtes:Array=[];
	for(var n:int=waves.length-1;n>=0;n--){
		var wave:Shader=waves[n];
		wave.data.wave_size.value=[wave.data.wave_size.value-0.1];
		wave.data.max_dis.value=[parseFloat(wave.data.max_dis.value)+5*wave.data.wave_size.value/10];
		wave.data.wave_stage.value=[parseFloat(wave.data.wave_stage.value)-wave.data.wave_size.value/10/2];
		if(wave.data.wave_stage.value<=0){
			wave.data.wave_stage.value=[1];
		}
		if(wave.data.wave_size.value<1){
			waves.splice(n, 1);
		}else{
			filtes.push(new ShaderFilter(wave));
		}
	}
	video.filters=filtes;
}

function addWave(event:MouseEvent):void{
	addWaves(event.stageX, event.stageY);
}

function addWaves(ex, ey):void{
	var wave:Shader=new Shader()
	wave.byteCode=loader.data;
	wave.data.wave_size.value=[10];
	wave.data.wave_y.value=[ey];
	wave.data.wave_x.value=[ex];
	wave.data.wave_stage.value=[1];
	wave.data.max_dis.value=[0];
	waves.push(wave);
}