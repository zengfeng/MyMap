package zfmaps.preloads
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class PreloadDataDuple extends PreloadData
    {
        /** 单例对像 */
        private static var _instance : PreloadDataDuple;

        /** 获取单例对像 */
        static public function get instance() : PreloadDataDuple
        {
            if (_instance == null)
            {
                _instance = new PreloadDataDuple(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        function PreloadDataDuple(singleton : Singleton) : void
        {
            singleton;
            super();
        }

        override public function setLoad(mapId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, mapAssetId : int) : void
        {
			mapX;
			mapY;
			stageWidth;
			stageHeight;
            if (!mapAssetId || mapAssetId < 0) mapAssetId = mapId;
            setPathLoader(mapAssetId);
            setBlurLandLoaderNull();
            setPieceAllLoaderList(mapAssetId, mapWidth, mapHeight);
        }
    }
}
class Singleton
{
}
