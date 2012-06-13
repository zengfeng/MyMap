package zfmaps
{
	import zfmaps.auxiliarys.MapMath;
	import zfmaps.auxiliarys.MapUtil;

	import flash.geom.Point;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-7
	// ============================
	public class MapTo
	{
		/** 单例对像 */
		private static var _instance : MapTo;

		/** 获取单例对像 */
		public static  function get instance() : MapTo
		{
			if (_instance == null)
			{
				_instance = new MapTo(new Singleton());
			}
			return _instance;
		}

		function MapTo(singleton : Singleton) : void
		{
			singleton;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var employ : Boolean;
		private var directionX : int;
		private var directionY : int;
		private var toX : int;
		private var toY : int;
		private var toMapId : int;
		private var radius : int;
		private var flashStep : Boolean;
		private var callFun : Function;
		private var callFunArgs : Array;
		private var checkArriveNum : int = 0;

		/** 清理 */
		public function clear() : void
		{
			employ = false;
			directionX = NaN;
			directionY = NaN;
			toX = NaN;
			toY = NaN;
			toMapId = NaN;
			radius = NaN;
			flashStep = false;
			callFun = null;
			callFunArgs = null;
			checkArriveNum = 0;

			MapSignals.mouseWalkTo.remove(clear);
			MapSignals.walkEnd.remove(checkArrive);
			MapSignals.receiveTransportTo.remove(checkArrive);
			MapSignals.installComplete.remove(checkArrive);
		}

		/** 到达 */
		public function arrive() : void
		{
			trace("arrive");
			if (callFun != null) callFun.apply(null, callFunArgs);
			clear();
		}

		/** 验证是否到达 */
		private function checkArrive() : void
		{
			if (employ == false) return;
			checkArriveNum++;
			if (checkArriveNum > 10)
			{
				clear();
				throw new Error("您设置的位置可能是不可到达的地方");
				return;
			}

			if (MapUtil.isCurrentMapId(toMapId))
			{
				var distance : Number = MapMath.distance(MapUtil.selfX, MapUtil.selfY, toX, toY);
				if (distance <= radius)
				{
					arrive();
				}
				else if (flashStep)
				{
					addSignals();
					sendTransportTo();
				}
				else
				{
					addSignals();
					walkTo();
				}
			}
			else if (flashStep)
			{
				addSignals();
				sendTransportTo();
			}
			else
			{
				addSignals();
				worldMapTo();
			}
		}

		private function addSignals() : void
		{
			MapSignals.mouseWalkTo.add(mouseWalkTo);
			MapSignals.installComplete.add(checkArrive);
		}

		private function mouseWalkTo(toX : int, toY : int) : void
		{
			toX;
			toY;
			clear();
		}

		private function walkTo() : void
		{
			MapSignals.walkEnd.add(checkArrive);
			MapSignals.walkPathTo.dispatch(toX, toY);
		}

		private function sendTransportTo() : void
		{
			MapSignals.receiveTransportTo.add(receiveTransportTo);
			MapSignals.sendTransportTo.dispatch(toX, toY, toMapId);
		}

		private function receiveTransportTo(toX : int, toY : int) : void
		{
			toX;
			toY;
			checkArrive();
		}

		private function worldMapTo() : void
		{
			sendTransportTo();
		}

		// ==========================
		// 开放操作
		// ==========================
		public function toPoint(x : int, y : int, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 30) : void
		{
			clear();
			employ = true;
			directionX = x;
			directionY = y;
			toX = x;
			toY = y;
			toMapId = 0;
			radius = responseRadius;
			this.flashStep = false;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}

		public function toNpc(npcId : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 40, flashStep : Boolean = false) : void
		{
			clear();
			var point : Point = MapUtil.getNpcStandPosition(npcId, mapId);
			point.x += MapMath.randomPlusMinus(40);
			point.y += MapMath.randomPlusMinus(40);
			var directionPoint : Point = MapUtil.getNpcPosition(npcId, mapId);
			employ = true;
			directionX = directionPoint.x;
			directionY = directionPoint.y;
			toX = point.x;
			toY = point.y;
			toMapId = 0;
			radius = responseRadius;
			this.flashStep = flashStep;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}

		public function toGate(toMapId : uint, mapId : uint = 0, stand : Boolean = false, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 50, flashStep : Boolean = false) : void
		{
			clear();
			var point : Point;
			if (stand)
			{
				point = MapUtil.getGateStandPosition(toMapId, mapId);
				point.x += MapMath.randomPlusMinus(200);
				point.y += MapMath.randomPlusMinus(200);
			}
			else
			{
				point = MapUtil.getGateCenter(toMapId, mapId);
			}
			var directionPoint : Point = MapUtil.getGateCenter(toMapId, mapId);
			employ = true;
			directionX = directionPoint.x;
			directionY = directionPoint.y;
			toX = point.x;
			toY = point.y;
			toMapId = 0;
			radius = responseRadius;
			this.flashStep = flashStep;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}

		public function toMap(x : int, y : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 30, flashStep : Boolean = false) : void
		{
			clear();
			employ = true;
			directionX = x;
			directionY = y;
			toX = x;
			toY = y;
			toMapId = mapId;
			radius = responseRadius;
			this.flashStep = flashStep;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}

		public function toDupMap(toDuplMapId : int, flashStep : Boolean = false, endAutoRunCall : Function = null, questCall : Function = null, questCallArgs : Array = null, guideType : int = 0, guideArgs : Array = null) : void
		{
			
		}

		/** 要缴费的传送，如果是免费使用toMap。 */
		public function paymentTransportTo(x : int, y : int, mapId : int = 0, callFun : Function = null, callFunArgs : Array = null) : void
		{
			clear();
			employ = true;
			directionX = x;
			directionY = y;
			toX = x;
			toY = y;
			toMapId = mapId;
			radius = 30;
			this.flashStep = true;
			this.callFun = callFun;
			this.callFunArgs = callFunArgs;
			checkArrive();
		}
	}
}
class Singleton
{
}