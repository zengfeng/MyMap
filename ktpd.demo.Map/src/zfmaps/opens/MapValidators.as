package zfmaps.opens
{
	import zfmaps.validators.IValidator;
	import zfmaps.validators.SimpleValidator;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-7
	// 地图验证--对外开放
	// ============================
	public class MapValidators
	{
		public static const mouseWalk : IValidator = new SimpleValidator();
		public static const changeMap : IValidator = new SimpleValidator();
		public static const joinActivity : IValidator = new SimpleValidator();
	}
}
