package org.enjoytalk.model.vo
{

	public class SentenceData extends DataContent
	{
		private var _sound:String;
		private var _translation:String;
		private var _transliterations:Array;


		private var _text:String;
		private var _images:Array;

		private var _image:String;
		private var _creator:String;
		private var _source:String;

		public function SentenceData()
		{
			super(DataContent.SENTENCE);
		}

		public function get sound():String
		{
			return _sound;
		}

		public function set sound(value:String):void
		{
			_sound=value;
		}

		public function get translation():String
		{
			return _translation;
		}

		public function set translation(value:String):void
		{
			_translation=value;
		}

		public function get transliterations():Array
		{
			return _transliterations;
		}

		public function set transliterations(value:Array):void
		{
			_transliterations=value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text=value;
		}

		public function get images():Array
		{
			return _images;
		}

		public function set images(value:Array):void
		{
			_images=value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image=value;
		}

		public function get creator():String
		{
			return _creator;
		}

		public function set creator(value:String):void
		{
			_creator=value;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source=value;
		}


	}
}
