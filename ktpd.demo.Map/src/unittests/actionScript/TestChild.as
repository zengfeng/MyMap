package unittests.actionScript
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	import flash.utils.getTimer;
	import flash.display.DisplayObject;

	import com.sociodox.theminer.TheMiner;

	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.system.Security;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class TestChild extends Sprite
	{
		public function TestChild()
		{
			addChild(new TheMiner());
			initializeStage(stage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			var sprite : Sprite = this;
			var color : Number = Math.random() * 0xdddddd + 0x222222;
			sprite.graphics.beginFill(color, 0.7);
			sprite.graphics.lineStyle(1, 0xFFFFFF);
			sprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			sprite.graphics.endFill();
			sprite.cacheAsBitmap = true;
//			sprite.mouseEnabled = false;
//			sprite.mouseChildren = false;
		}

		private function onEnterFrame(event : Event) : void
		{
			this.x = Math.random() * 3;
			this.y = Math.random() * 3;
		}

		private function onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.C:
					create();
					break;
				case Keyboard.A:
					add();
					break;
				case Keyboard.R:
					remove();
					break;
			}
		}

		private function initializeStage(stage : Stage) : void
		{
			flash.system.Security.allowDomain("*");
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		public var list : Vector.<Sprite> = new Vector.<Sprite>();

		public function create() : void
		{
			var time : Number = getTimer();
			for (var i : int = 0; i < 100; i++)
			{
				var sprite : Sprite = new Sprite();
				var color : Number = Math.random() * 0xdddddd + 0x222222;
				sprite.graphics.beginFill(color, 0.7);
				sprite.graphics.lineStyle(1, 0xFFFFFF);
				sprite.graphics.drawRect(0, 0, 200, 200);
				sprite.graphics.endFill();
				list.push(sprite);
				sprite.cacheAsBitmap = true;
				sprite.mouseEnabled = false;
				sprite.mouseChildren = false;
			}
			trace("create time", getTimer() - time);
		}

		public function add() : void
		{
			var time : Number = getTimer();
			for (var i : int = 0; i < list.length; i++)
			{
				var sprite : Sprite = list[i] ;
				sprite.x = Math.random() * stage.stageWidth;
				sprite.y = Math.random() * stage.stageHeight;
				// addChildAt(sprite, 0);
				setTimeout(addChildAt, i * 10, sprite, 0);
			}
			trace("add time", getTimer() - time);
		}

		public function remove() : void
		{
			var time : Number = getTimer();
			for (var i : int = 0; i < list.length; i++)
			{
				var sprite : Sprite = list[i] ;
				if (sprite.parent)
				{
					// sprite.parent.removeChild(sprite);
					setTimeout(sprite.parent.removeChild, i * 10, sprite);
				}
			}
			trace("remove time", getTimer() - time);
		}
	}
}
