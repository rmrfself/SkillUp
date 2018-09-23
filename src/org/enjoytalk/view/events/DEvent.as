package org.enjoytalk.view.events
{
	import flash.events.Event;

	public class DEvent extends Event
	{
		private var _data:Object;

		public function DEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}

		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			this._data = value;
		}

	}
}