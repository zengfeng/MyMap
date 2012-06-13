package zfmaps
{
	import zfmaps.npcs.NpcControl;
	import zfmaps.players.GlobalPlayers;
	import zfmaps.auxiliarys.EnterFrameListener;

	import com.signalbus.Signal;

	import flash.display.Sprite;

	import zfmaps.auxiliarys.MapStage;
	import zfmaps.auxiliarys.MapUtil;
	import zfmaps.layers.LayerContainer;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// 只有地图包内能使用，其他地方请不要使用
	// ============================
	public class MapStartup
	{
		public static var userId : int;
		public static var loginMapId : int;
		public static var mapContainer : Sprite;
		public static var signalComplete : Signal = new Signal();

		public static function startup(userId : int, loginMapId : int, mapContainer : Sprite) : void
		{
			MapStartup.userId = userId;
			MapStartup.loginMapId = loginMapId;
			MapStartup.mapContainer = mapContainer;
			
			GlobalPlayers.instance.init();
			MapProto.instance;
			MapStage.startup(mapContainer.stage);
			EnterFrameListener.startup(mapContainer.stage);
			MapUtil.setStage(mapContainer.stage);
			MapUtil.setCurrentMapId(loginMapId);
			LayerContainer.instance.init();
			
			NpcControl.instance;

			signalComplete.dispatch();
		}
	}
}
