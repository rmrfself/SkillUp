/**
*  English char clips
 *
 *
*/
package org.enjoytalk.view.components.custom
{
	import flash.text.TextFormat;

	public class EnglishCharClipManager extends CharClipManager
	{
		protected var markUp:Boolean=false;

		protected var _highlighting:Boolean=false;

		protected var currentMarkup:Object;

		protected var _correctionMode:Boolean=false;

		protected var _wrongSpellCount:Number=0;

		protected var _answerLength:Number=0;

		public function EnglishCharClipManager()
		{
			super();
		}

		/**
		 * layout function
		 *
		 */
		override public function layOutClips():void
		{
			super.layOutClips();
			spellLength=this.correctText.split(" ").join("").length;
		}


		override public function unRender():void
		{
			super.unRender();
			currentMarkup=null;
		}

		override public function markup(doShow:Boolean):void
		{
			markedUp=doShow;
			this.fillMissingSpaces(this.currentIndex);
			if (!doShow)
			{
				this.hideCorrection();
			}
			else
			{
				if (this.currentClip.isSpace())
				{
					this.moveForward();
				}
				var k:Number;
				k=lastSpace == 0 ? (0) : (lastSpace + 1);
				var haveSpace:Boolean;
				if (lastSpace <= this.currentIndex)
				{
					haveSpace=true;
					if (lastSpace > 0 && this.currentIndex >= lastSpace)
					{
						k=lastSpace + 1;
					}
				}
				else
				{
					haveSpace=false;
					k=lastSpace;
				}
				var startIndex:Number=-1;
				var endIndex:Number=-1;
				if (haveSpace)
				{
					startIndex=k;
					endIndex=this.getNextSpace(this.currentIndex);
				}
				else
				{
					startIndex=this.getPrvSpace(k);
					endIndex=k;
				}
				currentMarkup={start: startIndex, end: endIndex};
				this.showMarkup(startIndex, endIndex, true);
			}
		}

		override public function showMarkup(start:Number, end:Number, doShow:Boolean):void
		{
			var markedWord:String="";
			for (var k:Number=start; k <= end; k++)
			{
				var charClip:CharClip=this.getClip(k);
				if (!charClip.isSpace())
				{
					markedWord=markedWord + charClip.correctChar
					if (doShow && charClip.isSpell)
					{
						charClip.showCorrectChar();
						charClip.setWrongColor();
					}
				}
			}
		}

		public function hideMarkup():void
		{
			if (currentMarkup != null)
			{
				var startIndex:Number=currentMarkup.start;
				var endIndex:Number=currentMarkup.end;
				if (startIndex != -1 && endIndex != -1)
				{
					for (var k:Number=startIndex; k <= endIndex; k++)
					{
						var clip:CharClip=this.getClip(k);
						if (!clip.isSpace() && clip.isSpell)
						{
							clip.showChar();
							clip.setNormalColor();
						}
					}
					this.select(this.currentIndex);
				}
			}
		}

		override public function clearFrom(index:Number):void
		{
			super.clearFrom(index);
		}

		override public function backSpaceOnce():void
		{
			this.hideCorrection();
			var isBlank:Boolean=this.getClip(this.currentIndex).isBlank();
			this.currentClip.setChar(" ");
			this.currentClip.animateBackspace();
			this.clearFrom(currentClip.index + 1);
			if (isBlank)
			{
				this.getPreviousClip().setChar(" ");
			}
			lastCorrect=currentIndex;
			this.select(this.currentIndex);
		}

		override public function moveForward():void
		{
			this.hideCorrection();
			this.checkSpace();
			if (!this.isEnd)
			{
				this.getNextClip();
			}
		}

		override public function moveBackward():void
		{
			this.hideCorrection();
			this.checkSpace();
			this.getPreviousClip();
		}

		public function checkEnd(index:Number):Boolean
		{
			var m:Number=-1;
			for (var k:Number=this.length; k > 0; k--)
			{
				if (charClips[k].isSpell && !charClips[k].isSpace())
				{
					m=k;
					break;
				}
			}
			if (m == index)
			{
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param sChar
		 * @return
		 *
		 */
		override public function process(sChar:String):Boolean
		{
			try
			{
				var isSpace:Boolean=currentClip.isSpace();
				checkSpace();
				sChar=sChar.toLowerCase();

				if (!checkGoodChar(sChar))
				{
					return false;
				}
				else
				{
					this.typeLetter(sChar);
				}
				currentClip.setNormalColor();
				if (sChar == " ")
				{
					if (isSpace)
					{
						getNextClip();
					}
					else
					{
						this.select(currentClip.index);
					}
				}
				else if (!isEnd)
				{
					getNextClip();
				}
				else
				{
					this.select(this.currentIndex);
				}
			}
			catch (e:Error)
			{
			}
			return true;
		}

		override public function typeLetter(sChar:String):void
		{
			this.hideCorrection();
			currentClip.setChar(sChar.toString());
			this.currentClip.animateEnter();
			lastTypedClip=this.currentClip;
			if (!this.isEnd)
			{
				this.currentClip.setNormalColor();
				this.fillMissingSpaces(this.currentIndex);
			}
		}

		public function hideCorrection():void
		{
			if (_highlighting)
			{
				this.clearWrongLetters();
				_highlighting=false;
			}
			this.hideMarkup();
		}


		override public function fillMissingSpaces(nCurrentIdx:Number):Number
		{
			var spaceClip:CharClip=this.getClip(nCurrentIdx);
			var corStr:String=spaceClip.correctChar
			var charStr:String=spaceClip.getChar();
			if (nCurrentIdx < 0)
			{
				this.select(0);
			}
			if (!spaceClip.isWrongAnswer && !this.checkEnd(nCurrentIdx))
			{
				lastCorrect=nCurrentIdx;
				return (nCurrentIdx);
			}
			if (spaceClip.isSpace())
			{
				var nextClip:CharClip=this.findNextEditableClip();
				nextClip.setChar(charStr);
				spaceClip.setChar(" ");
				nCurrentIdx=nextClip.index;
				this.select(nCurrentIdx);
			}
			return this.currentIndex;
		}

		override public function getNextClip():CharClip
		{
			if (!_correctionMode)
			{
				return (super.getNextClip());
			}
			this.findNextEditableClip();
			for (var k:Number=this.currentIndex + 1; k < charClips.length; k++)
			{
				var charClip:CharClip=charClips[k];
				if (charClip.isSpace())
				{
					lastSpace=k;
					continue;
				}
				if (charClip.isSpell)
				{
					for (var m:Number=k + 1; m < charClips.length; m++)
					{
						if (charClips[m].isSpell)
						{
							break;
						}
					}
					_maxCharPos=k;
					return (this.select(k));
					continue;
				}
				charClip.setChar(charClip.correctChar);
			}
			return this.currentClip;
		}

		override public function getPreviousClip():CharClip
		{
			if (!_correctionMode)
			{
				return (super.getPreviousClip());
			}
			for (var k:Number=currentClip.index - 1; k >= 0; k--)
			{
				if (charClips[k].isSpace())
				{
					lastSpace=k;
					continue;
				}
				if (charClips[k].isSpell)
				{
					_maxCharPos=k;
					return this.select(k);
				}
			}
			return currentClip;
		}

		override public function checkSpelling(index:Number, doOnDone:Boolean, forceCheck:Boolean):Boolean
		{
			_highlighting=true;
			index=this.validate(index, this.length);
			var wrongIndex:Number=-1;
			var isSpace:Boolean=false;
			var wrongCount:Number=0;
			for (var k:Number=0; k < this.length; k++)
			{
				if (this.getClip(k).isWrongAnswer)
				{
					if (wrongIndex == -1)
					{
						wrongIndex=k;
					}
					this.getClip(k).setWrongColor();
					this.getClip(k).highlight(false);
					++wrongCount;
					++_wrongSpellCount;
					continue;
				}
				if (!this.getClip(k).isSpace() && this.getClip(k).isSpell)
				{
					this.getClip(k).setIsSpell(false);
					isSpace=true;
				}
			}
			if (wrongCount == 0)
			{
				this.allCorrect(index, doOnDone);
				return true;
			}
			else
			{
				if (isSpace)
				{
					_correctionMode=true;
				}
				_answerLength=this.currentIndex + 1;
				this.failHandler();
				this.select(wrongIndex);
				lastSpace=0;
				return (false);
			}
		}

		public function get correctionMode():Boolean
		{
			return _correctionMode;
		}

		public function set correctionMode(value:Boolean):void
		{
			_correctionMode=value;
		}
	}
}
