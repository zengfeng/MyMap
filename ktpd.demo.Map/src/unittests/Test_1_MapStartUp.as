package unittests
{
	import game.manager.MouseManager;
	import game.manager.RSSManager;
	import game.manager.XmlPraseManage;

	import zfmaps.MapStartup;

	import com.sociodox.theminer.TheMiner;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.system.Security;



	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class Test_1_MapStartUp extends Sprite
	{
		protected var userId : int = 1;
		protected var loginMapId : int = 1;
		protected var mapContainer : Sprite = new Sprite();
		protected var sprite : Sprite = new Sprite();

		public function Test_1_MapStartUp()
		{
			initializeStage(stage);
			sprite.addChild(mapContainer);
			addChild(sprite);
//			sprite.scaleX = sprite.scaleY = 0.4;
//			sprite.x = 200;
//			sprite.y = 100;
			addChild(new TheMiner());
			XmlPraseManage.signalPraseComplete.add(startup);
			loadConfigData();
		}
		
		
		
		private function initializeStage(stage : Stage) : void
		{
			flash.system.Security.allowDomain("*");
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		public function loadConfigData():void
		{
			RSSManager.getInstance().startLoad();
		}

		public function startup() : void
		{
			MapStartup.startup(userId, loginMapId, mapContainer);
			MouseManager.load();
		}
       
	}
}
