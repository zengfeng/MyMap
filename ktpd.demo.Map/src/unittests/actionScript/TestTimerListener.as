package unittests.actionScript
{
	import flash.utils.getTimer;
	import zfmaps.auxiliarys.TimerListener;
	import flash.display.Sprite;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1000" , height="300" ) ]
	public class TestTimerListener extends Sprite
	{
		private var timerListener:TimerListener;
		public function TestTimerListener()
		{
			timerListener = new TimerListener(50);
			timerListener.add(onTimer);
			time = getTimer();
		}
		
		private var i:int;
		private var time:Number;
		public function onTimer():void
		{
			i++;
			trace(i, getTimer() - time);
			time = getTimer();
//			if(i > 10) timerListener.clear();
			if(i >= 100) timerListener.remove(onTimer);
		}
	}
}
