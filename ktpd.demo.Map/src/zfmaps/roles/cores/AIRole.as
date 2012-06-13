package zfmaps.roles.cores
{
	import zfmaps.roles.proessors.ais.MonsterAIProcessor;
	import zfmaps.roles.proessors.ais.RadarProcessor;
	import zfmaps.roles.proessors.ais.WanderProcessor;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	public class AIRole extends Role
	{
		private var wanderProcessor : WanderProcessor;
		private var radarProcessor : RadarProcessor;
		private var monsterAIProcessor : MonsterAIProcessor;

		public function AIRole()
		{
			super();
		}

		// ============================
		// 启动AI
		// ============================
		public function startupAI(enemy : Role) : void
		{
			if (monsterAIProcessor == null)
			{
				monsterAIProcessor = new MonsterAIProcessor();
			}

			signalQuit.add(monsterAIProcessor.destory);
			monsterAIProcessor.signalWalkTo.add(walkLineTo);
			monsterAIProcessor.reset(x, y, null, 300, 100, x, y, enemy.position);
			monsterAIProcessor.signalHitEnemy.add(destory);
			signalUpdatePosition.add(monsterAIProcessor.updatePosition);
			enemy.signalUpdatePosition.add(monsterAIProcessor.enemyUpdatePosition);
		}

		// ============================
		// 漫游
		// ============================
		public function wander() : void
		{
			if (wanderProcessor == null)
			{
				wanderProcessor = new WanderProcessor();
			}
			wanderProcessor.reset(walkAddPathPoint, null, x, y);
		}

		public function cancelWander() : void
		{
			wanderProcessor.destory();
			wanderProcessor = null;
		}

		public function pauseWander() : void
		{
			wanderProcessor.stop();
		}

		public function playWander() : void
		{
			wanderProcessor.start();
		}

		// ============================
		// 扫描敌人
		// ============================
		public function radar(role : Role) : void
		{
			if (radarProcessor == null)
			{
				radarProcessor = new RadarProcessor();
			}
			radarProcessor.reset(x, y, 200, 50, x, y, role.x, role.y, lockE, loseE, hitE);
			signalUpdatePosition.add(radarProcessor.updatePostion);
			role.signalUpdatePosition.add(radarProcessor.enemyUpdatePosition);
		}

		public function pauseRadar() : void
		{
			radarProcessor.stop();
		}

		public function playRadar() : void
		{
			radarProcessor.start();
		}

		public function cancelRadar() : void
		{
			radarProcessor.destory();
		}

		public function lockE() : void
		{
			trace("lockE");
		}

		public function loseE() : void
		{
			trace("loseE");
		}

		public function hitE() : void
		{
			trace("hitE");
		}
	}
}
