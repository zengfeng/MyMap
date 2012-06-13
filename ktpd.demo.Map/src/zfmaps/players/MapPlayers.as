package zfmaps.players
{
	import com.utils.PotentialColorUtils;

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import game.net.data.StoC.SCAvatarInfo.PlayerAvatar;
	import game.net.data.StoC.SCAvatarInfoChange;
	import game.net.data.StoC.SCMultiAvatarInfoChange;
	import game.net.data.StoC.SCPlayerWalk;
	import game.net.data.StoC.SCTransport;

	import zfmaps.MapSignals;
	import zfmaps.MapStartup;
	import zfmaps.structs.PlayerStruct;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-23
	 */
	public class MapPlayers
	{
		/** 单例对像 */
		private static var _instance : MapPlayers;

		/** 获取单例对像 */
		static public function get instance() : MapPlayers
		{
			if (_instance == null)
			{
				_instance = new MapPlayers(new Singleton());
			}
			return _instance;
		}

		function MapPlayers(singleton : Singleton) : void
		{
			singleton;
			selfId = MapStartup.userId;
			MapSignals.receiveMapInfoStart.add(clear);
			PlayerSignals.selfInstalled.add(setSelfInstalled);
			PlayerSignals.playerInstalled.add(setPlayerInstalled);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var selfId : int;
		private var _self : PlayerStruct;
		private var _selfInstalled : Boolean;
		public var dic : Dictionary = new Dictionary();
		public var waitInstallDic : Dictionary = new Dictionary();
		public var waitInstallInfoNewestList : Vector.<PlayerStruct> = new Vector.<PlayerStruct>();
		private var keyArr : Array = [];

		public function clear() : void
		{
			_self = null;
			_selfInstalled = false;
			var key : String;
			// 全部
			for (key  in dic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				key = keyArr.pop();
				dic[key] = null;
				delete dic[key];
			}
			// 等待安装
			for (key  in waitInstallDic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				key = keyArr.pop();
				waitInstallDic[key] = null;
				delete waitInstallDic[key];
			}
			// 等待安装信息最新的
			while (waitInstallInfoNewestList.length > 0)
			{
				waitInstallInfoNewestList.pop();
			}
		}

		// =====================
		// 自己玩家
		// =====================
		public function get hasSelf() : Boolean
		{
			return _self != null;
		}

		public function get selfInfoNewest() : Boolean
		{
			return _self.isNewestAvatar;
		}

		public function get selfInstalled() : Boolean
		{
			return _selfInstalled;
		}

		public function setSelfInstalled() : void
		{
			_selfInstalled = true;
		}

		public function get self() : PlayerStruct
		{
			return _self;
		}

		public function set self(playerStruct : PlayerStruct) : void
		{
			_self = playerStruct;
			selfId = playerStruct.id;
			dispatchSelfWaitInstall();
		}

		public function dispatchSelfWaitInstall() : void
		{
			if (selfInfoNewest && selfInstalled == false)
			{
				PlayerSignals.selfWaitInstall.dispatch();
			}
		}

		// ========================
		// 其他玩家
		// ========================
		public function getPlayer(playerId : int) : PlayerStruct
		{
			if (playerId == selfId) return self;
			return dic[playerId];
		}

		private function isInstalled(playerId : int) : Boolean
		{
			if (playerId == selfId) return _selfInstalled;
			return dic[playerId] && !waitInstallDic[playerId];
		}

		public function addWaitInstall(playerStruct : PlayerStruct) : void
		{
			if (playerStruct == null || playerStruct.id == selfId) return;
			dic[playerStruct.id] = playerStruct;
			waitInstallDic[playerStruct.id] = playerStruct;
			setWaitInstallPlayerNewest(playerStruct);
		}

		public function setPlayerInstalled(playerStruct : PlayerStruct) : void
		{
			if (playerStruct == null || playerStruct.id == selfId) return;
			delete waitInstallDic[playerStruct.id];
			var index : int = waitInstallInfoNewestList.indexOf(playerStruct);
			if (index != -1)
			{
				waitInstallInfoNewestList.splice(index, 1);
			}
		}

		private function setWaitInstallPlayerNewest(playerStruct : PlayerStruct) : void
		{
			if (playerStruct.isNewestAvatar == false) return;
			if (isInstalled(playerStruct.id)) return;
			var index : int = waitInstallInfoNewestList.indexOf(playerStruct);
			if (index == -1)
			{
				waitInstallInfoNewestList.push(playerStruct);
			}
			PlayerSignals.playerWaitInstalled.dispatch(playerStruct);
		}

		public function playerLeave(playerId : int) : void
		{
			var playerStruct : PlayerStruct = getPlayer(playerId);
			if (playerStruct == null || playerStruct.id == selfId) return;
			if (isInstalled(playerId))
			{
				delete dic[playerId];
				PlayerSignals.playerLeave.dispatch(playerId);
				return;
			}
			delete dic[playerId];
			delete waitInstallDic[playerId];
			var index : int = waitInstallInfoNewestList.indexOf(playerStruct);
			if (index != -1)
			{
				waitInstallInfoNewestList.splice(index, 1);
			}
		}

		public function sc_playerAvatarInfoInit(msg : PlayerAvatar) : void
		{
			var playerStruct : PlayerStruct = getPlayer(msg.id);
			if (playerStruct == null) return;
			playerStruct.name = msg.name;
			playerStruct.potential = msg.job >> 4;
			playerStruct.heroId = msg.job & 0xF;
			playerStruct.level = msg.level;
			playerStruct.clothId = msg.cloth;
			playerStruct.rideId = msg.ride;
			playerStruct.avatarVer = msg.avatarVer;
			playerStruct.newAvatarVer = msg.avatarVer;
			playerStruct.color = PotentialColorUtils.getColor(playerStruct.potential);
			playerStruct.colorStr = PotentialColorUtils.getColorOfStr(playerStruct.potential);

			if (playerStruct.id != selfId)
			{
				setWaitInstallPlayerNewest(playerStruct);
			}
			else
			{
				dispatchSelfWaitInstall();
			}
		}

		public function sc_playerAvatarInfoChange(msg : SCAvatarInfoChange) : void
		{
			var playerStruct : PlayerStruct = getPlayer(msg.id);
			if (playerStruct == null) return;

			var preModel : int = playerStruct.model;
			if (msg.hasCloth) playerStruct.clothId = msg.cloth;
			if (msg.hasLevel) playerStruct.level = msg.level;
			if (msg.hasRide) playerStruct.rideId = msg.ride;
			playerStruct.avatarVer = msg.avatarVer & 0x1F;
			playerStruct.model = msg.avatarVer >> 5;
			playerStruct.newAvatarVer = playerStruct.avatarVer;

			if (isInstalled(playerStruct.id))
			{
				var playerId : int = playerStruct.id;
				if (msg.hasCloth) PlayerSignals.changeCloth.dispatch(playerId, playerStruct.clothId);
				if (msg.hasRide) PlayerSignals.changeRide.dispatch(playerId, playerStruct.rideId);

				var model : int = playerStruct.model;
				if (model == preModel)
				{
					trace(playerStruct.name + "事可真多呀，model又在打酱油");
				}
				else if (Model.isNormal(model))
				{
					if (Model.isPractice(preModel))
					{
						PlayerSignals.sitUp.dispatch(playerId);
					}
					else if (Model.isConvory(preModel))
					{
						PlayerSignals.MODEL_CONVOY_OUT.dispatch(playerId);
					}
					else if (Model.isFishing(preModel))
					{
						PlayerSignals.MODEL_FEAST_OUT.dispatch(playerId);
					}
				}
				else if (Model.isPractice(model))
				{
					PlayerSignals.sitDown.dispatch(playerId);
				}
				else if (Model.isConvory(model))
				{
					if (Model.isNormal(preModel) || Model.isPractice(preModel))
					{
						PlayerSignals.MODEL_CONVOY_IN.dispatch(playerId, model);
					}
					else if (Model.isConvory(preModel))
					{
						PlayerSignals.MODEL_CONVOY_SPEED.dispatch(playerId, model);
					}
					else
					{
						throw new Error(playerStruct.name + "龟拜模式坑爹，是不是没退出其他模式就去龟拜了！！！");
					}
				}
				else if (Model.isFishing(model))
				{
					if (Model.isNormal(preModel) || Model.isPractice(preModel))
					{
						PlayerSignals.MODEL_FISHING_IN.dispatch(playerId);
					}
					else
					{
						throw new Error(playerStruct.name + "钓鱼模式坑爹，是不是没退出其他模式就去钓鱼了！！！");
					}
				}
			}
		}

		public function sc_multipleAvatarInfoChange(msg : SCMultiAvatarInfoChange) : void
		{
		}

		public function sc_playerWalk(msg : SCPlayerWalk) : void
		{
			var playerStruct : PlayerStruct = getPlayer(msg.playerId);
			if (playerStruct == null) return;
			playerStruct.walking = true;
			playerStruct.walkTime = getTimer();
			playerStruct.toX = msg.xy & 0x3FFF;
			playerStruct.toY = msg.xy >> 14;
			if (msg.hasFromXY)
			{
				playerStruct.fromX = msg.fromXY & 0x3FFF;
				playerStruct.fromY = msg.fromXY >> 14;
			}

			if (isInstalled(playerStruct.id))
			{
				PlayerSignals.walkTo.dispatch(playerStruct.id, playerStruct.toX, playerStruct.toY, msg.hasFromXY, playerStruct.fromX, playerStruct.fromY);
			}
		}

		public function sc_playerTransport(msg : SCTransport) : void
		{
			var playerStruct : PlayerStruct;
			playerStruct = getPlayer(msg.playerId);
			if (playerStruct == null) return;
			playerStruct.walking = false;
			playerStruct.walkTime = 0;
			playerStruct.x = msg.myXy & 0x3FFF;
			playerStruct.y = msg.myXy >> 14;

			if (isInstalled(playerStruct.id))
			{
				PlayerSignals.transportTo.dispatch(playerStruct.id, playerStruct.x, playerStruct.y);
			}
		}
	}
}
class Singleton
{
}