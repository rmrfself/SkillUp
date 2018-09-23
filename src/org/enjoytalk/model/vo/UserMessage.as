package org.enjoytalk.model.vo
{

    public class UserMessage
    {

        public static const MSG_NETWORK_ERR:String = "对不起! 网络连接出现了异常";

        public static const INDEX_NETWORK_ERR:Number = 0;

        public static const MSG_SAVE_DATA_ERR:String = "你的学习数据没有保存成功";

        public static const INDEX_SAVE_DATA_ERR:Number = 1;

        public static const MSG_GET_STUDYDATA_ERR:String = "对不起，学习数据没有加载成功";

        public static const INDEX_GET_STUDYDATA_ERR:Number = 2;

        public static function getMessage(msgCode:Number):String
        {
            var msg:String = "";
            switch (msgCode)
            {
                case INDEX_NETWORK_ERR:
                    msg = MSG_NETWORK_ERR;
                    break;
                case INDEX_SAVE_DATA_ERR:
                    msg = MSG_SAVE_DATA_ERR;
                    break;
                case INDEX_GET_STUDYDATA_ERR:
                    msg = MSG_GET_STUDYDATA_ERR;
                    break;
            }
            return msg;
        }
    }
}