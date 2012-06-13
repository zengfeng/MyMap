package zfmaps.roles
{
	import flash.display.DisplayObject;

	import com.signalbus.Signal;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-24
	 */
	public class RoleSignals
	{
		/** 添加到RoleLayer，args=[Avatar, childIndex] */
		public static const IN_LAYER : Signal = new Signal(DisplayObject, uint);
		/** 移除从RoleLayer  */
		public static const OUT_LAYER : Signal = new Signal(DisplayObject);
		/** 深度改变 args=[Avatar, childIndex] */
		public static const CHANGE_DEPTH : Signal = new Signal(DisplayObject, uint);
	}
}
