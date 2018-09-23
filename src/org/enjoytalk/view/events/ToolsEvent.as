package org.enjoytalk.view.events
{
	import flash.events.Event;

	public class ToolsEvent extends Event
	{
		private var _data:Object;

		public function ToolsEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this._data = data;
		}

		public function set data(value:Object):void
		{
			this._data = value;
		}

		public function get data():Object
		{
			return _data;
		}

	}
}