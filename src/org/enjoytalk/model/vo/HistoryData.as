package org.enjoytalk.model.vo
{
	import flash.utils.Dictionary;

	public class HistoryData
	{
		private var _courseTitle:String;
		private var _courseId:Number
		private var _serverTime:String;

		private var _year:Number;
		private var _month:Number;
		private var _days:Array;

		private var _date:Date;

		public static var dataContainer:Dictionary=new Dictionary();

		public function HistoryData()
		{
			_days=new Array();
			_date=new Date();
			this._year=_date.fullYear;
			this._month=_date.month + 1;
		}

		public static function checkLoadedData(key:String):*
		{
			if (key == null)
				return null;
			if (dataContainer[key] != null)
			{
				return HistoryData(dataContainer[key]);
			}
			return null;
		}

		public static function push(key:String, value:*):void
		{
			if (key != null && value != null)
			{
				HistoryData[key]=value;
			}
		}

		public function get courseTitle():String
		{
			return _courseTitle;
		}

		public function set courseTitle(value:String):void
		{
			_courseTitle=value;
		}

		public function get courseId():Number
		{
			return _courseId;
		}

		public function set courseId(value:Number):void
		{
			_courseId=value;
		}

		public function get serverTime():String
		{
			return _serverTime;
		}

		public function set serverTime(value:String):void
		{
			_serverTime=value;
		}

		public function get year():Number
		{
			return _year;
		}

		public function set year(value:Number):void
		{
			_year=value;
		}

		public function get month():Number
		{
			return _month;
		}

		public function set month(value:Number):void
		{
			_month=value;
		}

		public function get days():Array
		{
			return _days;
		}

		public function set days(value:Array):void
		{
			_days=value;
		}

		public function get date():Date
		{
			return _date;
		}

		public function set date(value:Date):void
		{
			_date=value;
		}


	}
}
