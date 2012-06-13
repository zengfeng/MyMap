package unittests.actionScript
{
	import zfmaps.auxiliarys.TimerChannel;

	import flash.display.Sprite;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1000" , height="300" ) ]
	public class TesetTimerChannel extends Sprite
	{
		public function TesetTimerChannel()
		{
			TimerChannel.add(TimerChannel.TIME_1000,onTimer);
		}

		private var i : int = 0;

		public function onTimer() : void
		{
			i++;
			if (i >= 5)
			{
				TimerChannel.remove(TimerChannel.TIME_1000,onTimer);
			}
		}

		public function onTimer1000() : void
		{
		}
	}
}
