package org.enjoytalk.model.vo
{

	public class ResponseData extends AbstractElement
	{
		private var _sound:String;

		public function ResponseData(responseType:String=null)
		{
			super(this.validate(responseType, DataContent.RESPONSE));
		}

		public function get sound():String
		{
			return _sound;
		}

		public function set sound(value:String):void
		{
			_sound = value;
		}

	}
}
