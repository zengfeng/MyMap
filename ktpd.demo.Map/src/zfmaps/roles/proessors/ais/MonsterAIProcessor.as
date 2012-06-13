package zfmaps.roles.proessors.ais
{
	import zfmaps.auxiliarys.MapPoint;

	import com.signalbus.Signal;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-9
	// ============================
	public class MonsterAIProcessor
	{
		private var wanderProcessor : WanderProcessor;
		private var radarProcessor : RadarProcessor;
		private var trackProcessor : TrackProcessor;
		public var signalWalkTo : Signal = new Signal();
		public var signalLockEnemy : Signal = new Signal();
		public var signalLoseEnemy : Signal = new Signal();
		public var signalHitEnemy : Signal = new Signal();
		public var updatePosition : Function;
		public var enemyUpdatePosition : Function;

		function MonsterAIProcessor() : void
		{
			updatePosition = updatePositionHander;
			enemyUpdatePosition = enemyUpdatePositionHander;
		}

		public function reset(originX : int, originY : int, pointList : Vector.<MapPoint>, moveRadius : Number, attackRadius : Number, x : int, y : int, enemyPosition : MapPoint) : void
		{
			wanderProcessor = new WanderProcessor();
			wanderProcessor.reset(signalWalkTo.dispatch, pointList, originX, originY);
			radarProcessor = new RadarProcessor();
			updatePosition = radarProcessor.updatePostion;
			enemyUpdatePosition = radarProcessor.enemyUpdatePosition;
			radarProcessor.reset(originX, originY, moveRadius, attackRadius, x, y, enemyPosition.x, enemyPosition.y, signalLockEnemy.dispatch, signalLoseEnemy.dispatch, signalHitEnemy.dispatch);
			trackProcessor = new TrackProcessor();
			trackProcessor.reset(originX, originY, enemyPosition, signalWalkTo.dispatch);
			// 锁定
			signalLockEnemy.add(trackProcessor.start);
			signalLockEnemy.add(wanderProcessor.stop);
			// 失去
			signalLoseEnemy.add(trackProcessor.stop);
			signalLoseEnemy.add(trackProcessor.retreat);
			signalLoseEnemy.add(wanderProcessor.start);
			// 碰到
			signalHitEnemy.add(hit);
		}

		public function destory() : void
		{
			signalWalkTo.clear();
			signalLockEnemy.clear();
			signalLoseEnemy.clear();
			signalHitEnemy.clear();
			wanderProcessor.destory();
			radarProcessor.destory();
			wanderProcessor = null;
			radarProcessor = null;
			trackProcessor = null;
		}

		private function updatePositionHander(x : int, y : int) : void
		{
		}

		private function enemyUpdatePositionHander(x : int, y : int) : void
		{
		}

		public function start() : void
		{
			wanderProcessor.start();
			radarProcessor.start();
		}

		public function stop() : void
		{
			wanderProcessor.stop();
			radarProcessor.stop();
			trackProcessor.stop();
		}

		private function hit() : void
		{
			trace("AI_HIT");
			stop();
		}
	}
}
