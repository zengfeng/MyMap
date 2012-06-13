package game.manager
{
	import game.config.StaticConfig;
	import game.module.map.MapSystem;

	import com.utils.StringUtils;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;



	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-18 ����8:18:49
	 */
	public class MouseManager
	{
		/** 自动 */
		public static const AUTO : String = "auto";

		/** 指针 */
		public static const ARROW : String = "arrow";

		public static const BUTTON : String = "button";

		public static const HAND : String = "hand";

		public static const IBEAM : String = "ibeam";

		/** 对话 */
		public static const DIALO : String = "dialo";

		/** 警告 */
		public static const WARNING : String = "warning";

		/** 正确 */
		public static const CORRECT : String = "correct";

		/** 拾物品 */
		public static const PICK_UP : String = "pickUp";

		/** 战斗 */
		public static const BATTLE : String = "battle";

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 地图鼠标点击特效 */
		public static var MapMouseDownEffect : Class;

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private static var _loader : Loader;

		/** 鼠标ICO资源文件路径 */
		public static var url : String = StaticConfig.cdnRoot + "assets/MouseIcon.swf";

		/** 地图 */
		public static var map : DisplayObject;

		public static function load() : void
		{
			_loader = new Loader();
			var request : URLRequest = new URLRequest(url);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			_loader.load(request);
		}

		private static function loader_ioErrorHandler(event : IOErrorEvent) : void
		{
			trace("MouseManager中加载鼠标图标出错------ioErrorHandler: " + event);
		}

		private static function loader_completeHandler(event : Event) : void
		{
			var vector : Vector.<BitmapData>;
			var mouseCursorData : MouseCursorData;
			var ICO : Class;
			// 地图鼠标点击特效
			MapMouseDownEffect = _loader.contentLoaderInfo.applicationDomain.getDefinition("ClickEffect") as Class;
			// 指针,自动
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = _loader.contentLoaderInfo.applicationDomain.getDefinition("Default") as Class;
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(MouseManager.ARROW, mouseCursorData);
			Mouse.registerCursor(MouseManager.AUTO, mouseCursorData);
			// 对话
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			for (var i : int = 0; i < 10; i++)
			{
				ICO = _loader.contentLoaderInfo.applicationDomain.getDefinition("dialog" + i) as Class;
				vector.push(new ICO());
			}
			mouseCursorData.data = vector;
			mouseCursorData.frameRate = 6;
			Mouse.registerCursor(DIALO, mouseCursorData);
			// 警告
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = _loader.contentLoaderInfo.applicationDomain.getDefinition("Warning") as Class;
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(WARNING, mouseCursorData);
			// 正确
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = _loader.contentLoaderInfo.applicationDomain.getDefinition("Correct") as Class;
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(CORRECT, mouseCursorData);
			// 拾取
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = _loader.contentLoaderInfo.applicationDomain.getDefinition("pickUp") as Class;
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(PICK_UP, mouseCursorData);

			// 战斗
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			for (i = 1; i <= 15; i++)
			{
				ICO = _loader.contentLoaderInfo.applicationDomain.getDefinition("mouseBattle" + StringUtils.fillStr(i.toString(), 2, "0")) as Class;
				vector.push(new ICO());
			}
			mouseCursorData.data = vector;
			mouseCursorData.frameRate = 15;
			Mouse.registerCursor(BATTLE, mouseCursorData);

			if (map)
			{
				map.addEventListener(MouseEvent.CLICK, map_clickHandler);
			}
			cursor = ARROW;
		}

		private static var effect : MovieClip;
		private static function map_clickHandler(event : MouseEvent = null) : void
		{
            var elementLayer:Sprite = MapSystem.elementLayer;
			if (MapSystem.enMouseClickMovePlayer == false || event.target != elementLayer) return;
            mapClickEffect();
		}
        
        public static function mapClickEffect():void
        {
            var elementLayer:Sprite = MapSystem.elementLayer;
            if(effect == null) effect = new MapMouseDownEffect();
			effect.x = elementLayer.mouseX;
			effect.y = elementLayer.mouseY;
            effect.gotoAndPlay(1);
			if(effect.parent == null) elementLayer.addChildAt(effect, 1);
        }

		public static function set cursor(str : String) : void
		{
			Mouse.cursor = str;
		}

		public static function get cursor() : String
		{
			return Mouse.cursor;
		}
	}
}
