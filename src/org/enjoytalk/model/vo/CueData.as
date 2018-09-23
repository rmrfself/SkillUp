package org.enjoytalk.model.vo
{

	public class CueData extends AbstractElement
	{
		private var _text:String;

		private var _character:String;

		private var _sound:String;

		private var _annotation:String;

		private var _partOfSpeech:String;

		public function CueData()
		{
			super(DataContent.CUE);
		}

		public function get character():String
		{
			return _character;
		}

		public function set character(value:String):void
		{
			_character=value;
		}

		public function get sound():String
		{
			return _sound;
		}

		public function set sound(value:String):void
		{
			_sound=value;
		}

		public function get annotation():String
		{
			return _annotation;
		}

		public function set annotation(value:String):void
		{
			_annotation=value;
		}

		public function get partOfSpeech():String
		{
			return _partOfSpeech;
		}

		public function set partOfSpeech(value:String):void
		{
			_partOfSpeech=value;
		}
	}
}
