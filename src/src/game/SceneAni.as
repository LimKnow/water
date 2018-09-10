package src.game
{
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	public class SceneAni extends Sprite
	{
		private var ani:Sprite;
		private var lvTxt:Text;
		private var ggTxt:Text;
		private var spCt:Sprite;
		private var isCom:Boolean;
		
		public function SceneAni()
		{
			super();
			this.mouseEnabled = true;
			this.size(Global.Ins().showW,Global.Ins().showH);
			ani = new Sprite();
			addChild(ani);
			ani.visible = false;
			ani.graphics.drawRect(0,0,Global.Ins().showW,1,"#000000");
			
			spCt = new Sprite();
			addChild(spCt);
			spCt.y = -50;
			spCt.visible = false;
			
			ggTxt = new Text();
			ggTxt.color = '#FF0000';
			ggTxt.fontSize = 30;
			ggTxt.stroke = 2;
			ggTxt.strokeColor = '#FFFFFF';
			ggTxt.bold = true;
			ggTxt.text = "真棒！继续挑战吧";
			spCt.addChild(ggTxt);
			ggTxt.pos((Global.Ins().showW - ggTxt.width) >> 1, 40);
			
			lvTxt = new Text();
			lvTxt.color = '#FF0000';
			lvTxt.fontSize = 30;
			lvTxt.stroke = 2;
			lvTxt.strokeColor = '#FFFFFF';
			lvTxt.bold = true;
			lvTxt.text = "";
			spCt.addChild(lvTxt);
			
			this.on(Event.CLICK,this,enterNext);
		}
		
		public function showSceneAni():void
		{
			isCom = false
			ani.visible = true;
			lvTxt.text = "LV." + Global.Ins().curLevel;
			Laya.timer.loop(20,this,addHandler);
		}
		
		private function addHandler():void
		{
			ani.graphics.clear();
			ani.height += 5;
			var num:Number = ani.height > Global.Ins().showH ? Global.Ins().showH : ani.height;
			ani.graphics.drawRect(0,0,Global.Ins().showW,num,"#000000");
			ani.alpha = 0.5;
			if(ani.height >= Global.Ins().showH + 20)
			{
				lvTxt.pos((Global.Ins().showW - lvTxt.width) >> 1, 0);
				spCt.visible = true;
				Laya.timer.clear(this,addHandler);
				Tween.to(spCt,{y:Global.Ins().showH >> 1},700,Ease.backOut,Handler.create(this,lvTxtCom));
			}
		}
		
		private function lvTxtCom():void
		{
			isCom = true
		}
		
		private function enterNext():void
		{
			if(isCom)
			{
				hideAni();
				
				event("ENTER_NEXT_PASS");
			}
		}
		
		private function hideAni():void
		{
			spCt.visible = false;
			spCt.y = -50;
			ani.visible = false;
			ani.height = 1;
			ani.graphics.clear();
		}
	}
}