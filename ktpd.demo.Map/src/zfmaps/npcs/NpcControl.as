package zfmaps.npcs
{
	import flash.utils.Dictionary;
	import zfmaps.auxiliarys.MapUtil;
	import zfmaps.roles.RoleFactory;
	import zfmaps.roles.cores.Role;
	import zfmaps.structs.NpcStruct;





	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-24
	 */
	public class NpcControl
	{
		/** 单例对像 */
		private static var _instance : NpcControl;

		/** 获取单例对像 */
		static public function get instance() : NpcControl
		{
			if (_instance == null)
			{
				_instance = new NpcControl(new Singleton());
			}
			return _instance;
		}

		function NpcControl(singleton : Singleton) : void
		{
			singleton;
			dic = new Dictionary();
			mapNpcs = MapNpcs.instance;
			roleFactory = RoleFactory.instance;
			NpcSignals.startInstall.add(startInstall);
			NpcSignals.stopInstall.add(stopInstall);
			NpcSignals.remove.add(remove);
			NpcSignals.removeAll.add(removeAll);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var dic : Dictionary;
		private var mapNpcs : MapNpcs;
		private var roleFactory:RoleFactory;

		/** 添加 */
		public function add(npcId : int) : void
		{
			var struct : NpcStruct = MapUtil.getNpcStruct(npcId);
			if (struct == null)
			{
				return;
			}
			var role : Role = roleFactory.makeNpc(npcId);
			role.initPosition(struct.x, struct.y, struct.speed);
			dic[npcId] = role;
			NpcSignals.installed.dispatch(npcId);
		}

		/** 移除 */
		public function remove(npcId : int) : void
		{
			var role : Role = dic[npcId];
			role.destory();
			dic[npcId] = null;
			delete  dic[npcId];
		}

		private var keyArr : Array = [];

		/** 移除所有 */
		public function removeAll() : void
		{
			var key : String;
			for (key  in  dic)
			{
				keyArr.push(key);
			}
			var role : Role ;
			while (keyArr.length > 0)
			{
				key = keyArr.pop();
				role = dic[key];
				if (role == null)
				{
					trace(key);
					dic[key] = null;
					delete  dic[key];
					return;
				}
				role.destory();
				dic[key] = null;
				delete  dic[key];
			}
		}

		/** 开始安装 */
		public function startInstall() : void
		{
			NpcSignals.add.add(add);
			var list : Vector.<uint> = mapNpcs.waitInstallList;
			for (var i : int = 0; i < list.length; i++)
			{
				add(list[i]);
			}
		}

		/** 停止安装 */
		public function stopInstall() : void
		{
			NpcSignals.add.remove(add);
		}
	}
}
class Singleton
{
}