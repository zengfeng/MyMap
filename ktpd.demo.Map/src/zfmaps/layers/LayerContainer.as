package zfmaps.layers
{
	import game.manager.MouseManager;

	import flash.display.MovieClip;

	import zfmaps.MapSignals;
	import zfmaps.MapStartup;
	import zfmaps.auxiliarys.MapUtil;
	import zfmaps.layers.lands.LandLayer;
	import zfmaps.layers.lands.installs.LandInstall;

	import flash.display.Sprite;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class LayerContainer
	{
		/** 单例对像 */
		private static var _instance : LayerContainer;

		/** 获取单例对像 */
		static public function get instance() : LayerContainer
		{
			if (_instance == null)
			{
				_instance = new LayerContainer(new Singleton());
			}
			return _instance;
		}

		function LayerContainer(singleton : Singleton) : void
		{
			singleton;
		}

		/** 容器 */
		public var container : Sprite;
		// ================
		// 层级
		// ================
		/** 陆地层 */
		public var landLayer : LandLayer;
		/** 传送门层 */
		public var gateLayer : GateLayer;
		/** 角色层 */
		public var roleLayer : RoleLayer;
		/** UI层 */
		public var uiLayer : UILayer;
		private var landInstall : LandInstall;

		public function init() : void
		{
			landInstall = LandInstall.instance;
			container = MapStartup.mapContainer;
			landLayer = LandLayer.instance;
			landLayer.init();
			gateLayer = new GateLayer(container);
			roleLayer = RoleLayer.instance;
			uiLayer = new UILayer(container);

			container.cacheAsBitmap = true;

			container.addChild(landLayer);
			container.addChild(roleLayer);

			MapSignals.mouseWalkTo.add(showMouseClickEffect);
		}

		private var clickEffect : MovieClip;

		private function showMouseClickEffect(toX : int, toY : int) : void
		{
			if (clickEffect == null)
			{
				var myClass : Class = MouseManager.MapMouseDownEffect;
				if (myClass)
				{
					clickEffect = new myClass();
				}
				else
				{
					return;
				}
			}
			if (container.contains(roleLayer) == false) return;
			clickEffect.x = toX;
			clickEffect.y = toY;
			clickEffect.gotoAndPlay(1);
			if (clickEffect.parent == null) container.addChildAt(clickEffect, container.getChildIndex(roleLayer));
		}

		private var num : int = 0;

		private function setPosition(mapX : int, mapY : int, forceLoad : Boolean = false) : void
		{
			num++;
			container.x = mapX ;
			container.y = mapY;
			if (forceLoad == false && num < 20)
			{
				num = 0;
				landInstall.loadMapPosition(-mapX, -mapY);
			}
		}

		public function initPosition(mapX : int, mapY : int) : void
		{
			container.x = mapX;
			container.y = mapY;
		}

		private var mapX : int;
		private var mapY : int;

		public function updatePosition(selfX : int, selfY : int) : void
		{
			mapX = MapUtil.selfToMapX(selfX);
			mapY = MapUtil.selfToMapY(selfY);
			if (mapX == container.x && mapY == container.y) return;
			setPosition(mapX, mapY);
		}
	}
}
class Singleton
{
}