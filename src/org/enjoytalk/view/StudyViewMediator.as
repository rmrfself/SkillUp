/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * 		This class is the main body of Skillup tool .Almost all events are handled  here.
 * Rebuild-history:
 * 1. 2009/08/24
 * 		Rebuild data structure
 * 2. 2009/08/27
 * 		Rename class name
 * 3. 2009/10/10
 * 		Rewrite function's comments
 **/

package org.enjoytalk.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;

	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.*;
	import org.enjoytalk.model.vo.*;
	import org.enjoytalk.view.components.*;
	import org.enjoytalk.view.components.custom.AppTimerManager;
	import org.enjoytalk.view.components.custom.ErrMessage;
	import org.enjoytalk.view.components.custom.LoadingBar;
	import org.enjoytalk.view.components.custom.LoadingWindow;
	import org.enjoytalk.view.components.custom.LoginWindow;
	import org.enjoytalk.view.components.custom.PaymentWindow;
	import org.enjoytalk.view.components.studyView.submitWindow;
	import org.enjoytalk.view.events.AnswerResult;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * A Mediator for interacting with the EmployeeDetail component.
	 */
	public class StudyViewMediator extends Mediator implements IMediator
	{
		/**
		 * Cannonical name of the Mediator
		 **/
		public static const NAME:String = "StudyViewMediator";

		/**
		 * Available values for the progress viewstack
		 *
		 * **/
		public static const INDEX_STUDY:Number = 0;

		public static const INDEX_QUERY:Number = 1;

		public static const INDEX_SELECTION:Number = 2;

		public static const INDEX_SPELL:Number = 3;

		public static const INDEX_COMPLETED:Number = 4;


		private var userProxy:UserProxy;

		private var sequenceProxy:SequenceProxy;

		private var courseProxy:CourseProxy;

		private var updatePopWin:submitWindow;

		private var _loadingBar:LoadingBar;

		private var _loginWindow:LoginWindow;

		private var _paymentWindow:PaymentWindow;

		/**
		 * Constructor.
		 */
		public function StudyViewMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
			sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			/**
			 * Event handler  hook
			 *
			 * **/
			studyView.addEventListener(StudyView.INIT_COMPLETE, initData);
			studyView.addEventListener(AnswerResult.ANSWER_RIGHT, answerRight);
			studyView.addEventListener(AnswerResult.ANSWER_WRONG, answerWrong);
		}

		/**
		 * Override
		 */
		override public function getMediatorName():String
		{
			return StudyViewMediator.NAME;
		}

		/**
		 * Notification list
		 */
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.VIEW_STUDY, ApplicationFacade.VIEW_RECALL, ApplicationFacade.VIEW_MCQUIZ, ApplicationFacade.VIEW_SPELL, ApplicationFacade.UPDATE_ITEM_PHASE, ApplicationFacade.GOTO_NEXT_ITEM, ApplicationFacade.PAUSE_STUDY, ApplicationFacade.VIEW_RESTUDY, ApplicationFacade.RESUME_STUDY, ApplicationFacade.COMMIT_SESSION, ApplicationFacade.VIEW_COMPLETED];
		}

		/**
		 * Notification handler
		 */
		override public function handleNotification(note:INotification):void
		{
			var item:Item = sequenceProxy.currentItem;
			var session:ItemSession = item.session;
			var param:StudyParameter;
			switch (note.getName())
			{
				case ApplicationFacade.VIEW_RESTUDY:
					item = item.reversedItem;
					studyView.currentState = "review";
					param = new StudyParameter();
					param.isReversedMode = true;
					this.studyView.study.setStduyContent(item, param);
					studyView.studyViewstack.selectedIndex = INDEX_STUDY;
					setButtonEvents();
					break;
				case ApplicationFacade.VIEW_STUDY:
					studyView.currentState = "review";
					param = new StudyParameter();
					this.studyView.study.setStduyContent(item, param);
					studyView.studyViewstack.selectedIndex = INDEX_STUDY;
					setButtonEvents();
					break;
				case ApplicationFacade.VIEW_RECALL:
					var params:Object = note.getBody();
					param = new StudyParameter();
					if (params._isReversed)
					{
						item = item.reversedItem;
						param.isReversedMode = true;
					}
					studyView.recall.setContent(item, param);
					studyView.studyViewstack.selectedIndex = INDEX_QUERY;
					studyView.currentState = "recall";
					setButtonEvents();
					break;
				case ApplicationFacade.VIEW_MCQUIZ:
					params = note.getBody();
					param = new StudyParameter();
					studyView.currentState = "multi_choices";
					var mcData:Array;
					var dataProvider:ArrayCollection;
					if (params._itemsCount == null)
					{
						params._itemsCount = 5;
					}
					if (params._isReversed)
					{
						param.isReversedMode = true;
					}
					if (param.isReversedMode)
					{
						mcData = McQuiz(item.response.mcQuiz).getRandDistractors(params._itemsCount);
					}
					else
					{
						mcData = McQuiz(item.cue.mcQuiz).getRandDistractors(params._itemsCount);
					}
					dataProvider = new ArrayCollection(mcData);
					studyView.mc_quiz.setContent(dataProvider, param);
					studyView.studyViewstack.selectedIndex = INDEX_SELECTION;
					setButtonEvents();
					break;
				case ApplicationFacade.VIEW_SPELL:
					studyView.studyViewstack.selectedIndex = INDEX_SPELL;
					studyView.spell.item = item;
					studyView.spell.initSpell();
					studyView.currentState = "spell";
					setButtonEvents();
					break;
				case ApplicationFacade.VIEW_COMPLETED:
					studyView.studyViewstack.selectedIndex = INDEX_COMPLETED;
					studyView.currentState = "completed";
					studyView.comletedButton.addEventListener(MouseEvent.CLICK, handleCommitSession);
					break;
				case ApplicationFacade.UPDATE_ITEM_PHASE:
					studyView.itemsGrpManager.session = item.session;
					/**
					 * re-caculate course progress agin
					 *
					 * **/
					reCaculateCourseProgress();
					break;
				case ApplicationFacade.GOTO_NEXT_ITEM:
					showCurrentItemIndicator(item);
					break;
				case ApplicationFacade.COMMIT_SESSION:
					commitSession();
					break;
				default:
					break;
			}
		}


		protected function get studyView():StudyView
		{
			return viewComponent as StudyView;
		}

		private function reCaculateCourseProgress():void
		{
			var session:ItemSession = sequenceProxy.currentSession;
			if (session.itemStatus.currentState.result && session.itemStatus.currentState.stateValue > 0)
			{
				var course_progress:Number = 0;
				var session_table:Array = sequenceProxy.sessionTable;
				var total_count:Number = session_table.length * 10;
				var progress_index:Number = 0;
				for each (var tmp:ItemSession in session_table)
				{
					progress_index = ItemStatus.PROGRESS_DEGREE.indexOf(tmp.itemStatus.currentState.progressDegree);
					if (progress_index > -1)
					{
						course_progress += CourseSession.COURSE_PROGRESS_DEGREE[progress_index];
					}
				}
				sequenceProxy.courseProgress = course_progress;
				studyView.listProgressBar.setProgress(course_progress, total_count);
			}
		}

		/**
		 * Initionalize status data include:
		 * 1. course progress
		 * 2. items progress
		 * 3. sequence and status flags
		 * 4. others data structures
		 *
		 * **/
		private function initData(event:Event):void
		{
			setContent();
		}


		public function setContent():void
		{
			studyView.listProgressBar.setProgress(0, 100);
			setItemsIndicator();
			setCourseMode();
			beginDoSequence();
			startCourseTimer();
			studyView.studyPhase.skin.setCurrentState("study");
			studyView.returnHomeButton.addEventListener(MouseEvent.CLICK, returnHomeHandler);
		}


		private function setButtonEvents():void
		{
			if (studyView.navStudyNext != null && studyView.navStudyNext.enabled)
			{
				studyView.navStudyNext.addEventListener(MouseEvent.CLICK, navStudyNext);
			}
			if (studyView.currentState == "recall")
			{
				studyView.navStudyUnknow.addEventListener(MouseEvent.CLICK, navStudyUnknow);
				studyView.navStudyKnow.addEventListener(MouseEvent.CLICK, navStudyKnow);
			}
		}

		private function navStudyNext(event:Event):void
		{
			beginDoSequence();
		}

		private function navStudyUnknow(event:Event):void
		{
			var item_session:ItemSession = sequenceProxy.currentSession;
			if (item_session)
			{
				item_session.itemStatus.currentState.know = false;
			}
			sequenceProxy.renderViews();
		}

		private function navStudyKnow(event:Event):void
		{
			var item_session:ItemSession = sequenceProxy.currentSession;
			if (item_session)
			{
				item_session.itemStatus.currentState.know = true;
			}
			sequenceProxy.renderViews();
		}

		private function navRestudy(event:Event):void
		{
			var item_session:ItemSession = sequenceProxy.currentSession;
			if (item_session)
			{
				item_session.itemStatus.currentState.reStudy();
			}
			sequenceProxy.renderViews();
		}

		private function setItemsIndicator():void
		{
			var course:Course = courseProxy.course;
			var itemsData:Array = sequenceProxy.unSkippedData;
			studyView.itemsGrpManager.init(itemsData);
		}

		private function setCourseMode():void
		{
			var course:Course = courseProxy.course;
			switch (course.cueLanguageCode)
			{
				case "ja":
					studyView.studyMode.text = "日语模式";
					break;
				case "en":
					studyView.studyMode.text = "英语模式";
					break;
				case "zh-Hans":
					studyView.studyMode.text = "简体中文";
					break;
				case "zh-Hant":
					studyView.studyMode.text = "繁体中文";
					break;
			}
		}

		private function showCurrentItemIndicator(item:Item):void
		{
			studyView.itemsGrpManager.item = item;
		}


		public function beginDoSequence():void
		{
			sendNotification(ApplicationFacade.DO_SEQUENCE);
		}


		public function startCourseTimer():void
		{
			var appTimer:AppTimerManager = AppTimerManager.getInstance();
			if (!appTimer.isBeginStudy)
			{
				appTimer.isBeginStudy = true;
			}
			studyView.globalTimer.initTimer(0);
			appTimer.registerTimerJob(AppTimerManager.STUDY_TIMER, courseTimerHandler);
		}

		private function courseTimerHandler(count:Number = 0):void
		{
			if (count > 0)
				studyView.globalTimer.setTimer(count);
		}

		/**
		 * when answer is right;
		 *
		 * **/
		private function answerRight(event:Event):void
		{
			var item_session:ItemSession = sequenceProxy.currentSession;
			if (item_session)
			{
				item_session.itemStatus.currentState.result = true;
				if (item_session.itemStatus.currentState.stateValue == ItemStatus.DONE)
				{
					item_session.completed = true;
				}
			}
			studyView.currentState = "answer_right";
		}

		/**
		 * when answer is wrong
		 *
		 * **/
		private function answerWrong(event:Event):void
		{
			var item_session:ItemSession = sequenceProxy.currentSession;
			if (item_session)
			{
				item_session.itemStatus.currentState.result = false;
			}
			studyView.currentState = "answer_wrong";
			studyView.navRestudy.addEventListener(MouseEvent.CLICK, navRestudy);
		}

		private function heartBeatHandler(event:Event):void
		{
			var course_session:CourseSession = courseProxy.course_session;
			if (course_session)
			{
				course_session.totalStudyTime++;
			}
			var item_session:ItemSession = sequenceProxy.currentSession;
			if (item_session)
			{
				var performance:ItemPerformance = item_session.itemStatus.currentState.performance;
				performance.studyTimeSec++;
			}
		}

		private function returnHomeHandler(event:MouseEvent):void
		{
			commitSession();
		}

		private function paymentCheck(event:Event):void
		{
			this.userProxy.checkPayment(paymentCheckCallback, null, paymentCheckFail);
		}

		private function paymentCheckCallback():void
		{
			var user:User = this.userProxy.user;
			if (!user.isExpired && user.expiredDate != null && user.isVip)
			{
				PopUpManager.removePopUp(_paymentWindow);
				commitSession();
			}
			else
			{
				_paymentWindow.checkCallBack();
			}

		}

		private function paymentCheckFail():void
		{
			_paymentWindow.checkFail();
		}

		private function cancelPayment(event:Event):void
		{
			studyView.resumeQuizTimerBar();
			resumeAppTimer();
			PopUpManager.removePopUp(_paymentWindow);
		}


		private function handleCommitSession(event:MouseEvent):void
		{
			commitSession();
		}

		private function commitSession():void
		{
			stopAppTimer();
			var user:User = userProxy.user as User;
			if (user.isAuthenticated)
			{
					_loadingBar = new LoadingBar();
					PopUpManager.addPopUp(_loadingBar, studyView, true);
					PopUpManager.centerPopUp(_loadingBar);
					courseProxy.commitSession(sessionCommitDone, sessionCommitProgress, sessionCommitFail);
					unregisterTimerJobs();
					resumeAppTimer();
			}
			else
			{
				doLogin();
			}
		}


		private function stopAppTimer():void
		{
			var appTimer:AppTimerManager = AppTimerManager.getInstance();
			appTimer.pauseTimer();
			studyView.pauseQuizTimerBar();
		}

		private function resumeAppTimer():void
		{
			var appTimer:AppTimerManager = AppTimerManager.getInstance();
			appTimer.resumeTimer();
		}

		private function doLogin(callback:Function = null):void
		{
			_loginWindow = new LoginWindow();
			_loginWindow.addEventListener("authSucEvent", authSucHandler);
			_loginWindow.addEventListener("cancelWindow", cancelLogin);
			PopUpManager.addPopUp(_loginWindow, studyView, true);
			PopUpManager.centerPopUp(_loginWindow);
		}

		private function authSucHandler(event:Event):void
		{
			PopUpManager.removePopUp(_loginWindow);
			if (sequenceProxy.isStarted)
			{
				commitSession();
			}
		}

		private function sessionCommitDone():void
		{
			PopUpManager.removePopUp(_loadingBar);
			sendNotification(ApplicationFacade.HOME_SHOW, true);
		}

		private function sessionCommitFail():void
		{
			PopUpManager.removePopUp(_loadingBar);
			var errorMessage:ErrMessage = ErrMessage.getInstance();
			errorMessage.showErrorMessage(ErrMessage.ERR_COMMIT_SESSION);
		}

		private function sessionCommitProgress():void
		{
		}

		private function cancelLogin(event:Event):void
		{
			studyView.resumeQuizTimerBar();
			resumeAppTimer();
			PopUpManager.removePopUp(_loginWindow);
		}

		private function unregisterTimerJobs():void
		{
			var appTimer:AppTimerManager = AppTimerManager.getInstance();
			appTimer.unRegisterJobs(AppTimerManager.STUDY_TIMER);
			appTimer.unRegisterJobs(AppTimerManager.ITEM_TIMER);
			appTimer.isBeginStudy = false;
		}
	}
}
