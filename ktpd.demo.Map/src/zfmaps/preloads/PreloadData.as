package zfmaps.preloads
{
	import zfmaps.layers.lands.pieces.PieceGrid;
	import zfmaps.layers.lands.pieces.PiecePosition;
	import zfmaps.loads.expands.BlurLandLoader;
	import zfmaps.loads.expands.PathLoader;
	import zfmaps.loads.expands.PieceLoader;
	import zfmaps.loads.pools.PieceLoaderPool;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-18
     */
    public class PreloadData
    {
        protected static var preloadManager : MapPreload;
        protected static var pieceLoaderPool : PieceLoaderPool;
        private static var piecePositionList : Vector.<PiecePosition>;

        function PreloadData() : void
        {
            if (preloadManager == null)
            {
                preloadManager = MapPreload.instance;
                pieceLoaderPool = PieceLoaderPool.instance;
                piecePositionList = new Vector.<PiecePosition>();
            }
        }

        public function setLoad(mapId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, mapAssetId : int) : void
        {
        }

        public static function setPathLoader(mapAssetId : int) : void
        {
            preloadManager.pathLoader = PathLoader.instance;
            preloadManager.pathLoader.mapId = mapAssetId;
        }
        
        public static function setBlurLandLoader(mapAssetId : int) : void
        {
            preloadManager.blurLandLoader = BlurLandLoader.instance;
            preloadManager.blurLandLoader.mapId = mapAssetId;
        }
        
        public static function setBlurLandLoaderNull() : void
        {
            preloadManager.blurLandLoader = null;
        }

        public static function setPieceScreenLoaderList(mapAssetId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int) : void
        {
            PieceGrid.getScreenLoadList(mapX, mapY, mapWidth, mapHeight, stageWidth, stageHeight, piecePositionList);
            pieceListPositionToLoader(piecePositionList, mapAssetId);
        }

        public static function setPieceAllLoaderList(mapAssetId : int, mapWidth : int, mapHeight : int) : void
        {
            PieceGrid.getAllLoadList(mapWidth, mapHeight, piecePositionList);
            pieceListPositionToLoader(piecePositionList, mapAssetId);
        }

        public static function pieceListPositionToLoader(piecePositionList : Vector.<PiecePosition>, mapAssetId : int) : void
        {
            var pieceLoader : PieceLoader;
            var pieceLoaderList : Vector.<PieceLoader> = preloadManager.pieceLoaderList;
            while (piecePositionList.length > 0)
            {
                pieceLoader = pieceLoaderPool.getObject(piecePositionList.pop(), mapAssetId);
                pieceLoaderList.push(pieceLoader);
            }
        }
    }
}
