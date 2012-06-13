package unittests
{
	import zfmaps.players.PlayerControl;
	import zfmaps.roles.cores.Player;

	import unittests.protos.ChangeMap;
	import unittests.protos.PlayerProto;

	import zfmaps.MapStartup;
	import zfmaps.auxiliarys.MapStage;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class Test_7_AINpc extends Test_1_MapStartUp
	{
		public var mapId : int = 1;
		public var selfInitX : int = 1776;
		public var selfInitY : int = 1376;

		function Test_7_AINpc() : void
		{
			loginMapId = mapId;
			super();
			MapStartup.signalComplete.add(mapStartupComplete);
		}

		public function mapStartupComplete() : void
		{
			MapStage.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		public  function onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.E:
					ChangeMap.send(mapId);
					break;
				case Keyboard.A:
					playerEnter();
					break;
				case Keyboard.I:
					sendPlayerAvatarInfoInit();
					break;
				case Keyboard.L:
					playerLeave();
					break;
				case Keyboard.W:
					playerWalk();
					break;
				case Keyboard.Y:
					walkHasFrom = !walkHasFrom;
					trace(walkHasFrom);
					break;
				case Keyboard.U:
					playerId = userId;
					trace(playerId);
					break;
				case Keyboard.F1:
					wander();
					break;
				case Keyboard.F2:
					pauseWander();
					break;
				case Keyboard.F3:
					playWander();
					break;
				case Keyboard.F4:
					cancelWander();
					break;
				// ///////////////////
				case Keyboard.F5:
					radar();
					break;
				case Keyboard.F6:
					pauseRadar();
					break;
				case Keyboard.F7:
					playRadar();
					break;
				case Keyboard.F8:
					cancelRadar();
					break;
				case Keyboard.F9:
					setAI();
					break;
			}

			if (event.ctrlKey == true)
			{
				if (event.keyCode >= Keyboard.NUMBER_0 && event.keyCode <= Keyboard.NUMBER_9)
				{
					mapId = parseInt(String.fromCharCode(event.keyCode));
					if (mapId == 5) mapId = 20;
					if (mapId == 6) mapId = 301;
				}
			}

			if (event.shiftKey == true)
			{
				if (event.keyCode >= Keyboard.NUMBER_0 && event.keyCode <= Keyboard.NUMBER_9)
				{
					playerId = parseInt(String.fromCharCode(event.keyCode)) * 100;
				}
			}
		}

		public var playerId : int = 200;

		public function playerEnter() : void
		{
			PlayerProto.enter(playerId);
		}

		public function sendPlayerAvatarInfoInit() : void
		{
			PlayerProto.sentAvatarInfoInit(playerId);
		}

		public function playerLeave() : void
		{
			PlayerProto.leave(playerId);
		}

		public var positions : Array = [[1568, 1424], [1664, 1232], [2032, 1344], [2016, 1552]];
		public var walkPointIndex : int = 0;
		public var walkHasFrom : Boolean;

		public function playerWalk() : void
		{
			var fromIndex : int = walkPointIndex - 1;
			var arr : Array = positions[walkPointIndex];
			var toX : int = arr[0];
			var toY : int = arr[1];
			var fromX : int ;
			var fromY : int ;
			if (fromIndex > 0)
			{
				arr = positions[fromIndex];
				fromX = arr[0];
				fromY = arr[1];
			}
			else
			{
				fromX = 1776;
				fromY = 1376;
			}
			trace("fromX, fromY", fromX, fromY);
			// var fromX : int = 1776 + Math.random() * 200 * (Math.random()  > 0.5 ? 1 : -1);
			// var fromY : int = 1376 + Math.random() * 200 * (Math.random()  > 0.5 ? 1 : -1);
			PlayerProto.walk(playerId, toX, toY, walkHasFrom, fromX, fromY);
			walkPointIndex++;
			if (walkPointIndex >= positions.length ) walkPointIndex = 0;
		}

		// ============================
		// 漫游
		// ============================
		public function wander() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			player.wander();
		}

		public function pauseWander() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			player.pauseWander();
		}

		public function playWander() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			player.playWander();
		}

		public function cancelWander() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			player.cancelWander();
		}

		// ============================
		// 扫描敌人
		// ============================
		public function radar() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			var self : Player = PlayerControl.instance.getPlayer(1);
			player.radar(self);
		}

		public function pauseRadar() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			player.pauseRadar();
		}

		public function playRadar() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			player.playRadar();
		}

		public function cancelRadar() : void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			player.cancelRadar();
		}
		
		// ============================
		// 简单AI
		// ============================
		public function setAI():void
		{
			var player : Player = PlayerControl.instance.getPlayer(playerId);
			var self : Player = PlayerControl.instance.getPlayer(1);
			player.startupAI(self);
		}
	}
}
