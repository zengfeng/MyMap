package zfmaps.preloads
{

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class PreloadDataNormal extends PreloadData
    {
        /** 单例对像 */
        private static var _instance : PreloadDataNormal;

        /** 获取单例对像 */
        static public function get instance() : PreloadDataNormal
        {
            if (_instance == null)
            {
                _instance = new PreloadDataNormal(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        function PreloadDataNormal(singleton : Singleton) : void
        {
            singleton;
            super();
        }

        override public function setLoad(mapId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, mapAssetId : int) : void
        {
            if (!mapAssetId || mapAssetId < 0) mapAssetId = mapId;
            setPathLoader(mapAssetId);
            setBlurLandLoader(mapAssetId);
            setPieceScreenLoaderList(mapAssetId, mapX, mapY, mapWidth, mapHeight, stageWidth, stageHeight);
        }
    }
}
class Singleton
{
}
