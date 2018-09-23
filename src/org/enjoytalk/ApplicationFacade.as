/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk
{
	import org.enjoytalk.controller.*;
	import org.enjoytalk.model.*;
	import org.enjoytalk.view.*;
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		/**
		 * Initialize
		 *
		 * **/
		public static const STARTUP:String="startup";

		public static const INITILIZE:String="initilize";

		/**
		 * user validate
		 *
		 * **/
		public static const USER_LOGIN:String="userLogin";

		public static const CANCEL_LOGIN:String="cancelLogin";

		public static const VALIDATE_USER:String="validateUser";

		public static const USER_VALID_SUC:String="userValidSuc";

		public static const USER_VALID_FAIL:String="userValidFail";

		/**
		 * course  load
		 *
		 * **/
		public static const COURSE_LOAD:String="courseLoad";

		public static const COURSE_LOADED_SUCCESS:String="courseLoadedSuccess";

		public static const COURSE_LOADED_FAILURE:String="courseLoadedFailure";

		public static const RELOAD_COURSE_DATA:String="reloadCourseData";

		/**
		 * load items
		 *
		 * **/
		public static const GET_STDUY_DATA:String="getStudyData";

		public static const ITEMS_LOADED_SUC:String="dataLoadedSuc";

		public static const ITEMS_LOADED_FAIL:String="dataLoadedFail";

		/**
		 * view stack change
		 *
		 *
		 * **/
		public static const WELCOME_SHOW:String="welcomeShow";

		public static const HOME_SHOW:String="homeShow";

		public static const PREVIEW_SHOW:String="previewShow";

		public static const STUDY_SHOW:String="studyShow";

		public static const VIEW_STUDY:String="view_study";

		public static const VIEW_RESTUDY:String="view_restudy";

		public static const VIEW_RECALL:String="view_recall";

		public static const VIEW_MCQUIZ:String="view_mcquiz";

		public static const VIEW_COMPLETED:String="view_completed";

		public static const VIEW_SPELL:String="view_spell";

		public static const UPDATE_COURSE_PROGRESS:String="updateCourseProgress";

		public static const DO_SEQUENCE:String="doSequnce";

		public static const UPDATE_ITEM_PHASE:String="updateItemPhase";

		public static const GOTO_NEXT_ITEM:String="gotoNextItem";

		public static const RETURN_TO_HOME:String="returnToHome";

		public static const PLAY_AUDIO:String="playAudio";

		public static const APP_BUSY_STATE:String="appBusyState";

		public static const APP_BUSY_IDLE:String="appBusyIDLE";

		public static const APP_PAUSE_STATE:String="appPauseState";

		public static const APP_NORMAL_STATE:String="appNormalState";

		/**
		 * heart beat state
		 *
		 * **/
		public static const PAUSE_STUDY:String="pauseStudy";

		public static const RESUME_STUDY:String="resumeStudy";

		public static const LOAD_DATA_FAILURE:String="loadDataFaiture";

		/**
		 * commit session
		 *
		 * **/
		public static const COMMIT_SESSION:String="commitSession";

		public static const HISTORY_DATA_LOADED:String="historyDataLoaded";

		public static const HISTORY_DATA_LOAD_FAILURE:String="historyDataLoadFailure";

		public static const DEBUG_IFNO:String="debugInfo";

		public static const RESET_STUDY_DATA:String="resetStudyData";

		/**
		 * 返回单态的 facade 实例
		 * 该实例为该应用的“总管”
		 */
		public static function getInstance():ApplicationFacade
		{
			if (instance == null)
				instance=new ApplicationFacade();
			return instance as ApplicationFacade;
		}

		/**
		 * ApplicationStartupCommand 类必须在该类中实现
		 * 初始化所有控制器
		 */
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(STARTUP, ApplicationStartupCommand);
			/**
			* Sequence command
			*
			*/
			registerCommand(DO_SEQUENCE, SequenceCommand);
			registerCommand(VALIDATE_USER, UserCommand);
			registerCommand(USER_VALID_SUC, UserCommand);
		}

		/**
		 * Start puremvc
		 *
		 */
		public function startup(app:SkillUp):void
		{
			sendNotification(STARTUP, app);
		}
	}
}
