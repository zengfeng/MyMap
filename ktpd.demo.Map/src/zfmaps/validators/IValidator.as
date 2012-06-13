package zfmaps.validators
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-7
	// ============================
	public interface IValidator
	{
		function add(callFun : Function) : void;

		function remove(callFun : Function) : void;

		function doValidation() : Boolean;
	}
}
