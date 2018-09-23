/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Preview proxy
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/

package org.enjoytalk.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;

	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.*;
	import org.enjoytalk.model.vo.Item;
	import org.enjoytalk.model.vo.PreviewObject;
	import org.enjoytalk.model.vo.User;
	import org.enjoytalk.view.components.*;
	import org.enjoytalk.view.components.custom.ApplicationConfig;
	import org.enjoytalk.view.components.custom.OnlinePreviewRender;
	import org.enjoytalk.view.components.custom.PreviewRender;
	import org.enjoytalk.view.components.custom.SharedObjectManager;
	import org.enjoytalk.view.components.custom.SkillupSettings;
	import org.enjoytalk.view.events.DEvent;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * Prepare data for study body
	 *
	 * **/
	public class PreviewViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PreviewViewMediator";

		private var courseProxy:CourseProxy;
		private var sequenceProxy:SequenceProxy;
		private var userProxy:UserProxy;

		/**
		 *  Constructor
		 */
		public function PreviewViewMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
			sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			/**
			 * Event hook
			 *
			 *
			 * **/
			previewView.addEventListener(PreviewView.PREVIEW_LOADED, setContent);
		}

		/**
		 * Override
		 *
		 */
		override public function getMediatorName():String
		{
			return PreviewViewMediator.NAME;
		}

		/**
		 * Return previewView instance
		 */
		protected function get previewView():PreviewView
		{
			return viewComponent as PreviewView;
		}

		/**
		 * Preview init
		 *
		 * **/
		private function setContent(event:Event):void
		{
			showSessionLengthBar();
			setStudyContent();
			previewView.previewList.addEventListener("itemSkippedEvent", itemSkippedHandler);
			if (previewView.navNext.enabled)
				previewView.navNext.addEventListener(MouseEvent.CLICK, navNext);
		}


		private function setStudyContent():void
		{
			var itemsData:Array = courseProxy.itemsData;
			var isValidUser:Boolean = userProxy.state;
			var previewData:Array = new Array();
			var dataCollection:ArrayCollection;
			sequenceProxy.initItemsQueue(itemsData);
			sequenceProxy.setStudyData();
			if (sequenceProxy.unSkippedData == null || sequenceProxy.unSkippedData.length == 0)
			{
				previewView.navNext.enabled = false;
			}
			var previewLen:Number = 0;
			for each (var data:Item in itemsData)
			{
				if (previewLen == SharedObjectManager.getInstance().sessionLength)
				{
					break;
				}
				var obj:Object = new PreviewObject(data, userProxy.user.isAuthenticated);
				previewData.push(obj);
				previewLen++;
			}
			dataCollection = new ArrayCollection(previewData);
			previewView.previewList.dataProvider = dataCollection;
			previewView.setPreviewContent();
			if (previewData.length == 0)
			{
				previewView.helpText.text = "没有任何学习内容";
				previewView.navNext.enabled = false;
				return;
			}
			setCourseData(previewData);
		}

		private function setCourseData(previewData:Array):void
		{
			if (previewData.length == 0)
				return;
			var previewLen:Number = 0;
			var newItemsCount:Number = 0;
			var learningItemsCount:Number = 0;
			for each (var data:PreviewObject in previewData)
			{
				if (previewLen == SharedObjectManager.getInstance().sessionLength)
				{
					break;
				}
				if (data.progress == 0 && !data.isSkipped)
				{
					newItemsCount++;
				}
				if (data.progress > 0 && !data.isSkipped && data.progress < 100)
				{
					learningItemsCount++;
				}
				previewLen++;
			}
			previewView.newItemCount.text = String(newItemsCount);
			previewView.learningItemsCount.text = String(learningItemsCount);
			previewView.totalItemsCount.text = String(newItemsCount + learningItemsCount);
			previewView.studyPhase.skin.setCurrentState("preview");
			previewView.globalTimer.initTimer(0);
			if (!previewView.navNext.enabled)
				previewView.navNext.addEventListener(MouseEvent.CLICK, navNext);
		}

		private function showSessionLengthBar():void
		{
			var itemsData:Array = courseProxy.itemsData;
			var sessionLength:Number;
			var appConfig:ApplicationConfig = ApplicationConfig.getInstance();
			var appSetting:SkillupSettings = SkillupSettings(appConfig.setting);
			if (appConfig.setting.needToDisplayTrialMode() && itemsData.length >= CourseProxy.MIN_DATA_LENGTH)
			{
				SharedObjectManager.getInstance().sessionLength = CourseProxy.MIN_DATA_LENGTH;
				previewView.sessionCountGroup.visible = true;
				previewView.countFive.selected = true;
				if (itemsData.length > CourseProxy.MIN_DATA_LENGTH)
				{
					previewView.countTen.selected = false;
				}
				else
				{
					previewView.countTen.visible = false;
				}
				setDefaultSessionLength();
				previewView.countFive.addEventListener(MouseEvent.CLICK, ReSetSessionLength);
				previewView.countTen.addEventListener(MouseEvent.CLICK, ReSetSessionLength);
			}
			else
			{
				previewView.sessionCountGroup.visible = false;
			}
		}

		public function setDefaultSessionLength():void
		{
			if (previewView.countFive.selected)
			{
				SharedObjectManager.getInstance().sessionLength = 5;
			}
			else
			{
				SharedObjectManager.getInstance().sessionLength = 10;
			}
		}


		private function ReSetSessionLength(event:MouseEvent):void
		{
			setDefaultSessionLength();
			setStudyContent();
		}

		/**
		 * Goto next view
		 *
		 * */
		private function navNext(event:Event):void
		{
			sendNotification(ApplicationFacade.STUDY_SHOW);
		}

		private function itemSkippedHandler(event:Event):void
		{
			var itemsData:Array = courseProxy.itemsData;
			var previewLen:Number = itemsData.length;
			var isValidUser:Boolean = userProxy.user.isAuthenticated;
			if (isValidUser)
			{
				sequenceProxy.initItemsQueue(itemsData);
				sequenceProxy.setStudyData();
				if (sequenceProxy.unSkippedData == null || sequenceProxy.unSkippedData.length == 0)
				{
					previewView.navNext.enabled = false;
				}
				else
				{
					previewView.navNext.enabled = true;
				}
				var previewData:Array = new Array();
				for each (var itemData:Item in itemsData)
				{
					var preveiwObject:PreviewObject = new PreviewObject(itemData, isValidUser);
					previewData.push(preveiwObject)
				}
				setCourseData(previewData);
			}
		}
	}
}
