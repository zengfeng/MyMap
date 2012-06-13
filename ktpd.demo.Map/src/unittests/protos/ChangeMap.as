package unittests.protos
{
	import game.net.data.StoC.PlayerPosition;
	import game.net.data.StoC.SCAvatarInfo;
	import game.net.data.StoC.SCAvatarInfo.PlayerAvatar;
	import game.net.data.StoC.SCCityPlayers;

	import zfmaps.MapProto;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// ============================
	public class ChangeMap
	{
		public static var mapPorto : MapProto = MapProto.instance;
		public static var mapId : int = 1;

		public static function send(mapId : int) : void
		{
			ChangeMap.mapId = mapId;
			var mapMsg : SCCityPlayers;
			if (mapId == 1)
			{
				mapMsg = getMap1();
			}
			else
			{
				mapMsg = getMap1();
			}
			sendPositions(mapMsg);
			sendAvatars();
			// setTimeout(sendAvatars, 5000);
		}
		

		public static function sendPositions(msg : SCCityPlayers) : void
		{
			mapPorto.sc_changeMap(msg);
		}

		public static function sendAvatars() : void
		{
			var msg : SCAvatarInfo = new SCAvatarInfo();
			msg.players.push(getPlayerAvatarInfo(selfId));
			for (var i : int = playerIdStart;i < playerIdEnd; i++)
			{
				msg.players.push(getPlayerAvatarInfo(i));
			}
			mapPorto.sc_playerAvatarInfo(msg);
		}

		public static function getMap1() : SCCityPlayers
		{
			var msg : SCCityPlayers = new SCCityPlayers();
			msg.cityId = ChangeMap.mapId;
			msg.myX = 1776;
			msg.myY = 1376;
			msg.model = 0;
			if (ChangeMap.mapId == 1)
			{
				msg.npcId.push(1);
				msg.npcId.push(3);
				msg.npcId.push(5);
				msg.npcId.push(16);
				msg.npcId.push(17);
				msg.npcId.push(18);
				msg.npcId.push(21);
				msg.npcId.push(22);
				msg.npcId.push(23);
				msg.npcId.push(26);
				msg.npcId.push(34);
			}

			for (var i : int = playerIdStart;i < playerIdEnd; i++)
			{
				msg.players.push(getPlayerPosition(i));
			}

			return msg;
		}

		public static var selfId : int = 1;
		public static var playerIdStart : int = 100;
		public static var playerIdEnd : int = 100;
		public static var playerIdList : Vector.<uint> = new Vector.<uint>();

		public static function getPlayerPosition(playerId : int) : PlayerPosition
		{
			var mapWidth : int = 5888;
			var mapHeight : int = 4864;
			var playerPosition : PlayerPosition = new PlayerPosition();
			playerPosition.playerId = playerId;
			var x : int = Math.random() * mapWidth;
			var y : int = Math.random() * mapHeight;
			playerPosition.xy = ( y << 14) | x;
			var  isWalking : Boolean = Math.random() > 0.02;
			if (isWalking)
			{
				playerPosition.when = Math.random() * 500;

				var toX : int = Math.random() * mapWidth;
				var toY : int = Math.random() * mapHeight;
				playerPosition.toXy = ( toY << 14) | toX;
			}
			var model : int = isWalking ? 0 : (Math.random() > 0.3 ? 20 : 0);
			playerPosition.avatarVer = (model << 5) | 1;
			return playerPosition;
		}

		public static function getPlayerAvatarInfo(playerId : int) : PlayerAvatar
		{
			var playerAvatar : PlayerAvatar = new PlayerAvatar();
			playerAvatar.id = playerId;
			playerAvatar.name = "玩家" + playerId;
			playerAvatar.avatarVer = 1;
			var heroId : int = Math.random() * 5 + 1;
			var potential : int = Math.random() * 5 + 1;
			playerAvatar.job = (potential << 4) | heroId;
			playerAvatar.level = Math.random() * 100;
			playerAvatar.cloth = Math.random() * 2;
			playerAvatar.ride = Math.random() < 0.9 ? 0 : (Math.random() > 0.5 ? 1 : 25);
			if (playerId == selfId)
			{
				playerAvatar.ride = 0;
				playerAvatar.cloth = 1;
			}
			return playerAvatar;
		}
	}
}
