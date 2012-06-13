package zfmaps.roles.cores
{
	import zfmaps.roles.PlayerPool;
	import zfmaps.roles.RoleFactory;
	import zfmaps.roles.animations.PlayerAnimation;
	import zfmaps.roles.animations.PlayerAnimationPool;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// ============================
	public class Player extends AIRole
	{
		// ==============
		// 稳定信息
		// ==============
		public var playerId : int;
		public var heroId : int;
		public var clothId : int;
		public var rideId : int;
		// ==============
		// 处理器及回调
		// ==============
		protected var playerAnimation : PlayerAnimation;
		protected var turtle : Role;

		function Player() : void
		{
			super();
		}

		override public function destory() : void
		{
			super.destory();
			playerAnimation = null;
		}

		override protected function destoryToPool() : void
		{
			PlayerPool.instance.destoryObject(this, true);
		}

		public function resetPlayer(playerId : int, name : String, colorStr : String, heroId : int, clothId : int, rideId : int) : void
		{
			this.playerId = playerId;
			this.name = name;
			this.colorStr = colorStr;
			this.heroId = heroId;
			this.clothId = clothId;
			this.rideId = rideId;

			playerAnimation = PlayerAnimationPool.instance.getObject(heroId, clothId, rideId, name, colorStr);
			setAnimation(playerAnimation);
		}

		// =======================
		// 走路
		// =======================
		public function walkServerTo(toX : int, toY : int, hasFrom : Boolean, fromX : int, fromY : int) : void
		{
			walkProcessor.serverTo(toX, toY, hasFrom, fromX, fromY);
		}

		// =======================
		// 打座
		// =======================
		public function sitDown() : void
		{
			walkStop();
			rideDown();
			playerAnimation.sitDown();
			signalWalkStart.add(rideUp);
		}

		public function sitUp() : void
		{
			playerAnimation.stand();
			rideUp();
		}

		// =======================
		// 坐骑
		// =======================
		public function rideUp(rideId : int = -1) : void
		{
			signalWalkStart.remove(rideUp);
			if (rideId != -1) this.rideId = rideId;
			if (this.rideId == 0)
			{
				rideDown();
			}
			else
			{
				playerAnimation.rideUp(this.rideId);
			}
		}

		protected function rideDown() : void
		{
			playerAnimation.rideDown();
		}

		// =======================
		// 换装
		// =======================
		public function changeCloth(clothId : int) : void
		{
			this.clothId = clothId;
			playerAnimation.changeCloth(clothId, heroId);
		}

		// =======================
		// 钓鱼
		// =======================
		public function fishModelIn(fishDirection : int) : void
		{
			walkStop();
			rideDown();
			playerAnimation.fishModelIn(fishDirection);
		}

		public function fishModelOut() : void
		{
			playerAnimation.fishModelOut();
			rideUp();
		}

		public function fishSit() : void
		{
			playerAnimation.fishSit();
		}

		public function fishHold() : void
		{
			playerAnimation.fishHold();
		}

		public function fishPull(awardUrl : String, onPullComplete : Function) : void
		{
			playerAnimation.fishPull(awardUrl, onPullComplete);
		}

		// =======================
		// 龟仙拜佛
		// =======================
		public function convoyModelIn(quality : int, name : String, colorStr : String, isFast : Boolean) : void
		{
			rideUp(1);
			animation.stand();
			turtle = RoleFactory.instance.makeTurtle(quality, this.name, this.colorStr, name, colorStr);
			turtle.initPosition(x, y, 0.6, false, 0, 0, 0, 0, 0);
			turtle.follow(this);
			if (isFast)
			{
				convoySpeedFast();
			}
			else
			{
				convoySpeedSlowly();
			}
		}

		public function convoyModelOut() : void
		{
			turtle.destory();
			turtle = null;
			rideDown();
			walkStop();
			recoverSpeed();
		}

		public function convoySpeedSlowly() : void
		{
			dispatchSpeed(0.6);
		}

		public function convoySpeedFast() : void
		{
			dispatchSpeed(15);
		}
		
	}
}
