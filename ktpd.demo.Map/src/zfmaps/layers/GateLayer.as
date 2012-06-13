package zfmaps.layers
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
     */
    public class GateLayer
    {
        private var list : Vector.<DisplayObject>;
        private var container : Sprite;

        function GateLayer(container : Sprite) : void
        {
            this.container = container;
            list = new Vector.<DisplayObject>();
        }

        public function addChild(child : DisplayObject) : DisplayObject
        {
            list.push(child);
            return container.addChildAt(child, 1);
        }

        public function removeAll() : void
        {
            var child : DisplayObject;
            while (list.length > 0)
            {
                child = list.pop();
                if (child.parent) child.parent.removeChild(child);
            }
        }
    }
}
