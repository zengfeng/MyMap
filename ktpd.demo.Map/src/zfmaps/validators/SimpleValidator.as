package zfmaps.validators
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-7
	// ============================
	public class SimpleValidator implements IValidator
	{
		private var callList : Vector.<Function> = new Vector.<Function>();

		public function add(callFun : Function) : void
		{
			var index : int = callList.indexOf(callFun);
			if (index == -1)
			{
				callList.push(callFun);
			}
		}

		public function remove(callFun : Function) : void
		{
			var index : int = callList.indexOf(callFun);
			if (index != -1)
			{
				callList.splice(index, 1);
			}
		}

		private var tempFun : Function;

		public function doValidation() : Boolean
		{
			for (var i : int = 0; i < callList.length; i++)
			{
				tempFun = callList[i];
				tempFun();
			}
			tempFun = null;
			return callList.length == 0;
		}
	}
}
