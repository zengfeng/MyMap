package zfmaps.layers.lands.pieces
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-16
     */
    public class PieceManager
    {
        /** 单例对像 */
        private static var _instance : PieceManager;

        /** 获取单例对像 */
        static public function get instance() : PieceManager
        {
            if (_instance == null)
            {
                _instance = new PieceManager(new Singleton());
            }
            return _instance;
        }
		
        function PieceManager(singleton : Singleton) : void
        {
        }
        
        
    }
}
class Singleton
{
}