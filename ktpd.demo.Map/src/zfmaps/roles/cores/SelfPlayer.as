package zfmaps.roles.cores
{

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// ============================
	public class SelfPlayer extends Player
	{
		/** 单例对像 */
		private static var _instance : SelfPlayer;

		/** 获取单例对像 */
		static public function get instance() : SelfPlayer
		{
			if (_instance == null)
			{
				_instance = new SelfPlayer(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var cacheing : Boolean = false;

		public function SelfPlayer(singleton:Singleton)
		{
			singleton;
			super();
		}

		public function cacheIn() : void
		{
			if (cacheing == true) return;
			cacheing = true;
			walkStop();
			animation.outLayer();
		}

		public function cacheOut() : void
		{
			if (cacheing == false) return;
			animation.inLayer();
			cacheing = false;
		}
	}
}
class Singleton
{
}