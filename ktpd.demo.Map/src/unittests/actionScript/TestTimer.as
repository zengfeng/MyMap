package unittests.actionScript
{
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
	public class TestTimer extends Sprite
	{
		private var timer : Timer;
		public var timeDic : Dictionary = new Dictionary();
		public var timerDic : Dictionary = new Dictionary();
		public var indexDic : Dictionary = new Dictionary();

		public function TestTimer()
		{
			addChild(new TheMiner());
			var timer : Timer;
			for (var i : int = 0; i < 1; i++)
			{
				timer = new Timer(500, 0);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				timeDic[timer.delay+"_"+i] = getTimer();
				indexDic[timer] = i;
				timer.start();
			}
		}

		private function onTimerComplete(event : TimerEvent) : void
		{
			var timer : Timer = event.target as Timer;
			trace("timer<" + timer.delay + ">", "onTimerComplete");
		}

		private function onTimer(event : TimerEvent) : void
		{
			var timer : Timer = event.target as Timer;
			trace("timer<" + timer.delay + "_" + indexDic[timer] + ">", getTimer() - timeDic[timer.delay + "_" + indexDic[timer] ]);
			 timeDic[timer.delay + "_" + indexDic[timer] ]= getTimer();
			 timer.stop();
		}
	}
}
