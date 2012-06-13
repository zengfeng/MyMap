package zfmaps.roles.proessors
{
	import flash.utils.Dictionary;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// ============================
	public class MoveProessorFactory
	{
		/** 单例对像 */
		private static var _instance : MoveProessorFactory;

		/** 获取单例对像 */
		public static  function get instance() : MoveProessorFactory
		{
			if (_instance == null)
			{
				_instance = new MoveProessorFactory(new Singleton());
			}
			return _instance;
		}

		function MoveProessorFactory(singleton : Singleton) : void
		{
			singleton;
			poolDic = new Dictionary();
			poolDic[TIME] = new Vector.<TimeMoveProessor>();
			poolDic[FRAME] = new Vector.<FrameMoveProessor>();
			poolDic[SMOOTH_TIME] = new Vector.<SmoothTimeMoveProessor>();
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public static const TIME : int = 0;
		public static const FRAME : int = 1;
		public static const SMOOTH_TIME : int = 2;
		private var poolDic : Dictionary;
		private const POOL_MAX_COUNT : int = 200;
		private var tempList : Vector.<*>;

		public function make(speed : Number, callUpdate : Function, callEnd : Function, type : int = 0) : AbstractMoveProcessor
		{
			var processor : AbstractMoveProcessor = getObject(type);
			processor.reset(speed, callUpdate, callEnd);
			return processor;
		}

		public function destoryObject(object : AbstractMoveProcessor, destoryed : Boolean = false) : void
		{
			if (object == null) return;
			tempList = poolDic[getType(object)];
			if (tempList.indexOf(object) != -1) return;
			if (!destoryed) object.destory();
			if (tempList.length < POOL_MAX_COUNT) tempList.push(object);
		}

		private function getObject(type : int) : AbstractMoveProcessor
		{
			tempList = poolDic[type];
			var object : AbstractMoveProcessor;
			if (tempList.length > 0)
			{
				object = tempList.pop();
				return object;
			}

			switch(type)
			{
				case TIME:
					object = new TimeMoveProessor();
					break;
				case FRAME:
					object = new FrameMoveProessor();
					break;
				case SMOOTH_TIME:
					object = new SmoothTimeMoveProessor();
					break;
				default:
					object = new TimeMoveProessor();
			}
			return object;
		}
		

		private function getType(object : AbstractMoveProcessor) : int
		{
			if (object is TimeMoveProessor)
			{
				return TIME;
			}
			else if (object is FrameMoveProessor)
			{
				return FRAME;
			}
			else if (object is SmoothTimeMoveProessor)
			{
				return SMOOTH_TIME;
			}
			return -1;
		}
		
	}
}
class Singleton
{
}