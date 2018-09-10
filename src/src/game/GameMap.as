package src.game
{
	public class GameMap
	{
		private var glb:Global;
		private var mapAry:Array;
		public function GameMap()
		{
			glb = Global.Ins();
		}
		
		public function setMap():void
		{
			//			mapAry = [[0, 0, 0, 0, 0, 0],
			//					  [1, 1, 0, 0, 3, 2],
			//					  [3, 0, 2, 0, 2, 2],
			//					  [0, 2, 3, 1, 0, 1],
			//				 	  [3, 0, 0, 0, 3, 1],
			//					  [1, 3, 0, 1, 1, 3]];
			//			glb.mapAry = mapAry;
			//			return;
			
			mapAry = [];
			for (var i:int = 0; i < glb.row; i++) 
			{
				if(!mapAry[i])
					mapAry[i] = []
				for (var j:int = 0; j < glb.col; j++) 
				{
					mapAry[i][j] = getRandom;
				}
			}
			if(glb.isDebug)
			{
				trace("=====================地图数据=====================")
				for (i = 0; i < mapAry.length; i++) 
				{
					trace(mapAry[i]);
				}
			}
			glb.mapAry = mapAry;
		}
		
		private function get getRandom():int
		{
			var random:int = Math.random() * 10;
			if(random <= 2)
				random = 0;
			else if(random < 3)
				random = 1;
			else if(random < 5)
				random = 2;
			else if(random < 8)
				random = 3;
			else if(random < 10)
				random = 4;
			return random;
		}
	}
}