package org.enjoytalk.model.vo
{

	public class DistractorData
	{
		private var _itemId:Number;
		private var _text:String;
		private var _isAnswer:Boolean=false;
		private var _isEnable:Boolean=true;
		private var _language:String="en";
		private var _extraData:String;

		public function DistractorData(id:Number, txt:String)
		{
			this._itemId=id;
			this._text=txt;
		}

		public function get itemId():Number
		{
			return _itemId;
		}

		public function set itemId(value:Number):void
		{
			_itemId=value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text=value;
		}

		public function get isAnswer():Boolean
		{
			return _isAnswer;
		}

		public function set isAnswer(value:Boolean):void
		{
			_isAnswer=value;
		}

		public function get isEnable():Boolean
		{
			return _isEnable;
		}

		public function set isEnable(value:Boolean):void
		{
			_isEnable=value;
		}

		public function get language():String
		{
			return _language;
		}

		public function set language(value:String):void
		{
			_language=value;
		}

		public function get extraData():String
		{
			return _extraData;
		}

		public function set extraData(value:String):void
		{
			_extraData=value;
		}


	}
}
