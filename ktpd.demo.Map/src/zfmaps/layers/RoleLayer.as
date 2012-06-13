package zfmaps.layers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import zfmaps.auxiliarys.PointShape;
	import zfmaps.roles.RoleSignals;


	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class RoleLayer extends Sprite
	{
		/** 单例对像 */
		private static var _instance : RoleLayer;

		/** 获取单例对像 */
		static public function get instance() : RoleLayer
		{
			if (_instance == null)
			{
				_instance = new RoleLayer(new Singleton());
			}
			return _instance;
		}

		// ===========
		// 绘制地图高宽的两个点
		// ===========
		private var leftTopPointShape : PointShape;
		private var rightBottomPointShape : PointShape;

		public function RoleLayer(singleton : Singleton)
		{
			singleton;
			mouseEnabled = false;
			leftTopPointShape = new PointShape();
			rightBottomPointShape = new PointShape();
			addChild(leftTopPointShape);
			addChild(rightBottomPointShape);
			RoleSignals.IN_LAYER.add(addAt);
			RoleSignals.OUT_LAYER.add(remove);
			RoleSignals.CHANGE_DEPTH.add(addAt);
		}

		/**  重设  */
		public function reset(mapWidth : int, mapHeight : int) : void
		{
			rightBottomPointShape.x = mapWidth - rightBottomPointShape.width;
			rightBottomPointShape.y = mapHeight - rightBottomPointShape.height;
		}

		public function addAt(displayObject : DisplayObject, childIndex : int) : void
		{
			addChildAt(displayObject, childIndex);
		}

		public function remove(displayObject : DisplayObject) : void
		{
			removeChild(displayObject);
		}
	}
}
class Singleton
{
}