package org.enjoytalk.model.vo
{

	public class AbstractElement extends DataContent
	{
		private var _spellQuiz:Quiz;
		private var _mcQuiz:Quiz;

		private var _id:Number;

		private var _text:String;

		private var _romanized:String;


		protected function validate(src:*, obj:*):*
		{
			return (src == null ? obj : src);
		}

		public function AbstractElement(type:String)
		{
			super(type);
		}

		public function get spellQuiz():Quiz
		{
			return _spellQuiz;
		}

		public function set spellQuiz(value:Quiz):void
		{
			_spellQuiz=value;
		}

		public function get mcQuiz():Quiz
		{
			return _mcQuiz;
		}

		public function set mcQuiz(value:Quiz):void
		{
			_mcQuiz=value;
		}

		public function get id():Number
		{
			return _id;
		}

		public function set id(value:Number):void
		{
			_id=value;
		}

		public function get romanized():String
		{
			return _romanized;
		}

		public function set romanized(value:String):void
		{
			_romanized=value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text=value;
		}

	}
}
