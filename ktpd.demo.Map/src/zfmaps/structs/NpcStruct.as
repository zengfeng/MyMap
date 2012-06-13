package zfmaps.structs
{
    import flash.geom.Point;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
     */
    public class NpcStruct extends BaseStruct
    {
		public var isHit:Boolean = false;
		public var hasAvatar:Boolean = true;
        public var position:Point = new Point();
        /** NPC周围角色站立点 */
        public var standPostion : Vector.<Point> = new Vector.<Point>;

        public function NpcStruct()
        {
        }
    }
}
