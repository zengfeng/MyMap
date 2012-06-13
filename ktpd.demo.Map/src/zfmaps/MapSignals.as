package zfmaps
{
	import com.signalbus.Signal;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// ============================
	public class MapSignals
	{
		public static const receiveMapInfoStart : Signal = new Signal();
		public static const receiveMapInfoComplete : Signal = new Signal();
		public static const installStart : Signal = new Signal();
		public static const installComplete : Signal = new Signal();
		//args=[toX, toY, mapId]
		public static const sendTransportTo:Signal = new Signal(int,int, int);
		//args=[toX, toY]
		public static const receiveTransportTo:Signal = new Signal(int,int);
		public static const walkEnd:Signal = new Signal();
		//args=[toX, toY]
		public static const walkPathTo : Signal = new Signal(int, int);
		//args=[toX, toY]
		public static const mouseWalkTo : Signal = new Signal(int, int);
		public static const enableMouseWalk:Signal = new Signal(Boolean);
		public static const scorllBindSelf:Signal = new Signal(Boolean);
	}
}