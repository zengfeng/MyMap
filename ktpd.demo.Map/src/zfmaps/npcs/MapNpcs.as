package zfmaps.npcs
{
	import zfmaps.MapSignals;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-23
	 */
	public class MapNpcs
	{
		/** 单例对像 */
		private static var _instance : MapNpcs;

		/** 获取单例对像 */
		static public function get instance() : MapNpcs
		{
			if (_instance == null)
			{
				_instance = new MapNpcs(new Singleton());
			}
			return _instance;
		}

		function MapNpcs(singleton : Singleton) : void
		{
			singleton;
			MapSignals.receiveMapInfoStart.add(clear);
			NpcSignals.installed.add(setInstalled);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var list : Vector.<uint> = new Vector.<uint>();
		public var waitInstallList : Vector.<uint> = new Vector.<uint>();

		/** 清理 */
		private function clear() : void
		{
			NpcSignals.stopInstall.dispatch();
			while (list.length > 0)
			{
				list.pop();
			}
			while (waitInstallList.length > 0)
			{
				waitInstallList.pop();
			}
		}

		/** 添加 */
		public function add(npcId : int) : void
		{
			var index : int = list.indexOf(npcId);
			if (index == -1)
			{
				list.push(npcId);
			}
			index = waitInstallList.indexOf(npcId);
			if (index == -1)
			{
				waitInstallList.push(npcId);
				NpcSignals.add.dispatch(npcId);
			}
		}

		/** 移除 */
		public function remove(npcId : int) : void
		{
			var index : int = list.indexOf(npcId);
			if (index != -1)
			{
				list.splice(index, 1);
			}
			index = waitInstallList.indexOf(npcId);
			if (index != -1)
			{
				waitInstallList.splice(index, 1);
			}

			NpcSignals.remove.dispatch(npcId);
		}

		/** 设置安装完成 */
		public function setInstalled(npcId : int) : void
		{
			var index : int = waitInstallList.indexOf(npcId);
			if (index != -1)
			{
				waitInstallList.splice(index, 1);
			}
		}

		/** 是否安装完成 */
		public function isInstalled(npcId : int) : Boolean
		{
			return list.indexOf(npcId) != -1 && waitInstallList.indexOf(npcId) == -1;
		}

		/** 是否有等待安装的 */
		public function hasWaitInstall() : Boolean
		{
			return waitInstallList.length > 0;
		}
	}
}
class Singleton
{
}