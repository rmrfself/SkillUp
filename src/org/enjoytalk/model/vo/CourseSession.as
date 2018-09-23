package org.enjoytalk.model.vo
{

	public class CourseSession
	{

		private var _userId:Number;

		private var _courseId:Number;

		/**
		 * browser type
		 * 1. explore browser
		 * 2. types of mobiles type like iphone
		 *
		 * **/
		private var _clientTypeId:Number=0;

		/**
		 * total study time
		 *
		 * **/
		private var _totalStudyTime:Number=0;

		/**
		 * item's seen
		 *
		 * **/
		private var _itemsSeen:Number=0;

		/**
		 * item 's completed count ?
		 *
		 * **/
		private var _sessionCompleted:Number=0;

		/**
		 * skipped?
		 *
		 * **/
		private var _itemsSkipped:Number=0;

		/**
		 * is new?
		 *
		 * **/
		private var _itemsStarted:Number=0;

		/**
		 *
		 * completed
		 *
		 * ***/
		private var _itemsCompleted:Number=0;

		private var _itemsNew:Number=0;

		private var _itemsStrong:Number=0;

		private var _itemsWeak:Number=0;

		private var _scheduleMessage:String="";

		private var _progress:Number=0;

		private var _completed:Boolean=false;

		private var _startDate:String="";

		private var _endDate:String="";

		private var _isOpenEndMode:Boolean=false;

		private var _remainingItemsToStudy:Number;

		private var _isPracticeMode:Boolean=false;

		/**
		  * session begin time
		  *
		  **/
		private var _occurred_at:Number=0;

		public static const COURSE_PROGRESS_DEGREE:Array=[1, 3, 5, 8, 10];


		public function CourseSession(course_id:Number)
		{
			_courseId=course_id;
		}

		[Bindable]
		public function get courseId():Number
		{
			return this._courseId;
		}

		public function set courseId(value:Number):void
		{
			this._courseId=value;
		}

		[Bindable]
		public function get userId():Number
		{
			return this._userId;
		}

		public function set userId(value:Number):void
		{
			this._userId=value;
		}

		[Bindable]
		public function get clientTypeId():Number
		{
			return this._clientTypeId;
		}

		public function set clientTypeId(value:Number):void
		{
			this._clientTypeId=value;
		}

		[Bindable]
		public function get totalStudyTime():Number
		{
			return this._totalStudyTime;
		}

		public function set totalStudyTime(value:Number):void
		{
			this._totalStudyTime=value;
		}

		[Bindable]
		public function get itemsSeen():Number
		{
			return this._itemsSeen;
		}

		public function set itemsSeen(value:Number):void
		{
			this._itemsSeen=value;
		}

		[Bindable]
		public function get sessionCompleted():Number
		{
			return this._sessionCompleted;
		}

		public function set sessionCompleted(value:Number):void
		{
			this._sessionCompleted=value;
		}

		[Bindable]
		public function get itemsSkipped():Number
		{
			return this._itemsSkipped;
		}

		public function set itemsSkipped(value:Number):void
		{
			this._itemsSkipped=value;
		}

		[Bindable]

		public function get itemsStarted():Number
		{
			return this._itemsStarted;
		}

		public function set itemsStarted(value:Number):void
		{
			this._itemsStarted=value;
		}

		[Bindable]
		public function get itemsCompleted():Number
		{
			return this._itemsCompleted;
		}

		public function set itemsCompleted(value:Number):void
		{
			this._itemsCompleted=value;
		}

		[Bindable]
		public function get itemsNew():Number
		{
			return this._itemsNew;
		}

		public function set itemsNew(value:Number):void
		{
			this._itemsNew=value;
		}

		[Bindable]
		public function get itemsWeak():Number
		{
			return this._itemsWeak;
		}

		public function set itemsWeak(value:Number):void
		{
			this._itemsWeak=value;
		}

		[Bindable]
		public function get itemsStrong():Number
		{
			return this._itemsStrong;
		}

		public function set itemsStrong(value:Number):void
		{
			this._itemsStrong=value;
		}

		[Bindable]
		public function get progress():Number
		{
			return this._progress;
		}

		public function set progress(value:Number):void
		{
			this._progress=value;
		}

		[Bindable]
		public function get completed():Boolean
		{
			return this._completed;
		}

		public function set completed(value:Boolean):void
		{
			this._completed=value;
		}

		[Bindable]
		public function get endDate():String
		{
			return this._endDate;
		}

		public function set endDate(value:String):void
		{
			this._endDate=value;
		}

		[Bindable]
		public function get startDate():String
		{
			return this._startDate;
		}

		public function set startDate(value:String):void
		{
			this._startDate=value;
		}

		[Bindable]
		public function get scheduleMessage():String
		{
			return this._scheduleMessage;
		}

		public function set scheduleMessage(value:String):void
		{
			this._scheduleMessage=value;
		}

		public function get remainingItemsToStudy():Number
		{
			return _remainingItemsToStudy;
		}

		public function set remainingItemsToStudy(value:Number):void
		{
			_remainingItemsToStudy=value;
		}
	}
}
