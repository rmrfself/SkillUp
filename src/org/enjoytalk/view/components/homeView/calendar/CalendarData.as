package org.enjoytalk.view.components.homeView.calendar
{

	public class CalendarData
	{
		private var _date:Date;
		private var _option:Object;


		public function get date():Date
		{
			return _date;
		}

		public function set date(value:Date):void
		{
			this._date=value;
		}

		public function get option():Object
		{
			return _option;
		}

		public function set option(value:Object):void
		{
			this._option=value;
		}
	}
}