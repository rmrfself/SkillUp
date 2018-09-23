/**
* EnglishSpell quiz
 *
*/

package org.enjoytalk.view.components.custom
{
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;

	public class EnglishSpellQuiz extends SpellQuiz
	{

		protected var lastSpace:Number=0;
		public var MAX_FAIL:Number=5;
		public static var isChecked:Boolean=false;

		protected var enteredText:String;
		protected var correctText:String;
		protected var result:String;

		public function EnglishSpellQuiz()
		{
			super();
		}

		/**
		 * set charmanager for english;
		 *
		 */
		override public function setCharManager():void
		{
			if (_text)
			{
				_text=_text.replace("\n", "").replace("\r", "");
				this.charManager=new EnglishCharClipManager();
				super.setCharManager();
			}
		}

		override public function unRender():Boolean
		{
			super.unRender();
			charManager.unRender();
			removeChild(this.charManager);
			charManager=null;
			removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			return false;
		}

		override public function remove():Boolean
		{
			return false;
		}

		/**
		 * finish state
		 *
		 */
		override public function finish():void
		{
			charManager.currentClip.highlight(false);
			for (var k:Number=0; k < charManager.charClips.length; k++)
			{
				var clip:CharClip=EnglishCharClip(charManager.charClips[k]);
				clip.animateHideLine();
			}
		}

		/**
		 * checkSpelling
		 *
		 */
		override public function checkSpelling():void
		{
			try
			{
				if (_answered)
				{
					return;
				}
				var gradeLevel:Number=0;
				var strictLevel:Number=this.useStrictSpelling() ? (1) : (2);
				if (charManager.answerLength > 5)
				{
					var enteredText:String=charManager.allEnteredText;
					var correctText:String="";
					for each (var clip:CharClip in charManager.charClips)
					{
						if (clip.isSpell)
						{
							correctText+=clip.correctChar;
						}
					}
					gradeLevel=new SpellCheckerEn().gradeSpelling(enteredText, correctText, null, this.useStrictSpelling());
				}
				else
				{
					enteredText="";
					correctText="";
					var charClips:Array=charManager.charClips;
					for (var k:Number=0; k < charClips.length; k++)
					{
						clip=charClips[k];
						if (clip.isSpell)
						{
							enteredText=enteredText + clip.getChar();
							correctText=correctText + clip.correctChar;
						}
					}
					for (k=0; k < charClips.length; k++)
					{
						if (enteredText.charAt(k) != correctText.charAt(k))
						{
							++gradeLevel;
						}
					}
					strictLevel=this.useStrictSpelling() ? (1) : (3);
				}

				if (gradeLevel >= strictLevel)
				{
					this.onFail(gradeLevel, enteredText, correctText);
				}
				else
				{
					this.onDone(gradeLevel, enteredText, correctText);
				}
			}
			catch (e:Error)
			{
			}
			_answered=true;
		}
	}
}
