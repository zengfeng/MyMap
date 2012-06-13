package zfmaps
{
	import zfmaps.resets.MapReset;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-21
	 */
	public class MapControl
	{
		/** 单例对像 */
		private static var _instance : MapControl;

		/** 获取单例对像 */
		static public function get instance() : MapControl
		{
			if (_instance == null)
			{
				_instance = new MapControl(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		function MapControl(singleton : Singleton) : void
		{
			singleton;
			mapRest = MapReset.instance;
		}

		private var mapRest : MapReset;

		public function reset(mapId : int, selfInitX : int, selfInitY : int) : void
		{
			mapRest.reset(mapId, selfInitX, selfInitY);
		}
	}
}
class Singleton
{
}