package src.game
{
	public class Global
	{
		private static var _in:Global;
		public static function Ins():Global
		{
			return _in ||= new Global();
		}
		
		/**当前等级*/
		public var curLevel:int = 1;
		/**当前水滴*/
		public var curWater:int = 15;
		public var isDebug:Boolean = true;
		/**行*/
		public var row:int = 6;
		/**列*/
		public var col:int = 6;
		/**宽*/
		public var iwidth:int = 60;
		/**高*/
		public var iheight:int = 60;
		/**showW*/
		public var showW:Number = iwidth * col;
		/**showH*/
		public var showH:Number = iheight * row;
		/**场景宽*/
		public var sceneW:Number = 1270;
		/**场景高*/
		public var sceneH:Number = 720;
		/**地图数据*/
		public var mapAry:Array;
	}
}