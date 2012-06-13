package zfmaps.npcs
{
    import com.signalbus.Signal;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-24
     */
    public class NpcSignals
    {
        /** 添加 */
        public static const add : Signal = new Signal(uint);
        /** 移除 */
        public static const remove : Signal = new Signal(uint);
        /** 移除所有 */
        public static const removeAll:Signal = new Signal();
        /** 安装完成 */
        public static const installed : Signal = new Signal(uint);
        /** 停止安装 */
        public static const stopInstall : Signal = new Signal();
        /** 开始安装 */
        public static const startInstall : Signal = new Signal();
    }
}
