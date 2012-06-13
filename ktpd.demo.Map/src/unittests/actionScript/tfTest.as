package unittests.actionScript
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	// ============================
	public class tfTest extends Sprite
	{
		public var tfArr:Array = new Array();
		public function tfTest()
		{
			var a_1:TextField = new TextField();
			a_1.text="1";
			var a_2:TextField=new TextField();;
			a_2.text="2";
			var a_3:TextField=new TextField();;
			a_3.text="3";
			
			tfArr.push(a_1);
			tfArr.push(a_2);
			tfArr.push(a_3);
			
			for(var i:int = 0;i < tfArr.length; i++)
			{
				var tf:TextField = tfArr[i];
				tf.x = 100;
				tf.y = i * 30 + 30;
				addChild(tf);
				tf.addEventListener(MouseEvent.CLICK, onMouseDown);
			}
		}

		private function onMouseDown(event : MouseEvent) : void
		{
			var tf:TextField = event.target as TextField;
			tf.text += "a";
			var index:int = tfArr.indexOf(tf);
			trace(index, tf.text);
		}
	}
}
