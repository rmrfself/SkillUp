package org.enjoytalk.view.components.custom
{

	public class PinyinSpellQuiz extends SpellQuiz
	{
		public static var PINYIN_GOODCHARS:String="āáǎàaīíǐìiūúǔùuēéěèeōóǒòoǖǘǚǜü";
		protected var MAX_FAIL:Number=5;
		protected static var isChecked:Boolean=false;

		protected var enteredText:String;
		protected var correctText:String;
		protected var result:String;

		public function PinyinSpellQuiz()
		{
			super();
			_goodChars=_goodChars + (PinyinSpellQuiz.PINYIN_GOODCHARS + this.validate(additionalGoodChars, ""));
		}

		override public function remove():Boolean
		{
			return false;
		}


		override public function setCharManager():void
		{
			if (_text)
			{
				_text=_text.replace("\n", "").replace("\r", "");
				charManager=new PinyinCharClipManager();
				super.setCharManager();
			}
		}

		override public function finish():void
		{
			charManager.currentClip.highlight(false);
			charManager.finishQuiz();
		}

		public function onSuccessHandler():void
		{
			this.onDone(result, enteredText, correctText);
		}

		public function onFailHandler():void
		{
			this.onFail(result, enteredText, correctText);
		}

		override public function set charManager(value:CharClipManager):void
		{
			this._char_manger=value;
		}

		override public function get charManager():CharClipManager
		{
			return this._char_manger;
		}

	}
}
