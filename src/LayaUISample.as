package {
	import laya.wx.mini.MiniAdpter;
	
	import src.game.GameView;
	import src.game.Global;
	
	public class LayaUISample {
		
		private var gmv:GameView;
		public function LayaUISample() {
			//初始化微信小游戏
			MiniAdpter.init();
			//初始化引擎
			Laya.init(Global.Ins().sceneW, Global.Ins().sceneH);
			//激活资源版本控制
//            ResourceVersion.enable("version.json", Handler.create(this, beginLoad), ResourceVersion.FILENAME_VERSION);
			Laya.stage.bgColor = "#f6cecd";
			_initGame();
		}
		
		private function _initGame():void
		{
			gmv = new GameView();
			Laya.stage.addChild(gmv);
		}
		
//		private function beginLoad():void {
//			//加载引擎需要的资源
//			Laya.loader.load("res/atlas/comp.atlas", Handler.create(this, onLoaded));
//		}
//		
//		private function onLoaded():void {
//			//实例UI界面
//			var testView:TestView = new TestView();
//			Laya.stage.addChild(testView);
//		}
	}
}