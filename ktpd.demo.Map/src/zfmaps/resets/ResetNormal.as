package zfmaps.resets
{
	import zfmaps.players.SelfManager;
	import zfmaps.players.Model;
	import zfmaps.MapSignals;
	import zfmaps.npcs.NpcSignals;
	import zfmaps.players.PlayerControl;
	import zfmaps.players.PlayerSignals;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class ResetNormal  implements IReset
	{
		/** 单例对像 */
		private static var _instance : ResetNormal;

		/** 获取单例对像 */
		public static function get instance() : ResetNormal
		{
			if (_instance == null)
			{
				_instance = new ResetNormal();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		protected var playerControl : PlayerControl = PlayerControl.instance;
		protected var selfManager : SelfManager = SelfManager.instance;

		public function ResetNormal()
		{
		}

		/** 卸载 */
		public function uninstall() : void
		{
			MapSignals.enableMouseWalk.dispatch(false);
			MapSignals.scorllBindSelf.dispatch(false);
			
			MapSignals.receiveMapInfoStart.remove(removeSignals);
			NpcSignals.removeAll.dispatch();
			playerControl.uninstallSelf();
			playerControl.unstallOtherPlayers();
			playerControl.setMoudle(null);
		}

		/** 开始安装 */
		public function startInstall() : void
		{
			MapSignals.receiveMapInfoStart.add(removeSignals);
			NpcSignals.startInstall.dispatch();
			addSignals();
			playerControl.setMoudle(this);
			playerControl.installSelf();
			playerControl.installOtherPlayers();
			
			MapSignals.enableMouseWalk.dispatch(true);
			MapSignals.scorllBindSelf.dispatch(true);
		}

		/** 添加监听信息 */
		protected function addSignals() : void
		{
			PlayerSignals.selfWaitInstall.add(playerControl.installSelf);
			PlayerSignals.playerWaitInstalled.add(playerControl.installPlayer);
			PlayerSignals.playerLeave.add(playerControl.uninstallPlayer);
			PlayerSignals.walkTo.add(playerControl.playerWalk);
			PlayerSignals.transportTo.add(playerControl.playerTransport);
			PlayerSignals.changeCloth.add(playerControl.changeCloth);
			PlayerSignals.changeRide.add(playerControl.changeRide);
			PlayerSignals.sitDown.add(playerControl.sitDown);
			PlayerSignals.sitUp.add(playerControl.sitUp);
		}

		/** 移除监听信息 */
		protected function removeSignals() : void
		{
			PlayerSignals.selfWaitInstall.remove(playerControl.installSelf);
			PlayerSignals.playerWaitInstalled.remove(playerControl.installPlayer);
			PlayerSignals.playerLeave.remove(playerControl.uninstallPlayer);
			PlayerSignals.walkTo.remove(playerControl.playerWalk);
			PlayerSignals.transportTo.remove(playerControl.playerTransport);
			PlayerSignals.changeCloth.remove(playerControl.changeCloth);
			PlayerSignals.changeRide.remove(playerControl.changeRide);
			PlayerSignals.sitDown.remove(playerControl.sitDown);
			PlayerSignals.sitUp.remove(playerControl.sitUp);
		}

		/** 初始化玩家model状态 */
		public function initPlayerModel(playerId : int, model : int) : void
		{
			if (Model.isPractice(model))
			{
				PlayerSignals.sitDown.dispatch(playerId);
			}
		}
	}
}