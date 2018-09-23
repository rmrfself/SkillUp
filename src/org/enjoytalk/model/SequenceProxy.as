/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: CourseProxy
 * Rebuild-history:
 *
 * 1. 2009/08/24
 * 2. 2009/08/27
 * 3. 2011/01/27
 *
 **/

package org.enjoytalk.model
{

	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.vo.CourseSession;
	import org.enjoytalk.model.vo.Item;
	import org.enjoytalk.model.vo.ItemProgress;
	import org.enjoytalk.model.vo.ItemSession;
	import org.enjoytalk.model.vo.ItemStatus;
	import org.enjoytalk.model.vo.Queue;
	import org.enjoytalk.model.vo.Quiz;
	import org.enjoytalk.view.components.custom.AppTimerManager;
	import org.enjoytalk.view.components.custom.SharedObjectManager;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class SequenceProxy extends Proxy
	{
		/**
		 *  const variables
		 *
		 * **/
		public static const NAME:String = "SequenceProxy";

		public static const ACTIVE_ITEMS_LENGTH:int = 3;

		private var _courseProxy:CourseProxy;

		public var _courseSession:CourseSession;

		private var _courseProgress:Number = 0;

		/**
		 * item we are learning .
		 *
		 * **/
		private var _currentItem:Item;

		private var _currentSession:ItemSession;

		/**
		 * store the info of front item
		 *
		 * **/
		private var _oldItem:Item;

		/**
		 * items are splitted into two queues ,one is active ,another is not .
		 *
		 * **/
		private var _activeQueue:Queue;
		private var _inactiveQueue:Queue;
		private var _completedQueue:Queue;

		private var _originList:Array = new Array();
		private var _studyData:Array = new Array();
		private var _unSkippedData:Array = new Array();
		private var _sessionTable:Array = new Array();
		private var _sessionLength:Number = 0;

		private var _isStarted:Boolean = false;

		private var _completed:Boolean = false;

		public static const DEFUALT_ITEMS_COUNT:Number = 5;

		/**
		 *
		 * @param data
		 *
		 * Initialize data
		 *
		 */
		public function SequenceProxy(data:Object = null)
		{
			super(NAME, data);
			initialize();
		}

		public function get isStarted():Boolean
		{
			return _isStarted;
		}

		public function set isStarted(value:Boolean):void
		{
			_isStarted = value;
		}

		private function initialize():void
		{
			_courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
			_courseSession = _courseProxy.course_session;
		}


		public function setStudyData():void
		{
			_sessionLength = SharedObjectManager.getInstance().sessionLength;
			if (!isNaN(_sessionLength))
			{
				var dataLen:Number = _studyData.length;
				_studyData = (dataLen > _sessionLength ? _studyData.slice(0, _sessionLength) : _studyData);
			}
			unSkippedData = new Array();
			var queueData:Array = new Array();
			for each (var data:Item in _studyData)
			{
				var sessionData:ItemSession = data.session;
				if ((!sessionData.itemStatus.isSkipped) && sessionData.itemStatus.progress < 100)
				{
					unSkippedData.push(data);
					_sessionTable.push(data.session);
					queueData.push(data);
				}
			}

			if (queueData.length == 0)
			{
				return;
			}
			/**
			 * completed session list
			 *
			 * **/
			_inactiveQueue = new Queue();
			_completedQueue = new Queue();
			var activeLength:Number = (queueData.length > ACTIVE_ITEMS_LENGTH ? ACTIVE_ITEMS_LENGTH : queueData.length);
			_activeQueue = new Queue();
			var _tmp:Array = queueData.splice(0, activeLength);

			/**
			 * init active queue
			 *
			 * **/
			for each (var item:Item in _tmp)
			{
				_activeQueue.push(item);
			}

			if (queueData.length > 0)
			{
				for each (item in queueData)
				{
					_inactiveQueue.push(item);
				}
			}
		}

		/**
		 * inititialize loop queue
		 *
		 * **/
		public function initItemsQueue(itemsData:Array):void
		{
			originList = itemsData;
			studyData = itemsData;
			_unSkippedData = new Array();
			_sessionTable = new Array();
			_sessionLength = 0;
			_isStarted = false;
			_completed = false;
		}

		/**
		 * kernel route function
		 *
		 * */
		public function doSequence():void
		{
			updateItemSession();
			updateActiveItems();
			renderViews();
			addingWatchDog();
			isStarted = true;
		}

		/**
		 *
		 * Update items queue  , make sure every item is learned normally.
		 * set _currentItem
		 * set _currentSession;
		 *
		 * **/
		private function updateActiveItems():void
		{
			/**
			 * initialize _currentItem
			 *
			 * **/
			if (_currentItem == null)
			{
				_currentItem = _activeQueue.next() as Item;
				_currentSession = _currentItem.session;
				_oldItem = _currentItem;
				sendNotification(ApplicationFacade.GOTO_NEXT_ITEM);
				return;
			}
			/**
			 *  switch big item out of queue
			 *
			 * **/
			if (_currentSession.isBlocked)
			{
				var deplicated_item:Item;
				var new_item:Item;
				var sort_arr:Array;
				if (_inactiveQueue.length > 0)
				{
					if (_currentSession.completed)
					{
						_completedQueue.push(_currentItem);
					}
					else
					{
						_inactiveQueue.push(_currentItem);
					}
					new_item = _inactiveQueue.splice(0, 1)[0] as Item;
					/**
					 * swap the _currentItem out of queue
					 *
					 * **/
					var current_index:Number = _activeQueue.indexOf(_currentItem);
					if (current_index > -1)
					{
						_activeQueue[current_index] = new_item;
					}
					_currentItem = new_item;
					_currentSession = _currentItem.session;
				}
				else
				{
					if (_currentSession.completed)
					{
						deplicated_item = _activeQueue.remove(_currentItem) as Item;
						_completedQueue.push(deplicated_item);
						_courseProxy.course_session.sessionCompleted++;
					}
					if (_activeQueue.length > 0)
					{
						_currentItem = _activeQueue.next() as Item;
						_currentSession = _currentItem.session;
					}
				}
			}
			else
			{
				_currentItem = _activeQueue.next() as Item;
				_currentSession = _currentItem.session;
			}
			if (_currentItem)
			{
				sendNotification(ApplicationFacade.GOTO_NEXT_ITEM);
			}
		}

		public function renderViews():void
		{

			var params:Object;
			if (_activeQueue.empty() && _currentSession.completed)
			{
				sendNotification(ApplicationFacade.VIEW_COMPLETED);
				return;
			}
			switch (_currentSession.itemStatus.currentState.getPresenter())
			{
				case ItemStatus.STATE_VALUE[ItemStatus.STUDY]:
					sendNotification(ApplicationFacade.VIEW_STUDY);
					break;
				case ItemStatus.STATE_VALUE[ItemStatus.RESTUDY]:
					params = new Object();
					params._isReversed = true;
					sendNotification(ApplicationFacade.VIEW_RESTUDY, params);
					break;
				case ItemStatus.STATE_VALUE[ItemStatus.TWOBUTTONRECALL]:
					var state_value:Number = _currentSession.itemStatus.currentState.stateValue;
					params = new Object();
					if (state_value == ItemStatus.MCQUIZ_REVERSE)
					{
						params._isReversed = true;
					}
					sendNotification(ApplicationFacade.VIEW_RECALL, params);
					break;
				case ItemStatus.STATE_VALUE[ItemStatus.MCQUIZ_FIVE]:
					params = new Object();
					params._itemsCount = 5;
					sendNotification(ApplicationFacade.VIEW_MCQUIZ, params);
					break;
				case ItemStatus.STATE_VALUE[ItemStatus.MCQUIZ_TEN]:
					params = new Object();
					params._itemsCount = 10;
					sendNotification(ApplicationFacade.VIEW_MCQUIZ, params);
					break;
				case ItemStatus.STATE_VALUE[ItemStatus.MCQUIZ_REVERSE]:
					params = new Object();
					params._itemsCount = 5;
					params._isReversed = true;
					sendNotification(ApplicationFacade.VIEW_MCQUIZ, params);
					break;
				case ItemStatus.STATE_VALUE[ItemStatus.SPELL]:
					sendNotification(ApplicationFacade.VIEW_SPELL);
					break;
			}
		}

		public function reSetVars():void
		{
			_originList = null;
			_studyData = null;
			_courseProgress = 0;
			_sessionTable = null;
			_currentItem = null;
			_currentSession = null;
			_courseSession = null;
			_activeQueue = null;
			_inactiveQueue = null;
			_completedQueue = null;
			isStarted = false;
		}

		public function addingWatchDog():void
		{
			var appTimer:AppTimerManager = AppTimerManager.getInstance();
			appTimer.registerTimerJob(AppTimerManager.ITEM_TIMER, updateItemLife);
		}

		private function updateItemLife():void
		{
			if (currentItem)
			{
				var itemSession:ItemSession = currentItem.session;
				itemSession.itemStatus.currentState.performance.studyTimeSec++;
			}
		}

		public function get debugStateInfo():String
		{
			var result:String = "";
			for each (var session:ItemSession in this._sessionTable)
			{
				result = result + "==========================================";
				var progress:ItemProgress = session.progress;
				var progress_value:Number = progress.getProgress() * 100;
				var new_status:ItemStatus = progress.newItemStatus;
				var old_status:ItemStatus = progress.oldStatus;
				if (progress_value > 0)
				{
					result = result + "id: " + session.itemId + "\n";
					result = result + "studyTimeSec: " + session.itemStatus.currentState.performance.studyTimeSec + "\n";
					result = result + "is_skipped: " + new_status.isSkipped + "\n";
					result = result + "presentation_count: " + new_status.presentation_count + "\n";
					result = result + "ratio: " + new_status.ratio + "\n";
					result = result + "cumulative_ratio_required_to_complete: " + new_status.cumulative_ratio_required_to_complete + "\n";
					result = result + "above_threshold_count: " + progress.getAboveThresholdCount(new_status.ratio, old_status.ratio) + "\n";
					result = result + "below_threshold_count: " + progress.getBelowThresholdCount(new_status.ratio, old_status.ratio) + "\n";
					result = result + "successRatioThresHold: " + progress.calculateSuccessRatioThreshold(old_status.success_count) + "\n";
					var successRatioThresHold:Number = progress.calculateSuccessRatioThreshold(old_status.success_count);
					result = result + "success_count: " + progress.calculateNewSuccessCount(new_status.ratio, old_status.success_count, successRatioThresHold) + "\n";
					result = result + "above_threshold_count: " + new_status.above_threshold_count + "\n";
					result = result + "below_threshold_count: " + new_status.below_threshold_count + "\n";
					result = result + "success_count: " + new_status.success_count + "\n";
					result = result + "progress: " + new_status.progress * 100 + "\n";
				}
			}
			return result;
		}


		private function updateItemSession():void
		{
			if (_currentSession)
			{
				sendNotification(ApplicationFacade.UPDATE_ITEM_PHASE);
			}
		}


		public function get currentItem():Item
		{
			return _currentItem;
		}

		public function set currentItem(value:Item):void
		{
			this._currentItem = value;
		}

		public function get currentSession():ItemSession
		{
			return _currentSession;
		}

		private function compareBySize(a:Object, b:Object):Number
		{
			if (a > b)
				return 1;
			if (a == b)
				return 0;
			if (a < b)
				return -1;
			return 0;
		}

		public function get courseProgess():Number
		{
			return this._courseProgress;
		}

		public function set courseProgress(value:Number):void
		{
			this._courseProgress = value;
		}

		/**
		 * origin items fetched from course.
		 *
		 * **/
		public function get originList():Array
		{
			if (_originList == null && _courseProxy)
			{
				_originList = _courseProxy.itemsData;
			}
			return _originList;
		}

		/**
		 * @private
		 */
		public function set originList(value:Array):void
		{
			_originList = value;
		}

		public function set currentSession(value:ItemSession):void
		{
			_currentSession = value;
		}

		public function get sessionTable():Array
		{
			return _sessionTable;
		}

		public function get studyData():Array
		{
			return _studyData;
		}

		public function set studyData(data:Array):void
		{
			_studyData = new Array();
			if (data != null && data.length > 0)
			{
				for each (var item:* in data)
				{
					_studyData.push(item);
				}
			}
		}

		public function get unSkippedData():Array
		{
			return _unSkippedData;
		}

		public function set unSkippedData(value:Array):void
		{
			_unSkippedData = value;
		}

		public function get sessionLength():Number
		{
			return _sessionLength;
		}

		public function set sessionLength(value:Number):void
		{
			_sessionLength = value;
		}


	}
}
