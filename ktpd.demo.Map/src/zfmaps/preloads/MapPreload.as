package zfmaps.preloads
{
	import com.signalbus.Signal;
	import zfmaps.loads.LoadManager;
	import zfmaps.loads.core.LoaderCore;
	import zfmaps.loads.expands.BlurLandLoader;
	import zfmaps.loads.expands.PathLoader;
	import zfmaps.loads.expands.PieceLoader;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class MapPreload
    {
        /** 单例对像 */
        private static var _instance : MapPreload;

        /** 获取单例对像 */
        static public function get instance() : MapPreload
        {
            if (_instance == null)
            {
                _instance = new MapPreload(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        private var loadManager : LoadManager;
        public var signalComplete : Signal;
        public var pathLoader : PathLoader;
        public var blurLandLoader : BlurLandLoader;
        public var pieceLoaderList : Vector.<PieceLoader>;

        function MapPreload(singleton : Singleton)
        {
            singleton;
            loadManager = LoadManager.instance;
            pieceLoaderList = new Vector.<PieceLoader>();
            signalComplete = new Signal();
        }

        public function reset(mapId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, mapAssetId : int, isFullMode:Boolean) : void
        {
            if (!mapAssetId || mapAssetId < 0) mapAssetId = mapId;
            loadManager.clear();
            clear(true);
            var preloadData : PreloadData;
            if (!isFullMode)
            {
                preloadData = PreloadDataNormal.instance;
            }
            else
            {
                preloadData = PreloadDataDuple.instance;
            }
            preloadData.setLoad(mapId, mapX, mapY, mapWidth, mapHeight, stageWidth, stageHeight, mapAssetId);
        }

        public function startLoad() : void
        {
            // 寻路数据
            if (pathLoader)
            {
                loadManager.append(pathLoader);
            }

            // 模糊陆地
            if (blurLandLoader)
            {
                loadManager.append(blurLandLoader);
            }

            // 地图块列表
            var length : int = pieceLoaderList.length;
            for (var i : int = 0; i < length; i++)
            {
                loadManager.append(pieceLoaderList[i]);
            }

            loadManager.signalProgress.add(progress);
            loadManager.signalComplete.add(complete);
            loadManager.startLoad();
        }

        public function complete() : void
        {
            loadManager.signalProgress.remove(progress);
            loadManager.signalComplete.remove(complete);
            signalComplete.dispatch();
        }

        public function progress(overNum : int, totalNum : int) : void
        {
//			MapPreloadManager.instance.setLoadMapProgress(int((overNum / totalNum) * 100));
        }

        public function clear(gc : Boolean = false) : void
        {
            if (pathLoader) pathLoader.unloadAndStop(gc);
            if (blurLandLoader) blurLandLoader.unloadAndStop(gc);
            while (pieceLoaderList.length > 0)
            {
                (pieceLoaderList.pop() as LoaderCore).unloadAndStop(gc);
            }
        }
    }
}
class Singleton
{
}