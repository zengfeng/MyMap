package unittests
{
	import zfmaps.MapSignals;
	import zfmaps.MapTo;

	import unittests.protos.ChangeMap;
	import unittests.protos.PlayerProto;

	import zfmaps.MapProto;
	import zfmaps.MapStartup;
	import zfmaps.auxiliarys.MapStage;
	import zfmaps.layers.LayerContainer;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class Test_2_EnterMap extends Test_1_MapStartUp
	{
		public var mapId : int = 1;
		public var selfInitX : int = 1776;
		public var selfInitY : int = 1376;
		public var mapProto : MapProto = MapProto.instance;

		public function Test_2_EnterMap()
		{
			loginMapId = mapId;
			super();
			MapStartup.signalComplete.add(mapStartupComplete);
		}

		public function mapStartupComplete() : void
		{
			mapX = selfInitX;
			mapY = selfInitY;
			resetMap();
			MapStage.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			// MapSignals.mouseWalkTo.add(layerContainer.setPosition);
		}

		public function resetMap() : void
		{
			// MapControl.instance.reset(mapId, mapX, mapY);
		}

		private  var mapX : int = 0;
		private  var mapY : int = 0;
		private  var speedX : int = 0;
		private  var speedY : int = 0;
		private  var speed : int = 4;

		public  function onKeyDown(event : KeyboardEvent) : void
		{
			if (event.ctrlKey == true)
			{
				if (event.keyCode >= Keyboard.NUMBER_0 && event.keyCode <= Keyboard.NUMBER_9)
				{
					mapId = parseInt(String.fromCharCode(event.keyCode));
					if (mapId == 5) mapId = 20;
					if (mapId == 6) mapId = 301;
					// resetMap();
				}
			}

			if (event.shiftKey == true)
			{
				if (event.keyCode >= Keyboard.NUMBER_0 && event.keyCode <= Keyboard.NUMBER_9)
				{
					playerId = parseInt(String.fromCharCode(event.keyCode)) * 100;
				}
			}

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
				case Keyboard.T:
					transport();
					break;
				case Keyboard.C:
					changeCloth();
					break;
				case Keyboard.R:
					changeRide();
					break;
				case Keyboard.S:
					isSitDown = !isSitDown;
					if (isSitDown)
					{
						playerSitDown();
					}
					else
					{
						playerSitUp();
					}
					break;
				case Keyboard.F1:
					convoyIn();
					break;
				case Keyboard.F2:
					convoyOut();
					break;
				case Keyboard.F3:
					convoyChangeSpeed();
					break;
				case Keyboard.N:
					npcVisible();
					break;
				case Keyboard.M:
					mapTo();
					break;
			}

			if (event.keyCode == Keyboard.LEFT)
			{
				speedX = -speed;
			}

			if (event.keyCode == Keyboard.RIGHT)
			{
				speedX = speed;
			}

			if (event.keyCode == Keyboard.UP)
			{
				speedY = -speed;
			}

			if (event.keyCode == Keyboard.DOWN)
			{
				speedY = speed;
			}

			if (event.keyCode == Keyboard.SPACE)
			{
				speedX = 0;
				speedY = 0;
			}

			if (speedX != 0 || speedY != 0)
			{
				MapStage.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				MapStage.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		protected var layerContainer : LayerContainer = LayerContainer.instance;

		private  function onEnterFrame(event : Event) : void
		{
			mapX = -layerContainer.container.x + speedX;
			mapY = -layerContainer.container.y + speedY;
			layerContainer.updatePosition(mapX, mapY);
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

		public function transport() : void
		{
			PlayerProto.transport(playerId, 1296, 1392);
		}

		private var clothId : int = 0;

		public function changeCloth() : void
		{
			PlayerProto.changeCloth(playerId, clothId);
			clothId++;
			if (clothId >= 3) clothId = 0;
		}

		private var rideId : int = 1;

		public function changeRide() : void
		{
			PlayerProto.changeRide(playerId, rideId);
			if (rideId == 0)
			{
				rideId = 1;
			}
			else if (rideId == 1)
			{
				rideId = 25;
			}
			else
			{
				rideId = 0;
			}
		}

		private var isSitDown : Boolean = false;

		public function playerSitDown() : void
		{
			PlayerProto.sitDown(playerId);
		}

		public function playerSitUp() : void
		{
			PlayerProto.sitUp(playerId);
		}

		public function convoyIn() : void
		{
			PlayerProto.convoyIn(playerId);
		}

		public function convoyOut() : void
		{
			PlayerProto.convoyOut(playerId);
		}

		private var isFast : Boolean = false;

		public function convoyChangeSpeed() : void
		{
			isFast = !isFast;
			PlayerProto.convoyChangeSpeed(playerId, isFast);
		}

		private var nnpcVisible : Boolean = false;

		public function npcVisible() : void
		{
			PlayerProto.npcVisible(nnpcVisible);
			nnpcVisible = !nnpcVisible;
		}

		public function mapTo() : void
		{
			MapSignals.sendTransportTo.add(sendTransportTo);
//			MapTo.instance.toMap(1776, 1476, 0, null, null, 30, true);
			MapTo.instance.toMap(1776, 1276, 2, null, null, 30, false);
//			MapTo.instance.toMap(1776, 1476, 2, null, null, 300, false);
		}

		public function sendTransportTo(toX : int, toY : int, toMapId : int) : void
		{
			if (toMapId != mapId && toMapId != 0)
			{
				ChangeMap.send(toMapId);
			}
			else
			{
				PlayerProto.transport(userId, toX, toY);
			}
		}
	}
}
