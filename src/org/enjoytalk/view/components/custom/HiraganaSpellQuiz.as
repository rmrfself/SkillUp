package org.enjoytalk.view.components.custom
{
	import flash.text.TextFormat;

	public class HiraganaSpellQuiz extends SpellQuiz
	{

		private var _needToDisplayCharacters:Boolean=false;

		public function HiraganaSpellQuiz()
		{
			super();
			_goodChars=StringTools.HIRAGANA + StringTools.KATAGANA + this.validate(additionalGoodChars, "");
		}


		override public function setCharManager():void
		{
			if (_text)
			{
				_text=_text.replace("\n", "").replace("\r", "");
				charManager=new HiraganaCharClipManager();
				super.setCharManager();
				if (needToDisplayCharacters)
				{
					this.displayCharacter();
				}
			}
		}

		private function displayCharacter():void
		{
			if (_characters != "" && _characters != null)
			{

			}
		}

		override public function onKeyEventHandler(nKeyCode:Number):void
		{
			if (charManager.processKeyCode(nKeyCode))
			{
				this.playTypingEffectSound();
			}
		}

		/**
		 * finish
		 *
		 */
		override public function finish():void
		{
			charManager.finishQuiz();
		}

		override public function checkSpelling():void
		{
			charManager.checkBuffer();
			var enteredText:String=this.getAllEnteredText();
			var correctText:String=this.getAllCorrectText();
			var gradeLevel:Number=new SpellCheckerJp().gradeSpelling(enteredText, correctText, false);
			var strictLevel:Number=(this.useStrictSpelling() || _forceToUseStricMode || charManager.spellLength < 4) ? (1) : (2);
			if (gradeLevel >= strictLevel)
			{
				onFail(gradeLevel, enteredText, correctText);
			}
			else
			{
				onDone(gradeLevel, enteredText, correctText);
			}
		}


		public function get needToDisplayCharacters():Boolean
		{
			return _needToDisplayCharacters;
		}

		public function set needToDisplayCharacters(value:Boolean):void
		{
			_needToDisplayCharacters=value;
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
