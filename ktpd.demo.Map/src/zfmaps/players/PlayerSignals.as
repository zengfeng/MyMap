package zfmaps.players
{
	import com.signalbus.Signal;
	import zfmaps.structs.PlayerStruct;


	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-23
	 */
	public class PlayerSignals
	{
		// =================
		// 进入&离开
		// =================
		/** 自己玩家等待安装 */
		public static const selfWaitInstall : Signal = new Signal(PlayerStruct);
		/** 自己玩家安装完成 */
		public static const selfInstalled : Signal = new Signal(PlayerStruct);
		/** 玩家获得最新信息等待安装  */
		public static const playerWaitInstalled : Signal = new Signal(PlayerStruct);
		/** 玩家安装完成  */
		public static const playerInstalled : Signal = new Signal(PlayerStruct);
		/** 玩家离开 args=[playerId]  */
		public static const playerLeave : Signal = new Signal(int);
		// =================
		// 基本属性改变
		// =================
		/** 玩家走路 args = [playerId:int, toX:int, toY:int, hasFrom:Boolean, fromX:int, fromY:int] */
		public static const walkTo : Signal = new Signal(int, int, int, Boolean, int, int);
		/** 玩家传送 args = [playerId:int, toX:int, toY:int]*/
		public static const transportTo : Signal = new Signal(int, int, int);
		/** 玩家换衣服 args =[playerId, clothId] */
		public static const changeCloth : Signal = new Signal(int, int);
		/** 玩家换衣服 args =[playerId, rideId] */
		public static const changeRide : Signal = new Signal(int, int);
		// =================
		// 模式
		// =================
		/** 打座进入 args=[playerId] */
		public static const sitDown : Signal = new Signal(uint);
		/** 打座退出 args=[playerId] */
		public static const sitUp : Signal = new Signal(uint);
		// -----------------------------
		/** 龟仙拜佛进入 args=[playerId, quality] */
		public static const MODEL_CONVOY_IN : Signal = new Signal(uint, uint);
		/** 龟仙拜佛退出 args=[playerId] */
		public static const MODEL_CONVOY_OUT : Signal = new Signal(uint);
		/** 龟仙拜佛速度改变 args=[playerId, speedModel] */
		public static const MODEL_CONVOY_SPEED : Signal = new Signal(uint, uint);
		// -----------------------------
		/** 钓鱼进入 args=[playerId] */
		public static const MODEL_FISHING_IN : Signal = new Signal(uint);
		/** 钓鱼退出 args=[playerId] */
		public static const MODEL_FISHING_OUT : Signal = new Signal(uint);
		// -----------------------------
		/** 派对进入 args=[playerId, status] */
		public static const MODEL_FEAST_IN : Signal = new Signal(uint, uint);
		/** 派对退出 args=[playerId] */
		public static const MODEL_FEAST_OUT : Signal = new Signal(uint);
		/** 派对状态改变 args=[playerId, state] */
		public static const MODEL_FEAST_STATE : Signal = new Signal(uint, uint);
	}
}
