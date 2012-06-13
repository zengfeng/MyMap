package game.config
{
	import log4a.Logger;

	/**
	 * @author yangyiqiang
	 */
	public class StaticConfig
	{
		/** 网页传入的userID  **/
		public static var userId : String="";

		public static var baseVersion : String = "";

		/** 资源路径  例如:要取创建角色的资源，路径可写成 StaticConfig.cdnRoot + "assets/createRole/createRoleSkin.swf **/
		public static var cdnRoot : String =  "D:/client/KTPDProject/";

		/**语言类型*/
		public static var langString : String = "zh_CN";

		/** socket的IP 和 port **/
		public static var serversString : String  ;

		/** 是否是新用户 **/
		public static var isNewUser : Boolean;

		/** 平台名称 **/
		public static var channel : String ;

		/** 服务器编号 **/
		public static var gameNumber : int  ;

		/**  version */
		public static var game_version : String = "版本：Beta 2.2.2" ;

		/**  官网 */
		public static var offcialSite : String = "http://kt.xd.com";

		/**  bbs */
		public static var bbs : String = "http://bbs.xd.com/index.php?gid=29";

		/**  充值 */
		public static var pay : String = "http://kt.xd.com";

		/** 防沉迷url **/
		public static var fcm_url : String = "";

		/** 通信KEY **/
		public static var key : String  ;
		
		public static const ISDEBUGE:int=0;
		public static const NODEBUGE:int=1;
		public static const RELEASE:int=2;

		/**初始化基本参数（参数从网页中传入）
		 * 
		user          联运平台ID
		channel  联运平台英文名，比如心动平台就是xd
		channel_name 平台中文名
		index_url    游戏官网URL
		charge_url   支付页面URL
		security_url   账号安全设置页面URL
		fcm_url         填写防沉迷信息的URL
		bbs_url        论坛URL
		logo_url       （这个主要用在百度，QQ等特殊平台上，暂时可忽略）
		game_name    游戏名称，比如百度的游戏名是不一样的
		i18n           语言类型,有zh-cn,zh-tw,en等
		host_list       游戏服务器列表，多个服务器是用|分开
		full_screen     是否全屏，0=是，1=否
		cdn_url        资源的CDN url，多个用|分开，以/结尾
		data           需要传给游戏服务器验证的数据
		 * 
		 */
		public static function initConfig(obj : Object) :int
		{
			if(userId!="")return RELEASE;
			userId = obj["userid"] == undefined ? "7006" : obj["userid"];
			serversString = obj["gad"] == undefined ? "192.168.4.114:8882" : obj["gad"];
			cdnRoot = obj["cdnroot"] == undefined ? "../" : obj["cdnroot"];
			langString = obj["glocale"] == undefined ? "zh_CN" : obj["glocale"];
			channel = obj["channel"] == undefined ? "1" : obj["channel"];
			gameNumber = obj["game_no"] == undefined ? 1 : Number(obj["channel"]);
			isNewUser = obj["newuser"] == undefined ? false : Number(obj["newuser"]);
			offcialSite = obj["index_url "] == undefined ? "" : String(obj["index_url "]);
			bbs = obj["bbs_url"] == undefined ? "" : String(obj["bbs_url"]);
			fcm_url = obj["fcm_url"] == undefined ? "" : String(obj["fcm_url"]);
			pay = obj["charge_url"] == undefined ? "" : String(obj["charge_url"]);
			key = obj["data"] == undefined ? "" : String(obj["data"]);
			Logger.debug("StaticConfig.userId ===>" + obj["userid"]);
			Logger.debug("StaticConfig.serversString===>" + obj["gad"]);
			Logger.debug("StaticConfig.cdnRoot===>" + obj["cdnroot"]);
			Logger.debug("StaticConfig.key===>" + obj["key"]);
			return obj["userid"] == undefined?ISDEBUGE:NODEBUGE;
		}
	}
}
