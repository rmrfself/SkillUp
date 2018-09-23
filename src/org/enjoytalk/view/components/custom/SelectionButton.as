package org.enjoytalk.view.components.custom
{
	import spark.components.Button;

	[SkinState("rightAnswer")]
	[SkinState("wrongAnswer")]
	[SkinState("showAnswer")]
	public class SelectionButton extends Button
	{
		public function SelectionButton()
		{
			super();
		}
		private var _isRightAnswer:Boolean=false;
		private var _isWrongAnswer:Boolean=false;
		private var _showAnswer:Boolean=false;

		public function get isWrongAnswer():Boolean
		{
			return _isWrongAnswer;
		}

		public function set isWrongAnswer(value:Boolean):void
		{
			_isWrongAnswer=value;
		}

		public function get isRightAnswer():Boolean
		{
			return _isRightAnswer;
		}

		public function set isRightAnswer(value:Boolean):void
		{
			_isRightAnswer=value;
		}

		public function get showAnswer():Boolean
		{
			return _showAnswer;
		}

		public function set showAnswer(value:Boolean):void
		{
			_showAnswer=value;
		}

		override protected function getCurrentSkinState():String
		{
			if (isWrongAnswer)
			{
				return "wrongAnswer";
			}

			if (isRightAnswer)
			{
				return "rightAnswer";
			}
			if (showAnswer)
			{
				return "showAnswer";
			}
			return super.getCurrentSkinState();
		}

	}
}
