package game.manager
{
	import com.shortybmc.CSV;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.core.avatar.AvatarManager;
	import game.module.quest.VoBase;
	import game.module.quest.VoMonster;
	import game.module.quest.VoNpc;
	import game.net.core.Common;
	import gameui.skin.ASSkin;
	import gameui.theme.BlackTheme;
	import log4a.Logger;
	import net.AssetData;
	import net.LibData;
	import net.RESLoader;
	import net.RESManager;
	import net.SWFLoader;






	/**
	 * @author yangyiqiang
	 */
	public final class RSSManager
	{
		public static const TYPE_CSV : String = "csv";

		public static const TYPE_XML : String = "xml";

		public static const TYPE_MAP : String = "map";

		public static const TYPE_TXT : String = "txt";

		/** Npc 列表 **/
		public static var npcList : Vector.<VoNpc>;

		/** 怪物列表 **/
		public static var mosterList : Vector.<VoMonster>;

		/** vip等级信息 */
		public static var vipDic : Dictionary = new Dictionary(true);

		private static var __instance : RSSManager;

		// csv文件
		private var _csvDic : Dictionary;

		// xml文件
		private var _xmlDic : Dictionary;

		// 地图xml文件
		private var _mapDic : Dictionary;

		// txt文件
		private var _txtDic : Dictionary;

		private var _res : RESManager;

		public function RSSManager()
		{
			if (__instance != null)
				throw Error("此类为单类，初始化出错！");
			_csvDic = new Dictionary();
			_xmlDic = new Dictionary();
			_mapDic = new Dictionary();
			_txtDic = new Dictionary();
			_res = RESManager.instance;
		}

		/** 
		 * @author yangyiqiang
		 * @version 1.0
		 * @param 单类
		 * @return ConfigManager
		 */
		public static function getInstance() : RSSManager
		{
			if ( __instance == null)
			{
				__instance = new RSSManager();
			}
			return __instance;
		}

		public function startLoad() : void
		{
			ASSkin.setTheme(AssetData.AS_LIB, new BlackTheme());
			_res.add(new RESLoader(new LibData(VersionManager.instance.getUrl("config/config.kt"), "config.kt")));
			var url : String = VersionManager.instance.getUrl("assets/avatar/1677721602.swf");
			_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(1677721602).parse, [url]));
			url = VersionManager.instance.getUrl("assets/avatar/1677721604.swf");
			_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(1677721604).parse, [url]));
			_res.addEventListener(Event.COMPLETE, loadComplete);
			_res.startLoad();
			Logger.debug("rssmanager startLoad");
		}

		/** 解析语言包 **/
		public function parseLanguagePack(bytes : ByteArray) : void
		{
		}

		/**
		 * 获取配置文件
		 * @param name 文件名
		 * @param type 类型
		 * @return  
		 */
		public function getData(name : String, type : String = "xml") : *
		{
			switch(type)
			{
				case TYPE_XML:
					if (!_xmlDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的xml文件");
					return _xmlDic[name];
				case TYPE_CSV:
					if (!_csvDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的csv文件");
					return _csvDic[name];
				case TYPE_MAP:
					if (!_mapDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的地图文件");
					return _mapDic[name];
				case TYPE_TXT:
					if (!_txtDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的txt文件");
					return _txtDic[name];
			}
		}

		/**
		 * 删除配置文件
		 * @param name
		 * @param type
		 */
		public function deleteData(name : String, type : String = "xml") : void
		{
			switch(type)
			{
				case TYPE_XML:
					if (!_xmlDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的xml文件");
					delete _xmlDic[name];
					break;
				case TYPE_CSV:
					if (!_csvDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的csv文件");
					delete _csvDic[name];
					break;
				case TYPE_MAP:
					if (!_mapDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的地图文件");
					delete _mapDic[name];
					break;
			}
		}

		public function get mapDic() : Dictionary
		{
			return _mapDic;
		}

		public  function getNpcById(npcId : int) : VoNpc
		{
			if (!npcList)
			{
				Logger.error("npc列表为空，错误位置 RSSManager==>getNpcById()");
				return null;
			}
			var max : int = npcList.length;
			for (var i : int = 0;i < max;i++)
			{
				if (npcList[i].id == npcId) return npcList[i];
			}
			Logger.error("npcId==" + npcId + " 的任务没找到，错误位置 RSSManager==>getNpcById()");
			return null;
		}

		public function getMosterById(mosterId : int) : VoMonster
		{
			if (!mosterList)
			{
				Logger.error("moster列表为空，错误位置 RSSManager==>getNpcById()");
				return null;
			}
			var max : int = mosterList.length;
			for (var i : int = 0;i < max;i++)
			{
				if (mosterList[i].id == mosterId) return mosterList[i];
			}
			Logger.error("mosterId==" + mosterId + " 的任务没找到，错误位置 RSSManager==>getMosterById()");
			return null;
		}

		public function getStructById(id : int) : VoBase
		{
			return id > 4000 ? getMosterById(id) : getNpcById(id);
		}

		public function isNpc(id : int) : Boolean
		{
			return id < 4000;
		}

		public var loginLoadComplete : Boolean = false;

		public var loginLoadCompleteCall : Function;

		/**
		 * 解析载入完成的配置文件
		 * 所有基础数据加载完成后 向服务器请求个人信息
		 */
		private function loadComplete(evt : Event) : void
		{
			_res.removeEventListener(Event.COMPLETE, loadComplete);
			parseConfig(RESManager.getByteArray("config.kt"));
			Logger.debug("加载完成");
			loginLoadComplete = true;
		}

		/** 解析config **/
		public function parseConfig(bytes : ByteArray, battleFlg : int = 0) : void
		{
			bytes.position = 0;
			bytes.uncompress();
			var count : uint = bytes.readShort();
			for (var i : int = 0; i < count; i++)
			{
				var title : String = bytes.readUTF();
				var type : String = title.split(".")[1];
				var name : String = title.split(".")[0];
				var len : uint = bytes.readInt();
				var context : String = bytes.readUTFBytes(len);
				switch(type)
				{
					case TYPE_XML:
						_xmlDic[name] = new XML(context);
						break;
					case TYPE_CSV:
						_csvDic[name] = new CSV(context);
						break;
					case TYPE_MAP:
						_mapDic[name] = new XML(context);
						break;
					case TYPE_TXT:
						_txtDic[name] = new String(context);
						break;
				}
			}
			if (battleFlg == 0)
				XmlPraseManage.prase();
		}
	}
}
