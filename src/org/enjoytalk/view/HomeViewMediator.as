/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 *
 **/

package org.enjoytalk.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;


	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.*;
	import org.enjoytalk.model.vo.Course;
	import org.enjoytalk.model.vo.CourseSession;
	import org.enjoytalk.model.vo.User;
	import org.enjoytalk.view.components.*;
	import org.enjoytalk.view.components.custom.AppTimerManager;
	import org.enjoytalk.view.components.custom.SharedObjectManager;
	import org.enjoytalk.view.events.DEvent;
	import org.enjoytalk.view.events.ToolsEvent;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class HomeViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "homeViewMediator";

		private var userproxy:UserProxy;

		private var courseProxy:CourseProxy;

		private var sequenceProxy:SequenceProxy;

		private var course:Course;

		private var course_session:CourseSession;

		/**
		 * homeViewMediator constructor
		 * params: viewComponent
		 * return:
		 * **/
		public function HomeViewMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			userproxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
			sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			homeView.addEventListener(HomeView.INIT_COMPLETE, initComponent);
		}

		/**
		 * override
		 * **/
		override public function getMediatorName():String
		{
			return HomeViewMediator.NAME;
		}

		/***
		 * return viewComponent as HomeView
		 *
		 * */
		protected function get homeView():HomeView
		{
			return viewComponent as HomeView;
		}

		/**
		 * Event list
		 *
		 * **/
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.RELOAD_COURSE_DATA];
		}

		/**
		 * Event handlers
		 *
		 * **/
		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case ApplicationFacade.RELOAD_COURSE_DATA:
					reloadCourseData();
					break;
			}
		}

		/**
		 * init all compoents that need default value/values
		 * params: event:Event
		 * return:
		 *
		 * **/
		private function initComponent(event:Event):void
		{
			resetAppTimer();
			setCourseData();
			setDefaultSessionLength();
			homeView.loadHistoryData();
			homeView.countFive.addEventListener(MouseEvent.CLICK, setSessionLength);
			homeView.countTen.addEventListener(MouseEvent.CLICK, setSessionLength);
		}

		private function resetAppTimer():void
		{
			var appTimer:AppTimerManager = AppTimerManager.getInstance();
			appTimer.resetTimer();
		}

		private function setCourseData():void
		{
			var course:Course = courseProxy.course;
			var courseSession:CourseSession = course.session;
			var user:User = userproxy.user;
			homeView.welcomeMessage.text = user.newUserMessage;
			homeView.courseTitle.text = course.courseTitle;
			homeView.bigCompleteCount.text = String(courseSession.itemsCompleted);
			homeView.bigStudyTime.text = formatStudyTime(courseSession.totalStudyTime);
			homeView.courseProgress.setProgress(courseSession.progress, 100);
			homeView.progressLabel.text = "课程进度" + " - " + courseSession.progress + "%";
			homeView.newItemsCount.text = String(courseSession.itemsNew);
			homeView.weakItemsCount.text = String(courseSession.itemsWeak);
			homeView.strongItemsCount.text = String(courseSession.itemsStrong);
			homeView.completeItemsCount.text = String(courseSession.itemsCompleted);
			homeView.totalItemsCount.text = String(courseSession.itemsNew + courseSession.itemsWeak + courseSession.itemsStrong + courseSession.itemsCompleted);
			homeView.skippedItemsCount.text = String(courseSession.itemsSkipped);
			homeView.startTime.text = courseSession.startDate;
			homeView.courseImage.setPreviewImage(course.icon);
			if (courseSession.completed)
			{
				homeView.startBtn.enabled = false;
			}
		}

		public function setDefaultSessionLength():void
		{
			if (homeView.countFive.selected)
			{
				SharedObjectManager.getInstance().sessionLength = 5;
			}
			else
			{
				SharedObjectManager.getInstance().sessionLength = 10;
			}
		}


		private function setSessionLength(event:Event):void
		{
			setDefaultSessionLength();
		}

		private function formatStudyTime(value:Number):String
		{
			if (value == 0 || isNaN(value))
			{
				return "00:00";
			}
			var result:String = "";
			var hs:Number = 0;
			var hsr:String = "";
			var ms:Number = 0;
			var msr:String = "";
			var ss:Number = 0;
			var ssr:String = "";
			if (value >= 3600)
			{
				hs = (Math.floor(value / 3600));
				ms = Math.floor((value - hs * 3600) / 60);
				if (hs > 99)
				{
					hs = hs % 100;
				}
				hsr = hs.toString();
				if (hs < 10)
				{
					hsr = "0" + hs;
				}
				msr = ms.toString();
				if (ms < 10)
				{
					msr = "0" + ms;
				}
				result = hsr.substr(0, 2) + ":" + msr.substr(0, 2);
			}
			else
			{
				ms = Math.floor(value / 60);
				msr = ms.toString();
				if (ms < 10)
				{
					msr = "0" + ms;
				}
				ss = (value - ms * 60);
				ssr = ss.toString();
				if (ss < 10)
				{
					ssr = "0" + ss;
				}
				result = msr.substr(0, 2) + ":" + ssr.substr(0, 2);
			}
			return result;
		}

		private function reloadCourseData():void
		{
			setCourseData();
		}
	}
}
