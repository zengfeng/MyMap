package game.manager
{
	import flash.utils.Dictionary;

	import game.config.StaticConfig;

	/**
	 * @author yangyiqiang
	 */
	public class VersionManager
	{
		private static var _instance : VersionManager;
		private var _versionDic : Dictionary = new Dictionary(true);

		public function VersionManager()
		{
			if (_instance)
			{
				throw Error("---VersionManager--is--a--single--model---");
			}
		}

		public static function get instance() : VersionManager
		{
			if (_instance == null)
			{
				_instance = new VersionManager();
			}
			return _instance;
		}

		public function initVersion(url : String, version : String) : void
		{
			_versionDic[url] = version;
		}

		/**
		 * 根据版本来取文件路径
		 */
		public function getUrl(url : String) : String
		{
			return "D:/client/KTPDProject/" + url;
		}
	}
}
