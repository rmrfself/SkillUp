/**
* MovieClip manager origen class
*
*
*/
package org.enjoytalk.view.components.custom
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import flashx.textLayout.formats.BaselineOffset;

	 

	public class CharClipManager extends MovieClip
	{
		public static const CHAR_XGAP:Number=1;

		public var charClips:Array;

		public var _sGoodChars:String;

		protected var _correct_text:String;

		protected var _all_entered_text:String;

		protected var _all_correct_text:String;

		protected var _current_index:Number=0;

		protected var _last_correct:Number=0;

		protected var _last_space:Number=0;

		protected var _current_clip:CharClip;

		protected var _last_typed_clip:CharClip;

		protected var _answer_length:Number=0;

		protected var _cursor_index:Number=0;

		protected var _entered_text:String;

		protected var _is_all_correct:Boolean=false;

		protected var _is_end:Boolean=false;

		protected var _length:Number=0;

		protected var _spell_length:Number=0;

		protected var _wrong_spell_count:Number=0;

		protected var _max_try_time:Number=0;

		protected var _maxCharPos:Number=0;

		public static const MAX_TRY_TIME:Number=10;

		protected var _nWd:Number;

		protected var _nHt:Number;

		protected var _spellTaggedCharLength:Number=0;

		public var _charForWidth:String="m";

		protected var markedUp:Boolean=false;

		protected var lastCheckedSpace:Number=0;

		public var successHandler:Function;

		public var failHandler:Function;

		public function CharClipManager()
		{
			super();
		}

		/**
		 *
		 * @param nWd
		 * @param nHt
		 * set the content area size for scroll;
		 *
		 */
		public function setSize(nWd:Number, nHt:Number):void
		{
			_nWd=nWd;
			_nHt=nHt;
		}

		/**
		 *
		 * @param color
		 *
		 */
		public function setCustomColor(color:Number):void
		{
			for each (var clip:CharClip in charClips)
			{
				clip.setCustomColor(color);
			}
		}

		public function isCharIndexEnd(charIndex:Number):Boolean
		{
			return (Boolean(charIndex >= charClips.length));
		}

		/**
		 * highLight all clips
		 *
		 */
		public function highlightAll(doHL:Boolean):void
		{
			for (var k:Number=0; k < this.length; k++)
			{
				charClips[k].highlight(doHL);
			}
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get isEnd():Boolean
		{
			for (var k:Number=0; k < charClips.length; k++)
			{
				if (charClips[k].isSpell && charClips[k].isBlank() && !charClips[k].isSpace())
				{
					return false;
				}
			}
			return true;
		}

		public function unRender():void
		{
			for (var k:Number=0; k < charClips.length; k++)
			{
				var clip:CharClip=charClips[k];
				clip.unRender();
				this.removeChild(clip);
			}
			charClips=null;
			currentClip=null;
			successHandler=failHandler=null;
		}

		public function clearWrongLetters():void
		{
			for (var k:Number=0; k < this.length; k++)
			{
				if (charClips[k].isSpell && charClips[k].isWrongAnswer())
				{
					charClips[k].setChar(" ").setNormalColor();
				}
			}
		}

		/**
		 * clear all chars input
		 *
		 */
		public function clearAll():void
		{
			this.clearFrom(0);
			this.select(0);
		}

		/**
		 *
		 * @param index
		 *
		 */
		public function clearFrom(index:Number):void
		{
			for (var k:Number=index; k < _maxCharPos + 2; k++)
			{
				if (charClips[k] != null && charClips[k].isSpell)
				{
					charClips[k].setChar(" ");
					charClips[k].setNormalColor();
				}
			}
		}

		/**
		 *
		 * @param index
		 * @return
		 *
		 */
		public function getClip(index:Number):CharClip
		{
			return charClips[index];
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getNextClip():CharClip
		{
			for (var k:Number=currentClip.index + 1; k < charClips.length; k++)
			{
				var clip:CharClip=charClips[k];
				if (clip.isSpace())
				{
					this.lastSpace=k;
					continue;
				}
				if (clip.isSpell)
				{
					for (var j:Number=k + 1; j < charClips.length; j++)
					{
						if (charClips[j].isSpell)
						{
							break;
						}
					}
					_maxCharPos=k;
					return (this.select(k));
					continue;
				}
				charClips[k].setChar(charClips[k].correctChar);
			}
			return currentClip;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getPreviousClip():CharClip
		{
			for (var k:Number=currentClip.index - 1; k >= 0; k--)
			{
				var clip:CharClip=charClips[k];
				if (clip.isSpace())
				{
					lastSpace=k;
					continue;
				}
				if (charClips[k].isSpell)
				{
					_maxCharPos=k;
					return (this.select(k));
				}
			}
			return currentClip;
		}


		/**
		 * highLight wrong clip
		 *
		 */
		public function highLightWrongClips():void
		{
			for (var k:Number=0; k < charClips.length; k++)
			{
				if (charClips[k].isSpell && charClips[k].getChar().toLowerCase() != charClips[k].getCorrectChar().toLowerCase())
				{
					charClips[k].setWrongColor();
				}
			}
			return;
		}

		/**
		 *
		 * @param sText
		 * @param sGoodChars
		 * @param fontSize
		 *
		 */
		public function createCharClips(sText:String, sGoodChars:String, fontSize:Number):void
		{
			_sGoodChars=this.validate(sGoodChars, SpellQuiz.GOODCHARS);
			fontSize=this.validate(fontSize, 22);
			this.charClips=[];
			var charClip:EnglishCharClip;
			for (var k:Number=0; k < sText.length; k++)
			{
				var tmp:EnglishCharClip=new EnglishCharClip();
				tmp.name="char_clip" + k;
				tmp.index=k;
				tmp.setFontSize(fontSize);
				tmp.breakCount=0;
				tmp.setCorrectChar(sText.charAt(k));
				tmp.setNormalColor();
				charClips.push(tmp);
			}
			this.handleTags(sText);
		}

		public function handleTags(sText:String):void
		{
			if (sText.indexOf("<b>") > -1)
			{
				this.processTags("b", "isKeyword");
			}
			if (sText.indexOf("<spell>") > -1)
			{
				this.processTags("spell", "isSpell");
			}
			else
			{
				charClips.setPropValues("isSpell", true);
				this.setTagValues(charClips, "isSpell", true);
			}
			for (var k:Number=0; k < charClips.length; k++)
			{
				if (charClips[k].getCorrectChar() == "|")
				{
					charClips[k - 1].setBreakCount(charClips[k - 1].breakCount + 1);
					charClips[k].remove();
					charClips.splice(k, 1);
					--k;
				}
			}
			this.filterUnnecessarySpelling();
			this.layOutClips();
		}


		public function filterUnnecessarySpelling():void
		{
			var i:Number=0;
			var findFirstSpell:Boolean=false;
			for (var k:Number=0; k < charClips.length; k++)
			{
				var charClip:CharClip=this.charClips[k];
				if (this._sGoodChars.indexOf(charClip.correctChar) == -1)
				{
					charClip.isSpell=false;
				}
				if (charClip.isSpell)
				{
					charClip.setChar(_charForWidth);
					if (charClip.correctChar != " ")
					{
						findFirstSpell=true;
					}
				}
				if (charClip.correctChar == " ")
				{
					charClip.hideLine();
				}
				if (charClip.isSpell && !findFirstSpell && charClip.correctChar == " ")
				{
					charClip.setIsSpell(false);
					findFirstSpell=true;
				}
				charClip.setSize(charClip.getCharWidth() + 4, charClip.getCharHeight() + 2);
				charClip.index=i;
				i++;
			}
		}


		/**
		 * layout clips at multilines;
		 *
		 */
		public function layOutClips():void
		{
			var lastSpaceCharIndex:Number=-1;
			var nX:Number=0;
			var nY:Number=0;
			var nCharHt:Number=this.validate(charClips[0].getCharHeight(), 24);
			var i:Number=0;

			function wordWrap():void
			{
				nX=0;
				lastSpaceCharIndex=-1;
				nY=nY + (nCharHt + 6);
			}
			for (var k:Number=0; k < charClips.length; k++)
			{
				charClips[k].setPos(nX, nY);
				if (charClips[k].correctChar == " ")
				{
					lastSpaceCharIndex=k;
				}
				nX=nX + (charClips[k].width + CHAR_XGAP);
				if (charClips[k].breakCount > 0)
				{
					for (var j:Number=0; j < charClips[k].breakCount; j++)
					{
						wordWrap();
					}
				}
				if (nX <= _nWd)
				{
					continue;
				}
				if (lastSpaceCharIndex > -1)
				{
					k=lastSpaceCharIndex;
				}
				wordWrap();
				if (i++ > 60)
				{
					break;
				}
			}
			for (var m:Number=0; m < charClips.length; m++)
			{
				var clip:CharClip=charClips[m];
				addChildAt(clip, m);
				clip.initMcLine(clip.width, 0x000000);
				if (clip.isSpell)
				{
					clip.setChar(" ");
					if (!clip.isSpace())
					{
						_spellTaggedCharLength++;
					}
					continue;
				}
				clip.setChar(charClips[m].correctChar);
			}
			_nHt=nY + nCharHt + 6;
		}

		public function fillMissingSpaces(nCurrentIdx:Number):Number
		{
			var correctChar:String=this.getClip(nCurrentIdx).correctChar;
			var inputChar:String=this.getClip(nCurrentIdx).char;
			if (nCurrentIdx < 0)
			{
				this.select(0);
			}
			if (!this.getClip(nCurrentIdx).isWrongAnswer)
			{
				lastCorrect=nCurrentIdx;
				return (nCurrentIdx);
			}
			if (this.getClip(nCurrentIdx).isSpace())
			{
				this.getNextClip().setChar(inputChar);
				this.getClip(nCurrentIdx).setChar(" ");
				++nCurrentIdx;
				this.select(nCurrentIdx);
			}
			return this.currentIndex;
		}

		public function processTags(sTag:String, sPropName:String):void
		{
			var beginTag:String="<" + sTag + ">";
			var endTag:String="</" + sTag + ">";
			var tmp:Array;
			var beginIndex:Number=this.allCorrectText.indexOf(beginTag, 0);
			var k:Number;
			var charClip:CharClip;
			var correctText:String

			if (beginIndex == -1)
			{
				return;
			}
			while (beginIndex > -1)
			{
				correctText=this.correctText.substr(0, beginIndex) + this.correctText.substr(beginIndex + beginTag.length);
				tmp=charClips.splice(beginIndex, beginTag.length);
				for (k=0; k < tmp.length; k++)
				{
					charClip=tmp[k];
					removeChild(charClip);
				}
				var endIndex:Number=correctText.indexOf(endTag, beginIndex);
				if (endIndex > -1)
				{
					if (endIndex == 0)
					{
						correctText=correctText.substr(endTag.length);
					}
					else
					{
						correctText=correctText.substr(0, endIndex) + correctText.substr(endIndex + endTag.length);
					}
					tmp=charClips.splice(endIndex, endTag.length);
					for (k=0; k < tmp.length; k++)
					{
						charClip=tmp[k];
						removeChild(charClip);
					}
				}
				var wrappedData:Array=charClips.slice(beginIndex, endIndex);
				wrappedData.setPropValues(sPropName, true);
				this.setTagValues(wrappedData, sPropName, true);
				beginIndex=correctText.indexOf(beginTag, beginIndex);
			}
		}

		/**
		 *
		 * @param index
		 * @return
		 * Select clip by index
		 *
		 */
		public function select(index:Number):CharClip
		{
			_cursor_index=index;
			if (currentClip != null)
			{
				currentClip.highlight(false);
			}
			if (charClips[index] != null)
			{
				this.currentClip=charClips[index];
			}
			if (!currentClip.isSpell)
			{
				this.currentClip.setChar(currentClip.correctChar);
				this.currentClip=this.getNextClip();
			}
			this.currentClip.highlight(true);
			return _current_clip;
		}

		public function checkSpace():Boolean
		{
			if (currentClip.isSpace())
			{
				lastSpace=currentClip.index;
				return (true);
			}
			return (false);
		}


		/**
		 * Move the cursor backward
		 *
		 */
		public function moveBackward():void
		{
			this.getPreviousClip();
			lastTypedClip=null;
		}

		/**
		 *  Forward the cursor
		 *
		 */
		public function moveForward():void
		{
			getNextClip();
			lastTypedClip=null;
		}

		/**
		 *
		 * @param keyCode
		 * @return
		 * Directly called by key event handler
		 *
		 */
		public function processKeyCode(keyCode:Number):Boolean
		{
			return false;
		}


		public function setTagValues(ary:Array, tagName:String, value:Object):Array
		{
			var setMethod:String="set" + tagName.charAt(0).toUpperCase() + tagName.substr(1, tagName.length);
			for (var k:Number=0; k < ary.length; k++)
			{
				ary[k][setMethod](value);
			}
			return (ary);
		}


		public function markup(doShow:Boolean):void
		{
			markedUp=doShow;
			this.fillMissingSpaces(this.currentIndex);
			var k:Number;
			k=lastCheckedSpace == 0 ? (0) : (lastCheckedSpace + 1);
			if (lastSpace > 0 && this.currentIndex >= lastSpace)
			{
				k=lastSpace + 1;
			}
			var n:Number=this.getNextSpace(k);
			var m:Number;
			if (this.correctText.indexOf(" ") > 0)
			{
				m=n;
			}
			else
			{
				m=currentIndex;
			}
			this.showMarkup(k, m, doShow);
		}


		public function showMarkup(start:Number, end:Number, doShow:Boolean):void
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
						continue;
					}
					if (charClip.isSpell)
					{
						charClip.showChar();
					}
					if (k != this.currentIndex)
					{
						charClip.setNormalColor();
					}
				}
			}
		}


		public function getPrvSpace(last:Number):Number
		{
			if (last < 0)
			{
				return (0);
			}
			var k:Number;
			for (var m:Number=last - 1; m > -1; m--)
			{
				k=m;
				if (this.getClip(m).isSpace())
				{
					break;
				}
			}
			return k;
		}

		public function getNextSpace(last:Number):Number
		{
			var k:Number;
			for (var m:Number=last; m < this.length; m++)
			{
				k=m;
				if (this.getClip(m).isSpace())
				{
					break;
				}
			}
			return k;
		}


		/**
		 *
		 * @param sChar
		 * @return
		 * This is the last index step for set char onto screen;
		 */
		public function process(sChar:String):Boolean
		{
			sChar=sChar.toLowerCase();
			if (!this.checkGoodChar(sChar))
			{
				return (false);
			}
			this.typeLetter(sChar);
			if (!isEnd)
			{
				getNextClip();
			}
			return (true);
		}

		/**
		 *
		 * @param sChar
		 *
		 */
		public function typeLetter(sChar:String):void
		{
			this.currentClip.setChar(sChar);
			lastTypedClip=this.currentClip;
			if (!this.isEnd)
			{
				this.currentClip.setNormalColor();
			}
			this.clearFrom(this.currentIndex + 1);
			if (this.currentClip.isSpace())
			{
				lastSpace=currentIndex;
			}
			this.fillMissingSpaces(this.currentIndex);
		}

		/**
		 *
		 * @param value
		 * @param defaultValue
		 * @return
		 *
		 */
		public function validate(value:*, defaultValue:*):*
		{
			return (value == null ? (defaultValue) : (value));
		}


		/**
		 * check the strick mode if;
		 *
		 */
		public function forceCheck():Boolean
		{
			return (this.checkSpelling(this.currentIndex, true, true));
		}


		/**
		 * Back space event handler
		 *
		 */
		public function backspace(count:Number):void
		{
			var count:Number=this.validate(count, 1);
			for (var k:Number=0; k < count; k++)
			{
				this.backSpaceOnce();
			}
			for (k=this.currentIndex; k >= 0; k--)
			{
				if (this.getClip(k).isSpace())
				{
					break;
				}
			}
			lastSpace=k < 0 ? 0 : k;
			lastCheckedSpace=lastSpace;
			lastTypedClip=null;
		}

		public function backSpaceOnce():void
		{
			this.currentClip.setChar(" ");
			this.currentClip.animateBackspace();
			this.clearFrom(this.currentIndex + 1);
			if (this.getClip(this.cursorIndex).isBlank())
			{
				this.getPreviousClip().setChar(" ");
			}
			lastCorrect=currentIndex;
			this.select(this.currentIndex);
		}


		/**
		 *
		 * @return
		 * Tools function / called by externel interface / maybe
		 *
		 */
		public function findNextEditableClip():CharClip
		{
			var index:Number;
			for (var k:Number=currentIndex; k < this.length; k++)
			{
				if (charClips[k].isSpell)
				{
					index=k;
					break;
				}
			}
			return charClips[index];
		}

		/**
		 *
		 * @param char
		 * @return
		 * determined  by language code
		 *
		 */
		public function checkGoodChar(char:String):Boolean
		{
			return this._sGoodChars.indexOf(char) > -1;
		}

		/**
		 * Finish event dispatch when all is inputed and correct;
		 *
		 */
		public function finishQuiz():void
		{
			for (var k:Number=0; k < charClips.length; k++)
			{
				charClips[k].hightLight(false);
			}
		}

		/**
		 * Enter key event handler
		 *
		 */
		public function onPressEnter():void
		{
			return;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function highlightWrongClips():void
		{
			var result:Boolean=false;
			for each (var clip:CharClip in charClips)
			{
				result=clip.getChar().toLowerCase() != clip.correctChar;
				if (clip.isSpell && result)
				{
					clip.setWrongColor();
				}
			}
		}

		public function checkSpelling(index:Number, doOnDone:Boolean, forceCheck:Boolean):Boolean
		{
			return (false);
		}

		public function allCorrect(index:Number, doOnDone:Boolean):void
		{

		}

		public function get allEnteredText():String
		{
			_all_entered_text="";
			for each (var clip:CharClip in charClips)
			{
				if (!clip.isBlank() && clip.isSpell)
				{
					_all_entered_text+=clip.text;
				}

			}
			return this._all_entered_text;
		}


		public function get allCorrectText():String
		{
			_all_correct_text="";
			for each (var clip:CharClip in charClips)
			{
				if (clip.isSpell)
				{
					_all_correct_text+=clip.correctChar;
				}
			}
			return this._all_correct_text;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get currentIndex():Number
		{
			return (this.currentClip.index);
		}

		public function set currentIndex(value:Number):void
		{
			this._current_index=value;
		}

		/**
		 *
		 * @return current cursor index
		 *
		 */
		public function get cursorIndex():Number
		{
			return _cursor_index;
		}

		public function set cursorIndex(value:Number):void
		{
			_cursor_index=value;
		}

		/**
		*
		* @return current cursor index
		*
		*/
		public function get lastCorrect():Number
		{
			return _last_correct;
		}

		public function set lastCorrect(value:Number):void
		{
			_last_correct=value;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get lastSpace():Number
		{
			return _last_space;
		}

		public function set lastSpace(value:Number):void
		{
			_last_space=value;
		}


		public function checkBuffer():Boolean
		{
			return false;
		}

		public function gotoNextInputBlock():void
		{
		}

		/**
		 * all related getter / setters
		 *
		 *
		 * **/
		public function get correctText():String
		{
			return (charClips.selectByPropValue("isSpell", true).collectProp("correctChar").join(""));
		}

		public function set correctText(value:String):void
		{
			this._correct_text=value;
		}


		public function get currentClip():CharClip
		{
			return _current_clip;
		}

		public function set currentClip(value:CharClip):void
		{
			this._current_clip=value;
		}

		public function get lastTypedClip():CharClip
		{
			return _last_typed_clip;
		}

		public function set lastTypedClip(value:CharClip):void
		{
			this._last_typed_clip=value;
		}

		public function get answerLength():Number
		{
			return (_answer_length > 0 ? (_answer_length) : (_spellTaggedCharLength));
		}

		public function set answerLength(value:Number):void
		{
			_answer_length=value;
		}

		public function get enteredText():String
		{
			return this._entered_text;
		}

		public function set enteredText(value:String):void
		{
			this._entered_text=value;
		}

		public function get isAllCorrect():Boolean
		{
			return false;
		}


		public function set isEnd(value:Boolean):void
		{
			_is_end=value;
		}

		public function get length():Number
		{
			return _length;
		}

		public function set length(value:Number):void
		{
			this._length=value;
		}

		public function get spellLength():Number
		{
			return this.correctText.split(" ").join("").length;
		}

		public function set spellLength(value:Number):void
		{
			this._spell_length=value;
		}

		public function get wrongSpellCount():Number
		{
			return _wrong_spell_count;
		}

		public function set wrongSpellCount(value:Number):void
		{
			this._wrong_spell_count=value;
		}

		protected function resetMaxTryTime():void
		{
			this._max_try_time=MAX_TRY_TIME;
		}
	}
}
