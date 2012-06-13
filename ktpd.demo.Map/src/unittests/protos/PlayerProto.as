package unittests.protos
{
	import game.net.data.StoC.PlayerPosition;
	import game.net.data.StoC.SCAvatarInfo;
	import game.net.data.StoC.SCAvatarInfo.PlayerAvatar;
	import game.net.data.StoC.SCAvatarInfoChange;
	import game.net.data.StoC.SCCityEnter;
	import game.net.data.StoC.SCCityLeave;
	import game.net.data.StoC.SCNPCReaction;
	import game.net.data.StoC.SCPlayerWalk;
	import game.net.data.StoC.SCTransport;

	import zfmaps.MapProto;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	// ============================
	public class PlayerProto
	{
		public static var mapPorto : MapProto = MapProto.instance;
		public static var playerId : int = 100;

		public static function enter(id : int = 100) : void
		{
			PlayerProto.playerId = id ;
			var msg : SCCityEnter = new SCCityEnter();
			msg.playerPos = getPlayerPosition(playerId);
			mapPorto.sc_playerEnter(msg);
		}

		public static function sentAvatarInfoInit(playerId : int) : void
		{
			var msg : SCAvatarInfo = new SCAvatarInfo();
			var playerAvatar : PlayerAvatar = initAvatarInfo(playerId);
			msg.players.push(playerAvatar);
			mapPorto.sc_playerAvatarInfo(msg);
		}

		private static function getPlayerPosition(playerId : int) : PlayerPosition
		{
			var playerPosition : PlayerPosition = new PlayerPosition();
			playerPosition.playerId = playerId;
			var x : int = 1776;
			var y : int = 1376;
			playerPosition.xy = ( y << 14) | x;
			var  isWalking : Boolean = false;
			if (isWalking)
			{
				playerPosition.when = Math.random() * 500;

				var toX : int = 0;
				var toY : int = 0;
				playerPosition.toXy = ( toY << 14) | toX;
			}
			var model : int = 20;
			playerPosition.avatarVer = (model << 5) | 1;
			return playerPosition;
		}

		private static function initAvatarInfo(playerId : int) : PlayerAvatar
		{
			var playerAvatar : PlayerAvatar = new PlayerAvatar();
			playerAvatar.id = playerId;
			playerAvatar.name = "玩家" + playerId;
			playerAvatar.avatarVer = 1;
			var heroId : int = Math.random() * 5 + 1;
			var potential : int = Math.random() * 5 + 1;
			playerAvatar.job = (potential << 4) | heroId;
			playerAvatar.level = Math.random() * 100;
			playerAvatar.cloth = 1;
			playerAvatar.ride = 0;
			return playerAvatar;
		}

		public static function leave(playerId : int) : void
		{
			var msg : SCCityLeave = new SCCityLeave();
			msg.playerId = playerId;
			mapPorto.sc_playerLeave(msg);
		}

		public static function walk(playerId : int, toX : int, toY : int, hasFrom : Boolean, fromX : int, fromY : int) : void
		{
			var msg : SCPlayerWalk = new SCPlayerWalk() ;
			msg.playerId = playerId;
			msg.xy = (toY << 14) | toX;
			if (hasFrom)
			{
				msg.fromXY = (fromY << 14) | fromX;
			}
			mapPorto.sc_playerWalk(msg);
		}

		public static function transport(playerId : int, toX : int, toY : int) : void
		{
			var msg : SCTransport = new SCTransport();
			msg.playerId = playerId;
			msg.myXy = (toY << 14) | toX;
			mapPorto.sc_transport(msg);
		}

		public static function sitDown(playerId : int) : void
		{
			var msg : SCAvatarInfoChange = new SCAvatarInfoChange();
			msg.id = playerId;
			var avatarVar : int = 3;
			var model : int = 20;
			msg.avatarVer = (model << 5) | avatarVar;
			mapPorto.sc_playerAvatarInfoChange(msg);
		}

		public static function sitUp(playerId : int) : void
		{
			var msg : SCAvatarInfoChange = new SCAvatarInfoChange();
			msg.id = playerId;
			var avatarVar : int = 3;
			var model : int = 0;
			msg.avatarVer = (model << 5) | avatarVar;
			mapPorto.sc_playerAvatarInfoChange(msg);
		}

		public static function changeCloth(playerId : int, clothId : int) : void
		{
			var msg : SCAvatarInfoChange = new SCAvatarInfoChange();
			msg.id = playerId;
			msg.cloth = clothId;
			var avatarVar : int = 3;
			var model : int = 0;
			msg.avatarVer = (model << 5) | avatarVar;
			mapPorto.sc_playerAvatarInfoChange(msg);
		}

		public static function changeRide(playerId : int, rideId : int) : void
		{
			var msg : SCAvatarInfoChange = new SCAvatarInfoChange();
			msg.id = playerId;
			msg.ride = rideId;
			var avatarVar : int = 3;
			var model : int = 0;
			msg.avatarVer = (model << 5) | avatarVar;
			mapPorto.sc_playerAvatarInfoChange(msg);
		}
		
		public static function convoyIn(playerId:int):void
		{
			var msg : SCAvatarInfoChange = new SCAvatarInfoChange();
			msg.id = playerId;
			var avatarVar : int = 3;
			var model : int = 1;
			msg.avatarVer = (model << 5) | avatarVar;
			mapPorto.sc_playerAvatarInfoChange(msg);
		}
		
		public static function convoyOut(playerId:int):void
		{
			var msg : SCAvatarInfoChange = new SCAvatarInfoChange();
			msg.id = playerId;
			var avatarVar : int = 3;
			var model : int = 0;
			msg.avatarVer = (model << 5) | avatarVar;
			mapPorto.sc_playerAvatarInfoChange(msg);
		}
		
		public static function convoyChangeSpeed(playerId:int, isFast:Boolean):void
		{
			var msg : SCAvatarInfoChange = new SCAvatarInfoChange();
			msg.id = playerId;
			var avatarVar : int = 3;
			var model : int = isFast ? 5 : 1;
			msg.avatarVer = (model << 5) | avatarVar;
			mapPorto.sc_playerAvatarInfoChange(msg);
		}
		
		public static function npcVisible(visible:Boolean):void
		{
			var msg : SCNPCReaction = new SCNPCReaction();
			msg.npcId = 1;
			msg.reactionId = visible ? 1 : 0;
			mapPorto.sc_setNpcVisible(msg);
		}
		
		
	}
}
