package zfmaps.roles.animations.depths
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import game.core.avatar.AvatarThumb;
	import zfmaps.roles.RoleSignals;



	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-20 ����10:33:44
	 */
	public class RoleNode
	{
		public var pre : RoleNode;
		public var next : RoleNode;
		protected var name : String;
		protected var x : int;
		protected var y : int;
		protected var avatar : AvatarThumb;
		private static var linkList : RoleLinkList = RoleLinkList.instance;
		private var tempIndex : int;
		private var tempIsChange : Boolean;
		private var tempParent : DisplayObjectContainer;
		private var tempPreAvatar : DisplayObject;

		public function RoleNode()
		{
		}

		public function compare(node : RoleNode) : int
		{
			return y - (node ? node.y : 0);
		}

		public function toString() : String
		{
			return  "name" + name + "  y=" + y;
		}

		public function inLayer() : void
		{
			tempIndex = linkList.sortAdd(this);
			RoleSignals.IN_LAYER.dispatch(avatar, tempIndex);
			tempParent = avatar.parent;
		}

		public function outLayer() : void
		{
			linkList.remove(this);
			RoleSignals.OUT_LAYER.dispatch(avatar);
			tempParent = null;
		}

		protected function updateDepth() : void
		{
			tempIsChange = linkList.sortUpdate(this);
			if (tempIsChange == false) return;
			if (pre)
			{
				tempPreAvatar = pre.avatar;
				tempIndex = tempParent.getChildIndex(tempPreAvatar) + 1;
			}
			else
			{
				tempIndex = 0;
			}
			RoleSignals.CHANGE_DEPTH.dispatch(avatar, tempIndex);
		}
	}
}
