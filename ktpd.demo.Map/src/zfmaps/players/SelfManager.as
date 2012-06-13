package zfmaps.players
{
	import zfmaps.auxiliarys.MapUtil;
	import zfmaps.layers.lands.LandLayer;
	import zfmaps.MapSignals;
	import zfmaps.layers.LayerContainer;
	import zfmaps.roles.cores.SelfPlayer;
	import zfmaps.structs.PlayerStruct;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-5
	// ============================
	public class SelfManager
	{
		/** 单例对像 */
		private static var _instance : SelfManager;

		/** 获取单例对像 */
		static public function get instance() : SelfManager
		{
			if (_instance == null)
			{
				_instance = new SelfManager(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var player : SelfPlayer;
		private var playerStruct : PlayerStruct;

		function SelfManager(singleton : Singleton) : void
		{
			singleton;
			playerStruct = GlobalPlayers.instance.self;
			MapSignals.enableMouseWalk.add(enableMouseWalk);
			MapSignals.scorllBindSelf.add(scorllBindSelf);
		}

		/** 创建 */
		private function create() : void
		{
			player = SelfPlayer.instance;
		}

		/** 重设 */
		public function reset() : void
		{
			if (player == null)
			{
				create();
			}
			player.resetPlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
			player.initPosition(playerStruct.x, playerStruct.y, playerStruct.speed, playerStruct.walking, playerStruct.walkTime, playerStruct.fromX, playerStruct.fromY, playerStruct.toX, playerStruct.toY);
			player.cacheOut();
			player.signalUpdatePosition.add(MapUtil.setSelfPosition);
			player.signalWalkEnd.add(MapSignals.walkEnd.dispatch);
			player.signalTransportTo.add(MapSignals.receiveTransportTo.dispatch);
			MapSignals.walkPathTo.add(player.walkPathTo);
		}

		/** 缓存 */
		public function cache() : void
		{
			if (player == null) return;
			player.cacheIn();
		}

		// ===================
		// 鼠标是否能走路
		// ===================
		private function enableMouseWalk(value : Boolean) : void
		{
			LandLayer.instance.mouseEnabled = value;
			if (value)
			{
				MapSignals.mouseWalkTo.add(player.walkPathTo);
			}
			else
			{
				MapSignals.mouseWalkTo.remove(player.walkPathTo);
			}
		}

		// ===================
		// 是否绑定地图卷动
		// ===================
		private function scorllBindSelf(value : Boolean) : void
		{
			if (value)
			{
				player.signalUpdatePosition.add(LayerContainer.instance.updatePosition);
			}
			else
			{
				player.signalUpdatePosition.remove(LayerContainer.instance.updatePosition);
			}
		}
	}
}
class Singleton
{
}