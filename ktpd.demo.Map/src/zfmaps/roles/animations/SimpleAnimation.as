package zfmaps.roles.animations
{
	import game.core.avatar.AvatarThumb;
	import zfmaps.roles.animations.depths.RoleNode;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-1
	// ============================
	public class SimpleAnimation extends RoleNode
	{
		public function resetSimple(avatar : AvatarThumb):void
		{
			setAvatar(avatar);
		}
		
		protected function setAvatar(avatar : AvatarThumb) : void
		{
			this.avatar = avatar;
			inLayer();
		}

		public function destory() : void
		{
			outLayer();
			AvatarFactory.destoryAvatar(avatar);
			avatar = null;
			destoryToPool();
		}
		
		protected function destoryToPool() : void
		{
			SimpleAnimationPool.instance.destoryObject(this, true);
		}

		public function setPosition(x : int, y : int) : void
		{
			this.x = x;
			this.y = y;
			avatar.x = x;
			avatar.y = y;
			updateDepth();
		}

		public function stand() : void
		{
			avatar.stand();
		}

		public function standDirection(targetX : int, targetY : int, x : int = 0, y : int = 0) : void
		{
			avatar.standDirection(targetX, targetY, x, y);
		}

		public function run(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			avatar.run(toX, toY, fromX, fromY);
		}

		public function attack(targetX : int) : void
		{
			if (targetX > x)
			{
				avatar.fontAttack();
			}
			else
			{
				avatar.backAttack();
			}
		}
	}
}
