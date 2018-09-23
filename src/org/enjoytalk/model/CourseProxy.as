/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: CourseProxy
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 * 3. 2011/01/27
 *
 **/
package org.enjoytalk.model
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;

	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.helper.Progress;
	import org.enjoytalk.model.vo.*;
	import org.enjoytalk.view.components.custom.AppTimerManager;
	import org.enjoytalk.view.components.custom.GlobalUtil;
	import org.enjoytalk.view.components.custom.LanguageCodeManager;
	import org.enjoytalk.view.components.custom.SharedObjectManager;
	import org.enjoytalk.view.components.custom.SkillupSettings;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * Course proxy
	 */
	public class CourseProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CourseProxy";

		public var course:Course;

		public var course_session:CourseSession;

		private var _courseId:int;
		private var _itemsData:Array;


		/**
		 * Responsable for loading study data
		 *
		 ***/
		private var _userProxy:UserProxy;

		private var _sequenceProxy:SequenceProxy;

		public var needReload:Boolean = false;

		private var _loader:URLLoader;
		private var _request:URLRequest;

		private var _onCourseLoaded:Function;
		private var _onCourseFail:Function;
		private var _onCourseProgress:Function;

		private var _onHistoryLoaded:Function;
		private var _onHistoryFail:Function;
		private var _onHistoryProgress:Function;

		private var _onDataLoaded:Function;
		private var _onDataFail:Function;
		private var _onDataProgress:Function;

		private var _onSessionCommitSuc:Function;
		private var _onSessionCommitFail:Function;
		private var _onSessionCommitProgress:Function;

		/**
		 *
		 */
		public static const MIN_DATA_LENGTH:Number = 5;


		/**
		 * init
		 *
		 * */
		public function CourseProxy(data:Object = null)
		{
			super(NAME, null);
			courseId = FlexGlobals.topLevelApplication.parameters.course_id;
			_request = new URLRequest();
		}



		/**
		 *  load course data by http
		 *  return xml
		 * **/
		public function loadCourse(callbackDone:Function = null, callbackProgress:Function = null, callbackFail:Function = null):void
		{
			_loader = new URLLoader();
			_onCourseLoaded = (callbackDone == null ? null : callbackDone);
			_onCourseProgress = (callbackProgress == null ? null : callbackProgress);
			_onCourseFail = (callbackFail == null ? null : callbackFail);
			var now:Date = new Date();
			var url:String = ConstVar.REQUEST_BASE_URL + ConstVar.COURSE_REQUEST_PATH + "&id=" + courseId + "&v=" + now.getTime();
			_request.url = url;
			_loader.addEventListener(Event.COMPLETE, onCourseLoaded);
			_loader.addEventListener(FaultEvent.FAULT, onCourseFail);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onCourseFail);
			_loader.addEventListener(ProgressEvent.PROGRESS, onCourseProgress);
			_loader.load(_request);
		}

		private function onCourseLoaded(event:Event):void
		{
			setCourseData(event.target.data);
			setLanguageCode();
			if (_onCourseLoaded != null)
			{
				_onCourseLoaded(event);
			}
		}

		private function onCourseFail(event:*):void
		{
			if (_onCourseFail != null)
			{
				_onCourseFail(event);
			}
		}

		private function onCourseProgress(event:ProgressEvent):void
		{
			if (_onCourseProgress != null)
			{
				_onCourseProgress(event);
			}
		}

		/**
		 * set course data
		 *
		 * **/
		public function setCourseData(dataStr:String):void
		{
			if (dataStr != null && dataStr != "")
			{
				var xmlTree:XML = new XML(dataStr);
				course = new Course();
				course_session = course.session;
				course.courseId = xmlTree.course.CourseId;
				course.courseTitle = xmlTree.course.CourseTitle;
				course.courseDisc = xmlTree.course.CourseDesc;
				course.cueLanguageCode = xmlTree.course.CueLanguageCode;
				course.responseLanguageCode = xmlTree.course.ResponseLanguageCode;
				course.icon = xmlTree.course.Icon;
				course.totalItems = xmlTree.course.TotalItems;
				/**
				* course session
				*
				*/
				course_session = new CourseSession(course.courseId);
				course_session.scheduleMessage = xmlTree.course.ScheduleMessage;
				course_session.totalStudyTime = xmlTree.course.TotalStudyTime;
				/**
				* Check
				*
				*/
				course_session.completed = xmlTree.course.CourseCompleted as Boolean;
				course_session.startDate = xmlTree.course.CourseStartDate;
				course_session.endDate = xmlTree.course.StudyEndDate;
				course_session.progress = xmlTree.course.CourseProgress;
				course_session.itemsNew = xmlTree.course.NewItems;
				course_session.itemsWeak = xmlTree.course.WeakItems;
				course_session.itemsStrong = xmlTree.course.StrongItems;
				course_session.itemsCompleted = xmlTree.course.CompletedItems;
				course.session = course_session;
			}
		}

		private function setLanguageCode():void
		{
			SharedObjectManager.getInstance().currentCourseID = course.courseId;
			LanguageCodeManager.getInstance().cueLanguageCode = course.cueLanguageCode;
			LanguageCodeManager.getInstance().responseLanguageCode = course.responseLanguageCode;
			var lanList:Array = new Array();
			var cueLan:String = String(course.cueLanguageCode);
			var responseLan:String = String(course.responseLanguageCode);
			lanList.push(cueLan);
			lanList.push(responseLan);
			LanguageCodeManager.getInstance().setContentCode(lanList);
		}

		/**
		 * end
		 *
		 **/


		/**
		 * load history data
		 *
		 *
		 * **/
		public function loadUserHistory(date:String = null, callbackDone:Function = null, callbackProgress:Function = null, callbackFail:Function = null):void
		{
			_loader = new URLLoader();
			_userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var user:User = _userProxy.user;
			if (!user.isAuthenticated)
			{
				return;
			}
			var user_id:Number = user.id;
			var now:Date = new Date();
			var url:String = ConstVar.REQUEST_BASE_URL + ConstVar.COURSE_HISTORY_PATH + "&id=" + courseId.toString() + "&user_id=" + user_id.toString() + "&date=" + date + "&v=" + now.getTime()
			_request.url = url;
			_loader.load(_request);
			_loader.addEventListener(Event.COMPLETE, onHistoryLoaded);
			_loader.addEventListener(FaultEvent.FAULT, onHistoryFail);
			_loader.addEventListener(ProgressEvent.PROGRESS, onHistoryProgress);
			_loader.load(_request);
			this._onHistoryLoaded = (callbackDone != null ? callbackDone : null);
			this._onHistoryProgress = (callbackProgress != null ? callbackProgress : null);
			this._onHistoryFail = (callbackFail != null ? callbackFail : null);
		}

		private function onHistoryLoaded(event:Event):void
		{
			var xml_data:String = event.target.data as String;
			if (xml_data.length > 0)
			{
				var xml_tree:XML = new XML(xml_data);
				var historyData:HistoryData = new HistoryData();
				historyData.courseId = Number(xml_tree.ResponseContent.CourseID);
				historyData.courseTitle = xml_tree.ResponseContent.CourseTitle;
				historyData.serverTime = xml_tree.ResponseContent.ServerTime;
				historyData.year = xml_tree.ResponseContent.Year;
				historyData.month = xml_tree.ResponseContent.Month;
				for each (var history:XML in xml_tree.ResponseContent.History.Date)
				{
					var dayData:Object = new Object();
					dayData.year = Number(historyData.year);
					dayData.month = Number(historyData.month);
					dayData.day = Number(history.@day);
					dayData.text = history.@session_count;
					historyData.days.push(dayData);
				}
				if (historyData.days.length > 0)
				{
					var key:String = historyData.year + "-" + historyData.month;
					HistoryData.push(key, historyData);
				}
				_onHistoryLoaded(historyData.days);
			}
		}

		private function onHistoryFail(event:Event):void
		{
			_onHistoryFail(event);
		}

		private function onHistoryProgress(event:ProgressEvent):void
		{
			_onHistoryProgress(event);
		}


		public function skippedItem(itemId:Number = -1, callbackDone:Function = null, callbackProgress:Function = null, callbackFail:Function = null):void
		{
			if (itemId == -1)
			{
				return;
			}
			var now:Date = new Date();
			var url:String = ConstVar.REQUEST_BASE_URL + ConstVar.SKIP_ITEM_PATH + "&id=" + itemId + "&v=" + now.getTime();
			_request.url = url;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onSkippedDone);
			_loader.addEventListener(FaultEvent.FAULT, onSkippedFail);
			_loader.addEventListener(ProgressEvent.PROGRESS, onSkippedProgress);
			_loader.load(_request);
			this._onDataLoaded = (callbackDone != null ? callbackDone : null);
			this._onDataProgress = (callbackProgress != null ? callbackProgress : null);
			this._onDataFail = (callbackFail != null ? callbackFail : null);
		}


		private function onSkippedDone(event:Event):void
		{
			var xml_data:String = event.target.data as String;
			if (xml_data.length > 0)
			{
				var xml_tree:XML = new XML(xml_data);
				var itemId:Number = Number(xml_tree.item.item_id);
				var isSkipped:Boolean = (xml_tree.item.skipped == "true" ? true : false);
				var userId:Number = Number(xml_tree.item.user_id);
				_userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				if (_userProxy.user == null || !_userProxy.user.isAuthenticated || userId != _userProxy.user.id)
				{
					return;
				}
				setSkippedData(itemId, isSkipped);
				sendNotification(ApplicationFacade.RESET_STUDY_DATA);
			}
			if (_onDataLoaded != null)
			{
				_onDataLoaded(isSkipped);
			}
		}

		private function setSkippedData(itemId:Number = -1, skipped:Boolean = false):void
		{
			if (isNaN(itemId))
				return;
			for each (var item:Item in _itemsData)
			{
				if (item.id == Number(itemId))
				{
					var status:ItemStatus = item.session.itemStatus;
					status.isSkipped = skipped;
					break;
				}
			}
		}

		private function onSkippedFail(event:Event):void
		{
			if (_onDataFail != null)
			{
				_onDataFail();
			}
		}

		private function onSkippedProgress(event:Event):void
		{
			if (_onDataProgress != null)
			{
				_onDataProgress();
			}
		}

		/**
		 *	load study data from remote
		 *  return items list
		 *
		 * */
		public function loadStudyData(callbackDone:Function = null, callbackProgress:Function = null, callbackFail:Function = null):void
		{
			this._onDataLoaded = (callbackDone != null ? callbackDone : null);
			this._onDataProgress = (callbackProgress != null ? callbackProgress : null);
			this._onDataFail = (callbackFail != null ? callbackFail : null);
			var now:Date = new Date();
			var url:String = ConstVar.REQUEST_BASE_URL + ConstVar.ITEMS_REQUEST_PATH + "&id=" + courseId + "&v=" + now.getTime();
			_request.url = url;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onDataLoaded);
			_loader.addEventListener(FaultEvent.FAULT, onDataFail);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onDataFail);
			_loader.addEventListener(ProgressEvent.PROGRESS, onDataProgress);
			_loader.load(_request);
		}

		/**
		 * item list parser
		 *
		 * */
		private function onDataLoaded(event:Event):void
		{
			var dataStr:String = event.target.data as String;
			itemsData = [];
			if (dataStr != null)
			{
				var eleRoot:XML = new XML(dataStr.toString());
				var dataFactory:ContentDataFactory = new ContentDataFactory("text");
				try
				{
					var itemsEle:XMLList = eleRoot.items.item;
					if (itemsEle.length() > 0)
					{
						itemsData = dataFactory.parseData(eleRoot);
					}
					else
					{
						course.session.scheduleMessage = eleRoot.items.schedule.@text;
					}
				}
				catch (e:Error)
				{
					itemsData = [];
				}
			}
			if (itemsData.length > 0)
			{

				_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
				_sequenceProxy.initItemsQueue(itemsData);
			}
			this._onDataLoaded();
		}

		/**
		 * failed handler
		 *
		 * **/
		private function onDataFail(event:*):void
		{
			if (_onDataFail != null)
				this._onDataFail();
		}

		private function onDataProgress(event:ProgressEvent):void
		{
			this._onDataProgress();
		}

		/**
		 * save learning data to server
		 *
		 * **/
		public function commitSession(doneHandler:Function = null, progressHander:Function = null, failHandler:Function = null):void
		{
			_onSessionCommitSuc = (doneHandler == null ? null : doneHandler);
			_onSessionCommitProgress = (progressHander == null ? null : progressHander);
			_onSessionCommitFail = (failHandler == null ? null : failHandler);

			_userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			var user:User = _userProxy.user;
			/**
			* Keep user online
			 *
			*/
			if (user.state == UserProxy.USER_STATE)
			{
				try
				{
					var send_flag:Boolean = false;
					var items_session:Array = _sequenceProxy.sessionTable;
					var service:HTTPService = new HTTPService;
					service.url = ConstVar.REQUEST_BASE_URL + ConstVar.COMMIT_SESSION_PATH + "&id=" + courseId;
					service.method = "POST";
					/**
					* data object
					 *
					*/
					var node_root:XML = <study_data></study_data>;
					var node_session:XML = <session></session>;
					node_session.@user_id = user.id;
					node_session.@occurred_at = new Date().time;
					node_session.@course_id = courseId;
					var totalStudyTime:Number = AppTimerManager.getInstance().studyLifeCount;
					node_session.@total_study_time = totalStudyTime;

					for each (var session:ItemSession in items_session)
					{
						var progress:ItemProgress = session.progress;
						var progress_value:Number = progress.getProgress() * 100;
						var new_status:ItemStatus = progress.newItemStatus;
						var old_status:ItemStatus = progress.oldStatus;
						if (progress_value > 0)
						{
							send_flag = true;
							var node_event:XML = <item_event />
							node_event.@item_id = session.itemId;
							node_event.@study_time = session.itemStatus.currentState.performance.studyTimeSec;
							node_event.@is_skipped = new_status.isSkipped;
							node_event.@presentation_count = new_status.presentation_count;
							/**
							* Ratio
							*
							*/
							node_event.@ratio = new_status.ratio;
							node_event.@cumulative_ratio = new_status.cumulative_ratio;
							node_event.@cumulative_ratio_required_to_complete = new_status.cumulative_ratio_required_to_complete;
							/**
							* Calculate some counter
							*
							*/
							new_status.above_threshold_count = progress.getAboveThresholdCount(new_status.ratio, old_status.ratio);
							new_status.below_threshold_count = progress.getBelowThresholdCount(new_status.ratio, old_status.ratio);
							var successRatioThresHold:Number = progress.calculateSuccessRatioThreshold(old_status.success_count);
							new_status.success_count = progress.calculateNewSuccessCount(new_status.ratio, old_status.success_count, successRatioThresHold);
							node_event.@above_threshold_count = new_status.above_threshold_count;
							node_event.@below_threshold_count = new_status.below_threshold_count;
							node_event.@success_count = new_status.success_count;
							/**
							* Progress
							*
							*/
							node_event.@progress = new_status.progress * 100;
							if (old_status.progress > 0)
							{
								course_session.itemsStarted++;
							}
							if (node_event.@progress >= 100)
							{
								course_session.itemsCompleted++;
							}
							if (old_status.isSkipped)
							{
								course_session.itemsSkipped++;
							}
							node_session.appendChild(node_event);
						}
					}
					/**
				   * Current session completed
																																																																																																																																																																																																																																																																																  *
				   */
					node_session.@session_completed = course_session.sessionCompleted;
					/**
					* Item skipped
					*
					*/
					node_session.@items_skipped = course_session.itemsSkipped;
					/**
					* Item started
					*
					*/
					node_session.@items_started = course_session.itemsStarted;
					/**
					* Items complete
					*
					*/
					node_session.@items_seen = course_session.itemsSeen;
					/**
					* Append item session into the body
					 *
					*/
					node_root.appendChild(node_session);
					service.addEventListener(ResultEvent.RESULT, saveDataSuc);
					service.resultFormat = "e4x";
					service.addEventListener(FaultEvent.FAULT, saveDataFail);
					var parameters:Object = new Object();
					parameters.data = node_root.toString();
					service.send(parameters);
				}
				catch (e:Error)
				{

				}
			}
		}

		private function clearupLoader(type:String):void
		{
			switch (type)
			{
				case "course":
					_loader.removeEventListener(Event.COMPLETE, onCourseLoaded);
					_loader.removeEventListener(FaultEvent.FAULT, onCourseFail);
					_loader.removeEventListener(ProgressEvent.PROGRESS, onCourseFail);
					break;
				case "history":
					break;
				case "items":
					break;
			}
		}

		private function saveDataSuc(event:ResultEvent):void
		{
			_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			_sequenceProxy.reSetVars();
			var responseData:XML = XML(event.result);
			if (responseData.ReturnCode == 0)
			{
				if (_onSessionCommitSuc != null)
				{
					_onSessionCommitSuc();
				}
			}
			needReload = true;
		}

		private function saveDataFail(event:Event):void
		{
			if (_onSessionCommitFail != null)
			{
				_onSessionCommitFail();
			}
		}

		/**
		 * Items data array
		 *
		 * **/
		public function get itemsData():Array
		{
			return _itemsData;
		}

		/**
		 * @private
		 */
		public function set itemsData(value:Array):void
		{
			_itemsData = value;
		}

		/**
		 * courseId is set in  SkillUp.mxml when Application is loaded
		 *
		 * **/
		public function get courseId():int
		{
			return _courseId;
		}

		/**
		 * @private
		 */
		public function set courseId(value:int):void
		{
			_courseId = value;
		}


	}
}
