package unittests.actionScript
{
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import com.sociodox.theminer.TheMiner;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1000" , height="300" ) ]
	public class TestSetInterval extends Sprite
	{
		public var timeDic : Dictionary = new Dictionary();

		public function TestSetInterval()
		{
			addChild(new TheMiner());
			var timer : uint;
			for (var i : int = 0; i < 1000; i++)
			{
				timer = setInterval(onTimer, 500, i);
				timeDic[i] = getTimer();
			}
		}

		private function onTimer(i:int) : void
		{
			trace("timer<"+i + ">", getTimer() - timeDic[i]);
			timeDic[i] = getTimer();
		}
	}
}
