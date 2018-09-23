/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Const Var defination
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/


package org.enjoytalk.model.vo
{
	
	import mx.core.FlexGlobals;
	public class ConstVar
	{
		public static const REQUEST_PROTOCOL:String="http";

		public static const SERVER_DOMAIN:String= mx.core.Application.application.parameters.host == null ? "10.72.36.179":mx.core.Application.application.parameters.host;

		public static const SERVER_PORT:String= mx.core.Application.application.parameters.port == null ? "80":mx.core.Application.application.parameters.port;
		
		public static const URL_MODULE:String= mx.core.Application.application.parameters.e == null ? "shMaritimeUniv":mx.core.Application.application.parameters.e;

		public static const REQUEST_BASE_URL:String=REQUEST_PROTOCOL + "://" + SERVER_DOMAIN + ":" + SERVER_PORT;

		public static const ITEMS_REQUEST_PATH:String="/include/Of/Extension/extendPage.php?a=getStudyData&e="+URL_MODULE;

		public static const SKIP_ITEM_PATH:String="/include/Of/Extension/extendPage.php?a=skipItem&e="+URL_MODULE;

		public static const COURSE_REQUEST_PATH:String="/include/Of/Extension/extendPage.php?a=getCourse&e="+URL_MODULE;

		public static const COURSE_HISTORY_PATH:String="/include/Of/Extension/extendPage.php?a=getHistory&e="+URL_MODULE;

		public static const COMMIT_SESSION_PATH:String="/include/Of/Extension/extendPage.php?a=saveLearningData&e="+URL_MODULE;

		public static const GET_USER_PATH:String="/include/Of/Extension/extendPage.php?a=getUser&e="+URL_MODULE;

		public static const POST_USER_VALIDATION:String="/include/Of/Extension/extendPage.php?a=remoteUserValid&e="+URL_MODULE;


		public static const S_LANGUAGE_EN:String="en";
		public static const S_LANGUAGE_JP:String="jp";
		public static const S_LANGUAGE_ZH_HANS:String="zh-Hans";
		public static const S_LANGUAGE_ZH_HANT:String="zh-Hant";

		public static const NO_ANSWER_ZH_HANS:String="以上都不是";
		public static const NO_ANSWER_ZH_HANT:String="以上都不是";
		public static const NO_ANSWER_EN:String="None of the above";
		public static const NO_ANSWER_JP:String="ない";
	}
}
