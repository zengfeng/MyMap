package zfmaps.auxiliarys
{
	import com.signalbus.Signal;

	import flash.utils.Dictionary;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-11
	// ============================
	public class BarrierOpened
	{
		/** args=[barrierId, isOpen] */
		public static var signalState : Signal = new Signal(int, Boolean);
		public static var dic : Dictionary = new Dictionary();

		public static function clear() : void
		{
			signalState.clear();
			var keyArr : Array = [];
			for (var key:String in dic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				delete dic[keyArr.shift()];
			}
		}

		public static function setState(barrierId : int, isOpen : Boolean) : void
		{
			dic[barrierId] = isOpen;
			signalState.dispatch(barrierId, isOpen);
		}

		public static function getState(barrierId : int) : Boolean
		{
			return dic[barrierId];
		}
	}
}
