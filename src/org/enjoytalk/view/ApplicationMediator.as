/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Const Var defination
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 *
 **/
package org.enjoytalk.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;

	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;

	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.CourseProxy;
	import org.enjoytalk.model.SequenceProxy;
	import org.enjoytalk.model.UserProxy;
	import org.enjoytalk.model.vo.Item;
	import org.enjoytalk.model.vo.UserMessage;
	import org.enjoytalk.view.components.custom.AppTimerManager;
	import org.enjoytalk.view.components.custom.ErrMessage;
	import org.enjoytalk.view.components.custom.GlobalUtil;
	import org.enjoytalk.view.components.custom.LoadingBar;
	import org.enjoytalk.view.components.custom.LoadingWindow;
	import org.enjoytalk.view.components.custom.LoginWindow;
	import org.enjoytalk.view.components.custom.PauseWindow;
	import org.enjoytalk.view.events.DEvent;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ApplicationMediator extends Mediator implements IMediator
	{
		/**
		 * ApplicationMediator
		 *
		 * **/
		public static const NAME:String = "ApplicationMediator";

		/**
		 * Stack view index list
		 *
		 * **/
		public static const INDEX_WELCOME:Number = 0;

		public static const INDEX_HOME:Number = 1;

		public static const INDEX_PREVIEW:Number = 2;

		public static const INDEX_STUDY:Number = 3;

		private var userProxy:UserProxy;

		private var courseProxy:CourseProxy;

		private var sequenceProxy:SequenceProxy;

		private var _loadingBar:LoadingBar;

		private var _pauseWindow:PauseWindow;

		private var _appTimerManager:AppTimerManager;


		/**
		 * Constructor
		 *
		 */
		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
			startUpApp();
		}

		/**
		 * Event list
		 *
		 * **/
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.HOME_SHOW, ApplicationFacade.PREVIEW_SHOW, ApplicationFacade.STUDY_SHOW, ApplicationFacade.PLAY_AUDIO, ApplicationFacade.APP_BUSY_STATE, ApplicationFacade.APP_BUSY_IDLE, ApplicationFacade.APP_PAUSE_STATE, ApplicationFacade.APP_NORMAL_STATE, ApplicationFacade.USER_LOGIN, ApplicationFacade.USER_VALID_FAIL, ApplicationFacade.COMMIT_SESSION, ApplicationFacade.LOAD_DATA_FAILURE, ApplicationFacade.DEBUG_IFNO];
		}

		/**
		 * Event handlers
		 *
		 * **/
		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case ApplicationFacade.DEBUG_IFNO:
					app.appMessage.text = app.appMessage.text + String(note.getBody()) + "\n";
					break;
				case ApplicationFacade.HOME_SHOW:
					var needToReload:Boolean = Boolean(note.getBody());
					if (facade.retrieveMediator(HomeViewMediator.NAME) == null)
					{
						facade.registerMediator(new HomeViewMediator(app.homeView));
					}
					if (needToReload)
					{
						reloadCourseData();
					}
					setExtraFunc();
					app.appViewStack.selectedIndex = INDEX_HOME;
					break;
				case ApplicationFacade.PREVIEW_SHOW:
					if (facade.retrieveMediator(PreviewViewMediator.NAME) == null)
					{
						facade.registerMediator(new PreviewViewMediator(app.previewView));
					}
					app.appViewStack.selectedIndex = INDEX_PREVIEW;
					break;
				case ApplicationFacade.STUDY_SHOW:
					if (facade.retrieveMediator(StudyViewMediator.NAME) == null)
					{
						facade.registerMediator(new StudyViewMediator(app.studyView));
					}
					app.pauseButton.addEventListener(MouseEvent.CLICK, pauseStudy);
					app.appViewStack.selectedIndex = INDEX_STUDY;
					break;
				case ApplicationFacade.APP_BUSY_STATE:
					_loadingBar = new LoadingBar();
					PopUpManager.addPopUp(_loadingBar, app, true);
					PopUpManager.centerPopUp(_loadingBar);
					break;
				case ApplicationFacade.APP_BUSY_IDLE:
					PopUpManager.removePopUp(_loadingBar)
					break;
			}
			setExtraFunc();
		}

		protected function get app():SkillUp
		{
			return viewComponent as SkillUp;
		}

		public function startUpApp():void
		{
			_appTimerManager = AppTimerManager.getInstance();
			app.addElement(_appTimerManager);
			_appTimerManager.setParentReference(app);
			_appTimerManager.registerTimerJob(AppTimerManager.APP_TIMER, appTimerWorker);
			_appTimerManager.startTimer();
			var errorMessage:ErrMessage = ErrMessage.getInstance();
			errorMessage.setParentContainer(app);
			app.pauseButton.visible = false;
		}


		private function reloadCourseData():void
		{
			_loadingBar = new LoadingBar();
			PopUpManager.addPopUp(_loadingBar, app, true);
			PopUpManager.centerPopUp(_loadingBar);
			courseProxy.loadCourse(courseLoadDone, courseLoadProgress, courseLoadFail);
		}

		private function courseLoadDone(event:Event):void
		{
			PopUpManager.removePopUp(_loadingBar);
			sendNotification(ApplicationFacade.RELOAD_COURSE_DATA);
		}

		private function courseLoadFail(event:FaultEvent):void
		{
			PopUpManager.removePopUp(_loadingBar);
		}

		private function courseLoadProgress(event:ProgressEvent):void
		{
		}


		public function pauseApp():void
		{
			_appTimerManager.pauseTimer();
		}

		public function resumeApp():void
		{
			_appTimerManager.resumeTimer();
		}

		private function appTimerWorker():void
		{
		}

		private function pauseStudy(event:MouseEvent):void
		{
			var appTimerManager:AppTimerManager = AppTimerManager.getInstance();
			appTimerManager.pauseAppTimer();
			appTimerManager.addEventListener(AppTimerManager.RESUME_EVENT_NAME, resumeStudy);
			app.studyView.pauseQuizTimerBar();
		}

		private function resumeStudy(event:Event):void
		{
			app.studyView.resumeQuizTimerBar();
		}

		private function setExtraFunc():void
		{
			switch (app.appViewStack.selectedIndex)
			{
				case INDEX_HOME:
					//app.configButton.visible=true;
					//app.configButton.includeInLayout=true;
					app.pauseButton.visible = false;
					app.pauseButton.includeInLayout = false;
					break;
				case INDEX_PREVIEW:
					break;
				case INDEX_STUDY:
					app.pauseButton.visible = true;
					app.pauseButton.includeInLayout = true;
					break;
			}

		}
	}
}
