/**
*  Japanese hiragana spell handler class
*  Code by huangtuya@gmail.com
 *
*/
package org.enjoytalk.view.components.custom
{
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	public class HiraganaCharClipManager extends EnglishCharClipManager
	{

		public static var TYPEABLE_CHARS:Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " ", "-"];

		public static var HIRAGANA_HASH:Object = {A: "あ", BA: "ば", BE: "べ", BI: "び", BO: "ぼ", BU: "ぶ", BYA: "びゃ", BYE: "びぇ", BYI: "びぃ", BYO: "びょ", BYU: "びゅ", CHA: "ちゃ", CHE: "ちぇ", CHI: "ち", CHO: "ちょ", CHU: "ちゅ", CYA: "ちゃ", CYE: "ちぇ", CYI: "ちぃ", CYO: "ちょ", CYU: "ちゅ", DA: "だ", DE: "で", DHA: "でゃ", DHE: "でぇ", DHI: "でぃ", DHO: "でょ", DHU: "でゅ", DI: "ぢ", DO: "ど", DU: "づ", DWA: "どぁ", DWE: "どぇ", DWI: "どぃ", DWO: "どぉ", DWU: "どぅ", DYA: "ぢゃ", DYE: "ぢぇ", DYI: "ぢぃ", DYO: "ぢょ", DYU: "ぢゅ", DZU: "づ", E: "え", FA: "ふぁ", FE: "ふぇ", FI: "ふぃ", FO: "ふぉ", FU: "ふ", FYA: "ふゃ", FYE: "ふぇ", FYI: "ふぃ", FYO: "ふょ", FYU: "ふゅ", GA: "が", GE: "げ", GI: "ぎ", GO: "ご", GU: "ぐ", GWA: "ぐぁ", GWE: "ぐぇ", GWI: "ぐぃ", GWO: "ぐぉ", GWU: "ぐぅ", GYA: "ぎゃ", GYE: "ぎぇ", GYI: "ぎぃ", GYO: "ぎょ", GYU: "ぎゅ", HA: "は", HE: "へ", HI: "ひ", HO: "ほ", HU: "ふ", HYA: "ひゃ", HYE: "ひぇ", HYI: "ひぃ", HYO: "ひょ", HYU: "ひゅ", I: "い", JA: "じゃ", JE: "じぇ", JI: "じ", JO: "じょ", JU: "じゅ", JYA: "じゃ", JYE: "じぇ", JYI: "じぃ", JYO: "じょ", JYU: "じゅ", KA: "か", KE: "け", KI: "き", KO: "こ", KU: "く", KWA: "くぁ", KWE: "くぇ", KWI: "くぃ", KWO: "くぉ", KWU: "くぅ", KYA: "きゃ", KYE: "きぇ", KYI: "きぃ", KYO: "きょ", KYU: "きゅ", LA: "ら", LE: "れ", LI: "り", LO: "ろ", LU: "る", LYA: "りゃ", LYE: "りぇ", LYI: "りぃ", LYO: "りょ", LYU: "りゅ", MA: "ま", ME: "め", MI: "み", MO: "も", MU: "む", MYA: "みゃ", MYE: "みぇ", MYI: "みぃ", MYO: "みょ", MYU: "みゅ", NA: "な", NE: "ね", NI: "に", NN: "ん", NO: "の", NU: "ぬ", NYA: "にゃ", NYE: "にぇ", NYI: "にぃ", NYO: "にょ", NYU: "にゅ", O: "お", PA: "ぱ", PE: "ぺ", PI: "ぴ", PO: "ぽ", PU: "ぷ", PYA: "ぴゃ", PYE: "ぴぇ", PYI: "ぴぃ", PYO: "ぴょ", PYU: "ぴゅ", QWA: "ぐぁ", RA: "ら", RE: "れ", RI: "り", RO: "ろ", RU: "る", RYA: "りゃ", RYE: "りぇ", RYI: "りぃ", RYO: "りょ", RYU: "りゅ", SA: "さ", SE: "せ", SHA: "しゃ", SHE: "しぇ", SHI: "し", SHO: "しょ", SHU: "しゅ", SI: "し", SO: "そ", SU: "す", SWA: "すぁ", SWE: "すぇ", SWI: "すぃ", SWO: "すぉ", SWU: "すぅ", SYA: "しゃ", SYE: "しぇ", SYI: "しぃ", SYO: "しょ", SYU: "しゅ", TA: "た", TE: "て", THA: "てゃ", THE: "てぇ", THI: "てぃ", THO: "てょ", THU: "てゅ", TI: "ち", TO: "と", TSA: "つぁ", TSE: "つぇ", TSI: "つぃ", TSO: "つぉ", TSU: "つ", TU: "つ", TWA: "とぁ", TWE: "とぇ", TWI: "とぃ", TWO: "とぉ", TWU: "とぅ", TYA: "ちゃ", TYE: "ちぇ", TYI: "ちぃ", TYO: "ちょ", TYU: "ちゅ", U: "う", VA: "ゔぁ", VE: "ゔぇ", VI: "ゔぃ", VO: "ゔぉ", VU: "ゔ", VYA: "ゔゃ", VYE: "ゔぇ", VYI: "ゔぃ", VYO: "ゔょ", VYU: "ゔゅ", WA: "わ", WE: "うぇ", WHA: "うぁ", WHE: "うぇ", WHI: "うぃ", WHO: "うぉ", WI: "うぃ", WO: "を", WYE: "ゑ", WYI: "ゐ", XA: "ぁ", XE: "ぇ", XI: "ぃ", XO: "ぉ", XTU: "っ", XU: "ぅ", XWA: "ゎ", XYA: "ゃ", XYO: "ょ", XYU: "ゅ", YA: "や", YE: "いぇ", YO: "よ", YU: "ゆ", ZA: "ざ", ZE: "ぜ", ZI: "じ", ZO: "ぞ", ZU: "ず", ZYA: "じゃ", ZYE: "じぇ", ZYI: "じぃ", ZYO: "じょ", ZYU: "じゅ"};

		public static var GOOD_LEN1:Object = {A: 1, B: 1, C: 1, D: 1, E: 1, F: 1, G: 1, H: 1, I: 1, J: 1, K: 1, L: 1, M: 1, N: 1, O: 1, P: 1, Q: 1, R: 1, S: 1, T: 1, U: 1, V: 1, W: 1, X: 1, Y: 1, Z: 1};

		public static var GOOD_LEN2:Object = {A: 2, BA: 2, BE: 2, BI: 2, BO: 2, BU: 2, BY: 2, CH: 2, CY: 2, DA: 2, DE: 2, DH: 2, DI: 2, DO: 2, DU: 2, DW: 2, DY: 2, DZ: 2, E: 2, FA: 2, FE: 2, FI: 2, FO: 2, FU: 2, FY: 2, GA: 2, GE: 2, GI: 2, GO: 2, GU: 2, GW: 2, GY: 2, HA: 2, HE: 2, HI: 2, HO: 2, HU: 2, HY: 2, I: 2, JA: 2, JE: 2, JI: 2, JO: 2, JU: 2, JY: 2, KA: 2, KE: 2, KI: 2, KO: 2, KU: 2, KW: 2, KY: 2, LA: 2, LE: 2, LI: 2, LO: 2, LU: 2, LY: 2, MA: 2, ME: 2, MI: 2, MO: 2, MU: 2, MY: 2, NA: 2, NE: 2, NI: 2, NN: 2, NO: 2, NU: 2, NY: 2, O: 2, PA: 2, PE: 2, PI: 2, PO: 2, PU: 2, PY: 2, QW: 2, RA: 2, RE: 2, RI: 2, RO: 2, RU: 2, RY: 2, SA: 2, SE: 2, SH: 2, SI: 2, SO: 2, SU: 2, SW: 2, SY: 2, TA: 2, TE: 2, TH: 2, TI: 2, TO: 2, TS: 2, TU: 2, TW: 2, TY: 2, U: 2, VA: 2, VE: 2, VI: 2, VO: 2, VU: 2, VY: 2, WA: 2, WE: 2, WH: 2, WI: 2, WO: 2, WY: 2, XA: 2, XE: 2, XI: 2, XO: 2, XT: 2, XU: 2, XW: 2, XY: 2, YA: 2, YE: 2, YO: 2, YU: 2, ZA: 2, ZE: 2, ZI: 2, ZO: 2, ZU: 2, ZY: 2};

		public static var GOOD_LEN3:Object = {A: 3, BA: 3, BE: 3, BI: 3, BO: 3, BU: 3, BYA: 3, BYE: 3, BYI: 3, BYO: 3, BYU: 3, CHA: 3, CHE: 3, CHI: 3, CHO: 3, CHU: 3, CYA: 3, CYE: 3, CYI: 3, CYO: 3, CYU: 3, DA: 3, DE: 3, DHA: 3, DHE: 3, DHI: 3, DHO: 3, DHU: 3, DI: 3, DO: 3, DU: 3, DWA: 3, DWE: 3, DWI: 3, DWO: 3, DWU: 3, DYA: 3, DYE: 3, DYI: 3, DYO: 3, DYU: 3, DZU: 3, E: 3, FA: 3, FE: 3, FI: 3, FO: 3, FU: 3, FYA: 3, FYE: 3, FYI: 3, FYO: 3, FYU: 3, GA: 3, GE: 3, GI: 3, GO: 3, GU: 3, GWA: 3, GWE: 3, GWI: 3, GWO: 3, GWU: 3, GYA: 3, GYE: 3, GYI: 3, GYO: 3, GYU: 3, HA: 3, HE: 3, HI: 3, HO: 3, HU: 3, HYA: 3, HYE: 3, HYI: 3, HYO: 3, HYU: 3, I: 3, JA: 3, JE: 3, JI: 3, JO: 3, JU: 3, JYA: 3, JYE: 3, JYI: 3, JYO: 3, JYU: 3, KA: 3, KE: 3, KI: 3, KO: 3, KU: 3, KWA: 3, KWE: 3, KWI: 3, KWO: 3, KWU: 3, KYA: 3, KYE: 3, KYI: 3, KYO: 3, KYU: 3, LA: 3, LE: 3, LI: 3, LO: 3, LU: 3, LYA: 3, LYE: 3, LYI: 3, LYO: 3, LYU: 3, MA: 3, ME: 3, MI: 3, MO: 3, MU: 3, MYA: 3, MYE: 3, MYI: 3, MYO: 3, MYU: 3, NA: 3, NE: 3, NI: 3, NN: 3, NO: 3, NU: 3, NYA: 3, NYE: 3, NYI: 3, NYO: 3, NYU: 3, O: 3, PA: 3, PE: 3, PI: 3, PO: 3, PU: 3, PYA: 3, PYE: 3, PYI: 3, PYO: 3, PYU: 3, QWA: 3, RA: 3, RE: 3, RI: 3, RO: 3, RU: 3, RYA: 3, RYE: 3, RYI: 3, RYO: 3, RYU: 3, SA: 3, SE: 3, SHA: 3, SHE: 3, SHI: 3, SHO: 3, SHU: 3, SI: 3, SO: 3, SU: 3, SWA: 3, SWE: 3, SWI: 3, SWO: 3, SWU: 3, SYA: 3, SYE: 3, SYI: 3, SYO: 3, SYU: 3, TA: 3, TE: 3, THA: 3, THE: 3, THI: 3, THO: 3, THU: 3, TI: 3, TO: 3, TSA: 3, TSE: 3, TSI: 3, TSO: 3, TSU: 3, TU: 3, TWA: 3, TWE: 3, TWI: 3, TWO: 3, TWU: 3, TYA: 3, TYE: 3, TYI: 3, TYO: 3, TYU: 3, U: 3, VA: 3, VE: 3, VI: 3, VO: 3, VU: 3, VYA: 3, VYE: 3, VYI: 3, VYO: 3, VYU: 3, WA: 3, WE: 3, WHA: 3, WHE: 3, WHI: 3, WHO: 3, WI: 3, WO: 3, WYE: 3, WYI: 3, XA: 3, XE: 3, XI: 3, XO: 3, XTU: 3, XU: 3, XWA: 3, XYA: 3, XYO: 3, XYU: 3, YA: 3, YE: 3, YO: 3, YU: 3, ZA: 3, ZE: 3, ZI: 3, ZO: 3, ZU: 3, ZYA: 3, ZYE: 3, ZYI: 3, ZYO: 3, ZYU: 3};

		public static var IGNORED_CODE_ARRAY:Array = [116, 123, 8, 39, 37, 38, 40];

		public static var BUFFER_HASH:Object = {length1: GOOD_LEN1, length2: GOOD_LEN2, length3: GOOD_LEN3};

		public static var SMALL_TSU_PAIRS:Object = {kk: 1, ss: 1, tt: 1, pp: 1, yy: 1, ww: 1, dd: 1, bb: 1, cc: 1, ff: 1, jj: 1, mm: 1, qq: 1, rr: 1, vv: 1, zz: 1, gg: 1, hh: 1};

		public static var SMALL_TSU:String = "っ";

		public static var KATAKANA_DASH:String = "ー";

		public var _buffer:String = "";


		public function HiraganaCharClipManager()
		{
			super();
			_charForWidth = "び";
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get buffer():String
		{
			return this._buffer;
		}

		/**
		 *
		 * @param sText
		 * @param sGoodChars
		 * @param fontSize
		 *
		 */
		override public function createCharClips(sText:String, sGoodChars:String, fontSize:Number):void
		{
			_sGoodChars = this.validate(sGoodChars, StringTools.HIRAGANA + StringTools.KATAGANA);
			fontSize = this.validate(fontSize, 22);
			charClips = [];
			correctText = sText;
			charClips = [];
			for (var k:Number = 0; k < sText.length; k++)
			{
				var tmp:HiraganaCharClip = new HiraganaCharClip();
				tmp.name = "char_clip" + k;
				tmp.setFontSize(fontSize);
				tmp.breakCount = 0;
				tmp.setCorrectChar(sText.charAt(k));
				tmp.setNormalColor();
				tmp.index = k;
				charClips.push(tmp);
			}
			this.handleTags(sText);
		}

		override public function highlightWrongClips():void
		{
			var charClip:CharClip;
			for (var k:Number = 0; k < charClips.length; k++)
			{
				charClip = charClips[k];
				if (charClip.isSpell && SpellCheckerJp.checkMatch(charClip.correctChar, charClip.getChar(), false) != 0)
				{
					charClip.setWrongColor();
				}
			}
		}

		override public function finishQuiz():void
		{
			this.currentClip.highlight(false);
			var charClip:HiraganaCharClip;
			for (var k:Number = 0; k < charClips.length; k++)
			{
				charClip = charClips[k];
				charClip.animateHideLine();
			}
		}

		/**
		 *
		 * @param nKeyCode
		 * @return
		 * This function is called by quiz class directly .
		 *
		 */
		override public function processKeyCode(nKeyCode:Number):Boolean
		{
			if ((this.isTypeableKey(nKeyCode) && this.isTypeableChar(nKeyCode)) || nKeyCode == 189)
			{
				return (this.processHirakanaKey(nKeyCode));
			}
			return false;
		}

		/**
		 *
		 * @param nKeyCode
		 * @return
		 * This function map the ascii code into hiragana code ,and return mapped one;
		 *
		 */
		public function processHirakanaKey(nKeyCode:Number):Boolean
		{
			/**
			* Return the '～' ;
			 *
			*/
			if (nKeyCode == 45 || nKeyCode == 189)
			{
				this.processKey(KATAKANA_DASH);
				_buffer = "";
				return (true);
			}
			var char:String = String.fromCharCode(nKeyCode).toUpperCase();
			_buffer = _buffer + char;
			/**
			*  If matched the single kana code ,return ;
			*/
			if (this.processMatchingKana())
			{
				return (true);
			}

			/**
			*  Try agin
			*/
			if (this.processRepeatKana())
			{
				return (true);
			}

			if (BUFFER_HASH["length" + _buffer.length][_buffer] == null)
			{
				_buffer = _buffer == " " ? ("") : (_buffer.slice(1));
			}
			currentClip.setChar(char.toLowerCase());
			return false;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function processMatchingKana():Boolean
		{
			var char:String = HIRAGANA_HASH[_buffer];
			if (char != null)
			{
				var chars:Array = char.split("");
				for (var k:Number = 0; k < chars.length; k++)
				{
					/**
					* This function present the matched code on the screen and get into next one ;
					*
					*/
					this.processKey(chars[k]);
				}
				_buffer = "";
				return (true);
			}
			if (this.isEnd)
			{
				this.currentClip.setChar("");
			}
			return false;
		}

		/**
		 *
		 * @return
		 * This function try to match the double index Kana.
		 *
		 */
		public function processRepeatKana():Boolean
		{
			var char:String = SMALL_TSU_PAIRS[_buffer.toLowerCase()];
			if (char != null)
			{
				this.processKey(SMALL_TSU);
				_buffer = _buffer.slice(1);
				return (true);
			}
			if (_buffer.length > 1 && _buffer.charAt(0) == "N" && _buffer != "NY")
			{
				this.processKey(HIRAGANA_HASH.NN);
				_buffer = _buffer.slice(1);
			}
			return (false);
		}


		/**
		 *
		 * @return
		 *
		 */
		override public function checkBuffer():Boolean
		{
			var result:Boolean = Boolean(_buffer == "N");
			if (result)
			{
				this.processKey(HIRAGANA_HASH.NN);
				_buffer = "";
			}
			return result;
		}

		/**
		 *
		 * @param char
		 * The core function to display code onto screen;
		 *
		 */
		public function processKey(char:String):void
		{
			var text:String = char;
			if (text != KATAKANA_DASH && StringTools.isZenkakuKatakana(currentClip.correctChar))
			{
				text = StringTools.changeZenkakuKatakanaFromHiragana(char);
			}
			super.process(text);
		}

		/**
		 *
		 * @param nKeyCode
		 * @return
		 *
		 */
		private function isTypeableKey(nKeyCode:Number):Boolean
		{
			return (!this.isIgnoredKeyCode(nKeyCode));
		}

		/**
		 *
		 * @param asciiCode
		 * @return
		 *
		 */
		private function isTypeableChar(asciiCode:Number):Boolean
		{
			var char_code:String = String.fromCharCode(asciiCode).toLowerCase();
			return (TYPEABLE_CHARS.indexOf(char_code) != -1);
		}

		/**
		 *
		 * @param nKeyCode
		 * @return
		 *
		 */
		private function isIgnoredKeyCode(nKeyCode:Number):Boolean
		{
			return (IGNORED_CODE_ARRAY.indexOf(nKeyCode) != -1);
		}

		/**
		 * Backspace event handler
		 *
		 *
		 */
		override public function backspace(count:Number):void
		{
			super.backspace(count);
			if (_buffer.length > 0)
			{
				_buffer = _buffer.slice(1);
			}
		}

	}
}
