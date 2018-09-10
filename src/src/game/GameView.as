package src.game
{
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.events.Keyboard;
	import laya.maths.Point;
	
	public class GameView extends Sprite
	{
		private var gmp:GameMap;
		private var glb:Global;
		private var scneAni:SceneAni;
		
		private var startPo:Point;
		private var txtAry:Array = [];
		private var mapAry:Array;
		private var waterNum:int;
		private var level:int;
		private var isPlay:Boolean;
		private var curPoint:int;
		private var curScore:int;
		
		private var waterTxt:Text;
		private var levelTxt:Text;
		public function GameView()
		{
			super();
			glb = Global.Ins();
			startPo = new Point((glb.sceneW - glb.showW) >> 1, (glb.sceneH - glb.showH) >> 1);
			_initGame();
		}
		
		private function _initGame():void
		{
			isPlay = false;
			waterNum = glb.curWater;
			level = glb.curLevel;
			//等级积分
			initDataTxt();
			//地图
			resetMap();
			//绘制网格
			drawLines();
			//构建格子
			drawCell();
			mapAry = glb.mapAry;
			
			Laya.stage.on(Event.KEY_DOWN,this,keyDown);
		}
		
		private function keyDown(e:Event):void
		{
			if(e.keyCode == Keyboard.SPACE)
			{
				if(!scneAni)
				{
					scneAni = new SceneAni();
					scneAni.pos(startPo.x,startPo.y);
				}
				addChild(scneAni);
				scneAni.showSceneAni();
			}
		}
		
		private function drawCell():void
		{
			for (var i:int = 0; i < glb.row; i++) 
			{
				if(!txtAry[i])
					txtAry[i] = [];
				for (var j:int = 0; j < glb.col; j++) 
				{
					if(!txtAry[i][j])
					{
						var cell:Water = new Water();
						txtAry[i][j] = cell;
					}
					else
						cell = txtAry[i][j];
					cell.setData(glb.mapAry[i][j]);
					cell.pos(startPo.x + j*glb.iwidth,startPo.y + i*glb.iheight);
					addChild(cell);
					
					cell.on(Event.CLICK,this,onClickCell,[i,j]);
				}
			}
		}
		
		private function updateWateNum(add:Boolean = false):void
		{
			if(add)
				++waterNum;
			else
				--waterNum;
			waterTxt.text = waterNum.toString();
		}
		
		private function updateLevel():void
		{
			isPlay = true;
			++level;
			glb.curLevel = level;
			levelTxt.text = level.toString();
			
			if(!scneAni)
			{
				scneAni = new SceneAni();
				scneAni.pos(startPo.x,startPo.y);
			}
			addChild(scneAni);
			scneAni.showSceneAni();	
			scneAni.on("ENTER_NEXT_PASS",this,moveCom);
		}
		
		private function moveCom():void
		{
			isPlay = false;
			gmp.setMap();
			drawCell();
			mapAry = glb.mapAry;
		}
		
		private function onClickCell(row:int,col:int, eve:Event = null, dir:String=""):void
		{
			var tempAry:Array = [];
			if(eve)
			{
				if(isPlay) 
					return;
				var target:Water = eve.currentTarget as Water;
				updateWateNum(false);
			}
			else
				target = txtAry[row][col];
			var isPass:Boolean = true;
			var isBomb:Boolean = false;
			var num:int = mapAry[row][col] + 1; 
			if(num <= 4 )
			{
				if(num == 1)
				{
					if(eve)
						isPass = false;
				}
				else
					isPass = false;
			}
			else
				isBomb = true;
			
			if(isPass)
			{
				if(eve)
				{
					curScore = 0;
					curPoint = 0;
					isPlay = true;
				}
				num = 0;
			}
			mapAry[row][col] = num;
			target.setData(num);
			if(isPass)
			{
				
				if(isBomb)
				{
					addExtWater();
					Laya.timer.once(300,this,checkBomb,[row,col,tempAry,true]);
					playAnyAni(target,row,col);
				}
				else
				{
					Laya.timer.once(300,this,checkOfFission,[row,col,dir],false);
					starPlayAni(target,dir);
				}
			}
		}
		
		private function addExtWater():void
		{
			++curScore;
			if(curScore >= 3)
			{
				curScore = curScore - 3;
				updateWateNum(true);
			}
		}
		
		private function playAnyAni(target:Water,row:int,col:int):void
		{
			if(mapAry[row - 1] && mapAry[row - 1][col] != undefined)
				starPlayAni(target,"up");
			if(mapAry[row + 1] && mapAry[row + 1][col] != undefined)
				starPlayAni(target,"down");
			if(mapAry[row] && mapAry[row][col - 1] != undefined)
				starPlayAni(target,"left");
			if(mapAry[row] && mapAry[row][col + 1] != undefined)
				starPlayAni(target,"right");
		}
		
		private function starPlayAni(target:Water,dir:String):void
		{
			++curPoint;
			target.playOneAni(dir);
			target.on("TWC_COMPLETE",this,tweenCom);
		}
		
		private function tweenCom():void
		{
			--curPoint;
			Laya.timer.once(100,this,statePlay);
		}
		
		private function statePlay():void
		{
			isPlay = curPoint > 0;
			if(!isPlay && checkOver())
			{
				updateLevel();
			}
		}
		
		private function checkOver():Boolean
		{
			for (var i:int = 0; i < mapAry.length; i++) 
			{
				for (var j:int = 0; j < mapAry[i].length; j++) 
				{
					if(mapAry[i][j] > 0)
						return false;
				}
			}
			return true;
		}
		
		private function checkOfFission(row:int, col:int, dir:String):void
		{
			switch(dir)
			{
				case "up":
				{
					if(mapAry[row - 1] && mapAry[row - 1][col] != undefined)
					{
						onClickCell(row - 1, col, null, "up");
					}
					break;
				}
				case "down":
				{
					if(mapAry[row + 1] && mapAry[row + 1][col] != undefined)
					{
						onClickCell(row + 1, col, null, "down");
					}
					break;
				}
				case "left":
				{
					if(mapAry[row] && mapAry[row][col - 1] != undefined)
					{
						onClickCell(row, col - 1, null, "left");
					}
					break;
				}
				default:
				{
					if(mapAry[row] && mapAry[row][col + 1] != undefined)
					{
						onClickCell(row, col + 1, null, "right");
					}
					break;
				}
			}
		}
		
		private function checkBomb(row:int,col:int,ary:Array):void
		{
			//上
			if(mapAry[row - 1] && mapAry[row - 1][col] != undefined)
			{
				onClickCell(row - 1, col, null, "up");
			}
			//下
			if(mapAry[row + 1] && mapAry[row + 1][col] != undefined)
			{
				onClickCell(row + 1, col, null, "down");
			}
			//左
			if(mapAry[row] && mapAry[row][col - 1]  != undefined)
			{
				onClickCell(row, col - 1, null, "left");
			}
			//右
			if(mapAry[row] && mapAry[row][col + 1]  != undefined)
			{
				onClickCell(row, col + 1, null, "right");
			}
		}
		
		private function drawLines():void
		{
			var lineSp:Sprite = new Sprite();
			lineSp.pos(startPo.x,startPo.y);
			addChild(lineSp);
			
			for (var i:int = 0; i < glb.row + 1; i++) 
			{
				lineSp.graphics.drawLine(0, i * glb.iheight, glb.col * glb.iwidth, i * glb.iheight, "0x000000");
				lineSp.graphics.drawLine(i * glb.iwidth, 0, i * glb.iwidth, glb.row * glb.iheight, "0x000000");
			}
		}
		
		private function resetMap():void
		{
			gmp = new GameMap();
			gmp.setMap();
		}
		
		private function initDataTxt():void
		{
			var numTxt:Text = new Text();
			numTxt.text = "水滴：";
			numTxt.color = "#38a4ec";
			numTxt.fontSize = 23;
			numTxt.pos(startPo.x,startPo.y - 30);
			addChild(numTxt);
			
			waterTxt = new Text();
			waterTxt.text = waterNum.toString();
			waterTxt.color = "#38a4ec";
			waterTxt.fontSize = 23;
			addChild(waterTxt);
			waterTxt.pos(startPo.x + numTxt.width,startPo.y - 30);
			
			var lvTxt:Text = new Text();
			lvTxt.text = "等级：";
			lvTxt.color = "#3dc631";
			lvTxt.fontSize = 23;
			addChild(lvTxt);
			lvTxt.pos(startPo.x + 260,startPo.y - 30);
			
			levelTxt = new Text();
			levelTxt.text = level.toString();
			levelTxt.color = "#3dc631";
			levelTxt.fontSize = 23;
			addChild(levelTxt);
			levelTxt.pos(lvTxt.x + lvTxt.width,startPo.y - 30);
		}
	}
}