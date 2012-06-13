package game.manager
{
	import com.signalbus.Signal;
	import game.module.duplMap.DuplMapData;
	import game.module.quest.VoMonster;
	import game.module.quest.VoNpc;

	import zfmaps.configs.ParseMapConfig;

	import com.shortybmc.CSV;

	import flash.utils.Dictionary;

	/**
	 * @author 缺硒
	 */
	public final class XmlPraseManage
	{
		public static var signalPraseComplete:Signal = new Signal();
		public static function prase() : void
		{
			parseNpc();
			parseMonster();
			parseMaps();
			tempArray = null;
			signalPraseComplete.dispatch();
		}

		/** 解析地图配置 */
		private static function parseMaps() : void
		{
			var mapXmlDic : Dictionary = RSSManager.getInstance().mapDic;
			ParseMapConfig.parse(mapXmlDic);
			for (var key:String in  mapXmlDic)
			{
				delete mapXmlDic[key];
			}
		}

		private static var tempArray : Array;

		/** 解析NPC **/
		private static function parseNpc() : void
		{
			if (!RSSManager.npcList) RSSManager.npcList = new Vector.<VoNpc>();
			tempArray = (RSSManager.getInstance().getData("npc", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray)
			{
				var vo : VoNpc = new VoNpc();
				vo.parse(arr);
				RSSManager.npcList.push(vo);
			}
			RSSManager.getInstance().deleteData("npc", RSSManager.TYPE_CSV);
		}

		/** 解析Monster **/
		private static function parseMonster() : void
		{
			if (!RSSManager.mosterList) RSSManager.mosterList = new Vector.<VoMonster>();
			tempArray = (RSSManager.getInstance().getData("monster", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray)
			{
				var vo : VoMonster = new VoMonster();
				vo.parse(arr);
				RSSManager.mosterList.push(vo);
			}
			RSSManager.getInstance().deleteData("monster", RSSManager.TYPE_CSV);
		}
	}
}
