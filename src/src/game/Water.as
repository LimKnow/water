package src.game
{
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	public class Water extends Sprite
	{
		private var numTxt:Text;
		private var aniAry:Array;
		private var iwidth:int;
		private var iheight:int;
		public function Water()
		{
			super();
			
			iwidth = Global.Ins().iwidth;
			iheight = Global.Ins().iheight
			
			numTxt = new Text();
			numTxt.mouseEnabled = true;
			numTxt.width = iwidth;
			numTxt.height = iheight;
			numTxt.align = "center";
			numTxt.valign = "middle";
			numTxt.color = "#ff0000";
			numTxt.fontSize = 22;
			addChild(numTxt);
			aniAry = []
			for (var i:int = 0; i < 4; i++) 
			{
				var aniSp:Sprite = new Sprite();
				aniSp.graphics.drawCircle(0,0,5,"#ff0000");
				aniSp.pos((iwidth + 2.5)/2, (iheight + 2.5)/2);
				aniSp.visible = false;
				addChild(aniSp);
				aniAry.push(aniSp);
			}
		}
		
		public function setData(num:int):void
		{
			if(num == 0)
				numTxt.text = "";
			else
				numTxt.text = num.toString();
		}
		
		public function playOneAni(dir:String):void
		{
			var ty:Number = (iheight + 2.5)/2;
			var tx:Number = (iwidth + 2.5)/2;
			var target:Sprite;
			if(dir == "up")
			{
				ty = ty - iheight;
				target = aniAry[0];
			}
			else if(dir == "down")
			{
				ty = ty + iheight;
				target = aniAry[1];
			}
			else if(dir == "left")
			{
				tx = tx - iwidth;
				target = aniAry[2];
			}
			else if(dir == "right")
			{
				tx = tx + iwidth;
				target = aniAry[3];
			}
			target.visible = true;
			Tween.to(target,{x:tx, y:ty}, 300, null, Handler.create(this,tcwHandler,[target],false));
		}
		
		private function tcwHandler(target:Sprite):void
		{
			target.visible = false;
			target.pos((iwidth + 2.5)/2, (iheight + 2.5)/2);
			event("TWC_COMPLETE")
		}
	}
}