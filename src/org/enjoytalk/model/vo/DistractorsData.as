package org.enjoytalk.model.vo
{

	public class DistractorsData
	{
		private var _texts:Array;
		private var _length:Number;
		private var _language:String="en";


		public function getDistractors(type:String="text"):Array
		{
			if (_texts == null)
			{
				_texts=new Array();
			}
			return _texts;
		}

		public function get texts():Array
		{
			return _texts;
		}

		public function set texts(value:Array):void
		{
			_texts=value;
		}

		public function randomize(type:String="text"):Array
		{
			return this.getDistractors(type).ranomize();
		}

		public function get length():Number
		{
			if (_texts == null)
			{
				_texts=new Array();
			}
			return _texts.length;
		}

		public function get language():String
		{
			return _language;
		}

		public function set language(value:String):void
		{
			_language = value;
		}


		public function DistractorsData()
		{
		}
	}
}
