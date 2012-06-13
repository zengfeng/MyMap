package zfmaps.auxiliarys
{
	import com.signalbus.Signal;

	import flash.utils.Dictionary;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-11
	// ============================
	public class GateOpened
	{
		/** args=[gateId, isOpen] */
		public static var signalState : Signal = new Signal(int, Boolean);
		private static var dic : Dictionary = new Dictionary();

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

		public static function setState(gateId : int, isOpen : Boolean) : void
		{
			dic[gateId] = isOpen;
			signalState.dispatch(gateId, isOpen);
		}

		public static function getState(gateId : int) : Boolean
		{
			return dic[gateId] == true;
		}
	}
}