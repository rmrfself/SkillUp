package org.enjoytalk.view.components.custom
{
	import flash.utils.Dictionary;

	import mx.utils.StringUtil;

	public class PinyinCharClipManager extends EnglishCharClipManager
	{
		public static var TYPEABLE_CHARS:Array=["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "a", "ā", "á", "ǎ", "à", "i", "ī", "í", "ǐ", "ì", "u", "ū", "ú", "ǔ", "ù", "e", "ē", "é", "ě", "è", "o", "ō", "ó", "ǒ", "ò", "ü", "ǖ", "ǘ", "ǚ", "ǜ", " "];
		public static var TYPEABLE_SYMBOLS:String="";
		public static var FINAL_TABLE:Array=["ueng", "uen", "iou", "uei", "üe", "ün", "üan", "ue", "uang", "un", "uan", "ui", "uai", "uo", "ua", "ong", "ou", "iong", "ing", "iang", "in", "ian", "iu", "iao", "ie", "io", "ia", "eng", "en", "ei", "ang", "an", "ao", "ai", "ü", "u", "ê", "e", "o", "a", "i"];
		public static var R_STRING:String="r";
		public static var SPACE:String=" ";
		public static var TONE_HASH:Object={a: "āáǎàa", i: "īíǐìi", u: "ūúǔùu", e: "ēéěèe", o: "ōóǒòo", ü: "ǖǘǚǜü"};
		public static var PRE_REPLACE_HASH:Object={ă: "ǎ", ĭ: "ǐ", ŭ: "ǔ", ĕ: "ě", ŏ: "ǒ"};
		public static var TONE_CONVERSION_KEYS:Array=["1", "2", "3", "4", "5"];
		public static var TONE_ORDER:String="aoeiuü";
		public static var TONE_ORDER_EXCEPTION_HASH:Object={iu: 1};
		public static var ALTERNATIVE_INPUT_HASH:Object={v: "ü"};
		public static var IGNORED_CODE_ARRAY:Array=[116, 123, 8, 39, 37, 38, 40];

		protected var _finals:Array=[];

		public function PinyinCharClipManager()
		{
			super();
			createFinalTable();
		}

		public function createFinalTable():void
		{
			var finalData:Array=[];
			var tableLength:Number=FINAL_TABLE.length;
			for (var k:Number=0; k < tableLength; k++)
			{
				finalData.push(FINAL_TABLE[k] + R_STRING);
			}
			_finals=FINAL_TABLE.concat(finalData);
		}

		override public function createCharClips(sText:String, sGoodChars:String, fontSize:Number):void
		{
			sText=this.normalizeText(sText);
			super.createCharClips(sText, sGoodChars, fontSize);
		}


		override public function finishQuiz():void
		{
			this.currentClip.highlight(false);
		}

		public function getIsWaitingForConversion(index:Number):Boolean
		{
			return (Boolean(this.getPlainText(this.getClip(index).correctChar) == this.getClip(index).getChar()));
		}

		override public function process(sChar:String):Boolean
		{
			if (this.isIgnoredKeyCode(sChar.toLowerCase().charCodeAt(1)))
			{
				return (false);
			}
			sChar=this.verifySpace(sChar);
			if (TONE_CONVERSION_KEYS.hasValue(sChar) > -1)
			{
				return (this.convertChar(Number(sChar)));
			}
			if (!this.checkGoodChar(sChar))
			{
				return (false);
			}
			sChar=this.replaceChara(sChar);
			return (super.process(sChar));
		}

		public function normalizeText(text:String):String
		{
			for (var obj:String in PRE_REPLACE_HASH)
			{
				text=text.replace(obj, PRE_REPLACE_HASH[obj]);
			}
			return text;
		}

		public function replaceChara(letter:String):String
		{
			return (this.validate(ALTERNATIVE_INPUT_HASH[letter], letter));
		}

		public function convertChar(tone:Number):Boolean
		{
			var finalStr:String=this.checkFinal();
			if (finalStr)
			{
				var beginDiacritics:String=finalStr.substr(this.findDiacriticsPosition(finalStr), 1);
				var diacritics:String=finalStr.replace(beginDiacritics, this.getDiacritics(beginDiacritics, tone));
				var lastChar:String=this.replaceLastChar(this.getCurrentEditableText(), finalStr, diacritics);
				this.setEnteredText(lastChar);
				return true;
			}
			return false;
		}

		public function findDiacriticsPosition(vowel:String):Number
		{
			var toneOrder:Number=TONE_ORDER_EXCEPTION_HASH[vowel];
			if (!isNaN(toneOrder))
			{
				return toneOrder;
			}
			var toneOrderLength:Number=TONE_ORDER.length;
			var position:Number;
			for (var k:Number=0; k < toneOrderLength; k++)
			{
				position=vowel.indexOf(TONE_ORDER.charAt(k));
				if (position > -1)
				{
					break;
				}
			}
			return (this.validate(position, -1));
		}

		public function getDiacritics(vowel:String, tone:Number):String
		{
			return (this.validate(TONE_HASH[vowel.toLowerCase()].charAt(tone - 1), vowel));
		}

		public function replaceLastChar(text:String, pattern:String, replace:String):String
		{
			var textIndex:Number=this.getPlainText(text).lastIndexOf(pattern);
			var textLength:Number=textIndex + pattern.length;
			var resplacedStr:String=text.substr(0, textIndex) + replace + text.substr(textIndex, text.length);
			return resplacedStr;
		}

		public function setEnteredText(text:String):void
		{
			var textLength:Number=text.length;
			for (var k:Number=0; k < textLength; k++)
			{
				this.getClip(k).setChar(text.charAt(k));
			}
		}

		public function getCurrentEditableText():String
		{
			return (this.allEnteredText.substring(0, this.findLastEditableIndex() + 1));
		}

		public function getPlainText(text:String):String
		{
			var plainText:String=text;
			for (var tone:String in TONE_HASH)
			{
				var toneLength:Number=TONE_HASH[tone].length;
				for (var k:Number=0; k < toneLength; k++)
				{
					plainText=plainText.replace(TONE_HASH[tone].charAt(k), tone);
				}
			}
			return plainText;
		}

		public function verifySpace(sChar:String):String
		{
			if (sChar == SPACE)
			{
				if (!this.currentClip.isSpace())
				{
					this.select(this.currentIndex);
				}
				return SPACE;
			}
			return (StringUtil.trim(sChar).toLowerCase());
		}

		public function findLastEditableIndex():Number
		{
			var curIndex:Number=-1;
			for (var k:Number=this.currentIndex; k >= 0; k--)
			{
				var clip:CharClip=this.getClip(k);
				if (clip.isSpell && !clip.isSpace() && !clip.isBlank())
				{
					curIndex=k;
					break;
				}
			}
			return (curIndex);
		}

		public function checkFinal():String
		{
			var finalStr:String;
			var plainText:String=this.getPlainText(this.getCurrentEditableText());
			var plainTextLength:Number=StringUtil.trim(plainText).length;
			for (var k:Number=0; k < _finals.length; k++)
			{
				var lastIndex:Number=plainText.lastIndexOf(_finals[k]);
				var finalStrLength:Number=_finals[k].length;
				if (lastIndex > -1 && lastIndex >= plainTextLength - 1 - finalStrLength)
				{
					finalStr=_finals[k];
					if (lastIndex == plainTextLength - finalStrLength)
					{
						break;
					}
				}
			}
			return finalStr;
		}

		public function isTypeableKey(nKeyCode:Number):Boolean
		{
			return (!this.isIgnoredKeyCode(nKeyCode) && (this.isTypeableChar(nKeyCode) || this.isTypeableSymbol(nKeyCode)));
		}

		public function isTypeableSymbol(asciiCode:Number):Boolean
		{
			return TYPEABLE_SYMBOLS.indexOf(String.fromCharCode(asciiCode)) > -1;
		}

		public function isTypeableChar(nKeyCode:Number):Boolean
		{
			var char:String=String.fromCharCode(nKeyCode).toLowerCase();
			return TYPEABLE_CHARS.hasValue(char) != null;
		}

		public function isIgnoredKeyCode(nKeyCode:Number):Boolean
		{
			return IGNORED_CODE_ARRAY.hasValue(nKeyCode) != null;
		}

	}
}
