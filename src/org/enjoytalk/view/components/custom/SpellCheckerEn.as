/**
* Spell checker for english
 *
 *
*/
package org.enjoytalk.view.components.custom
{

	public class SpellCheckerEn extends SpellChecker
	{
		public var KWORD_OPEN:String="<b>";

		public var KWORD_CLOSE:String="</b>";

		public var PUNCTS:Array=[".", ",", "!", "?", "(", ")", "&", "\'", ";", ":", "`"];

		public var PREPS:Array=[" of ", " fo ", "the ", "hte ", "teh ", " the ", " hte ", " teh ", " and ", " nad ", " adn "];

		public function SpellCheckerEn()
		{
			super();
		}

		/**
		 *
		 * @param sInput
		 * @param sCorrect
		 * @param aDistractors
		 * @param bStrictOn
		 * @return
		 *
		 */
		public function gradeSpelling(sInput:String, sCorrect:String, aDistractors:Array, bStrictOn:Boolean):Number
		{
			if (sInput == null)
			{
				throw "SpellCheckerEN.gradeSpelling: sInput is undefined!";
			}
			if (sCorrect == null)
			{
				throw "SpellCheckerEN.gradeSpelling: sCorrect is undefined!";
			}
			sCorrect=this.cleanText(sCorrect);
			sInput=this.cleanText(sInput);
			var LDValue:Number;
			if (bStrictOn)
			{
				LDValue=this.getWordLDValue(sInput, sCorrect);
			}
			else
			{
				LDValue=this.getFirstLettersMatch(sInput, sCorrect, aDistractors);
				if (LDValue > 1)
				{
					LDValue=this.getWordLDValue(sInput, sCorrect);
				}
			}
			return this.adjustLDForWordLength(sInput, sCorrect, LDValue, bStrictOn);
		}

		/**
		 *
		 * @param sInput
		 * @param sCorrect
		 * @param nLDVal
		 * @param strictMode
		 * @return
		 *
		 */
		public function adjustLDForWordLength(sInput:String, sCorrect:String, nLDVal:Number, strictMode:Boolean):Number
		{
			if (nLDVal > 1 && !strictMode)
			{
				nLDVal=nLDVal - this.getSwitchedAdjacentCount(sInput, sCorrect);
			}
			if (sCorrect.length >= 15 && (nLDVal == 3 || nLDVal == 2))
			{
				return 1;
			}
			if (sCorrect.length >= 10 && nLDVal == 2)
			{
				return 1;
			}
			return nLDVal;
		}

		/**
		 *
		 * @param sInput
		 * @param sCorrect
		 * @param aDistractors
		 * @return
		 *
		 */
		public function getFirstLettersMatch(sInput:String, sCorrect:String, aDistractors:Array):Number
		{
			if (sInput == sCorrect)
			{
				return 0;
			}
			var matchedStr:String="";
			for (var k:Number=3; k <= sInput.length; k++)
			{
				matchedStr=this.hasMatchedDistractorSubstring(sInput, sCorrect, aDistractors, k);
				if (matchedStr == "distractor_full_match")
				{
					return -1;
				}
				if (matchedStr == "no_match")
				{
					break;
				}
			}
			if (matchedStr == "distractor_partial_match")
			{
				return -2;
			}
			var a_correct:Array=sCorrect.split(" ");
			var a_input:Array=sInput.split(" ");
			sCorrect=this.concatWords(a_correct, k);
			sInput=this.concatWords(a_input, k);
			if (sCorrect == sInput)
			{
				return 1;
			}
			else
			{
				return 2;
			}
		}

		/**
		 *
		 * @param sInput
		 * @param sCorrect
		 * @param aDistractors
		 * @param nChars
		 * @return
		 *
		 */
		public function hasMatchedDistractorSubstring(sInput:String, sCorrect:String, aDistractors:Array, nChars:Number):String
		{
			if (aDistractors == null || aDistractors.length == 0)
			{
				return "no_match";
			}
			var a_input:Array=sInput.split(" ");
			var a_correct:Array=sCorrect.split(" ");
			for (var k:Number=0; k < aDistractors.length; k++)
			{
				var clean_text:String=this.cleanText(aDistractors[k]);
				var aCleanText:Array=clean_text.split(" ");
				if (sCorrect != clean_text)
				{
					if (this.arrayIsEqual(a_input, aCleanText))
					{
						return ("distractor_full_match");
					}
					if (a_correct.length == aCleanText.length)
					{
						var tmp:Boolean;
						for (var j:Number=0; j < a_correct.length; j++)
						{
							if (a_input[j].substr(0, nChars) == aCleanText[j].substr(0, nChars))
							{
								tmp=true;
								continue;
							}
							tmp=false;
						}
						if (tmp)
						{
							return ("distractor_partial_match");
						}
					}
				}
			}
			return "no_match";
		}

		/**
		 *
		 * @param a
		 * @param b
		 * @return
		 *
		 */
		public function arrayIsEqual(a:Array, b:Array):Boolean
		{
			if (a.length != b.length)
			{
				return false;
			}
			for (var k:Number=0; k < a.length; k)
			{
				if (a[k] != b[k])
				{
					return false;
				}
			}
			return (true);
		}

		/**
		 *
		 * @param sInput
		 * @param sCorrect
		 * @return
		 *
		 */
		public function getWordLDValue(sInput:String, sCorrect:String):Number
		{
			if (sInput.length == 0)
			{
				return sCorrect.length;
			}
			if (sCorrect.length == 0)
			{
				return sInput.length;
			}
			var s_input_len:Number=sInput.length;
			var s_correct_len:Number=sCorrect.length;
			var wValue:Array=new Array();

			/**
			* Check
			*/
			for (var k:Number=0; k <= s_input_len; k++)
			{
				wValue[k]=new Array();
				for (var j:Number=0; j <= s_correct_len; j++)
				{
					wValue[k].push(0);
				}
			}
			for (k=0; k <= s_input_len; k++)
			{
				wValue[k][0]=k;
			}
			for (k=0; k <= s_correct_len; k++)
			{
				wValue[0][k]=k;
			}
			for (k=1; k <= s_input_len; k++)
			{
				for (j=1; j <= s_correct_len; j++)
				{
					var char_ind:Number=sInput.charAt(k - 1).toLowerCase() == sCorrect.charAt(j - 1).toLowerCase() ? (0) : (1);
					wValue[k][j]=Math.min(Math.min(wValue[k - 1][j] + 1, wValue[k][j - 1] + 1), wValue[k - 1][j - 1] + char_ind);
				}
			}
			return (wValue[s_input_len][s_correct_len]);
		}

		/**
		 *
		 * @param sInput
		 * @param sCorrect
		 * @return
		 *
		 */
		public function getSwitchedAdjacentCount(sInput:String, sCorrect:String):Number
		{
			for (var k:Number=1; k < sInput.length; k++)
			{
				if (sInput.charAt(k) != sCorrect.charAt(k))
				{
					if (sInput.charAt(k + 1) == sCorrect.charAt(k) && sInput.charAt(k) == sCorrect.charAt(k + 1) && sCorrect.charAt(k) != sCorrect.charAt(k + 1))
					{
						return (1);
					}
				}
			}
			return (0);
		}

		/**
		 *
		 * @param aWords
		 * @param nChars
		 * @return
		 *
		 */
		public function concatWords(aWords:Array, nChars:Number):String
		{
			var str:String="";
			for (var k:Number=0; k < aWords.length; ++k)
			{
				str=str + aWords[k].substr(0, nChars);
			}
			return str;
		}

		/**
		 *
		 * @param sText
		 * @return
		 *
		 */
		public function removeSkippablePrepositions(sText:String):String
		{
			return (this.substringsToSpace(sText, PREPS));
		}

		/**
		 *
		 * @param sInput
		 * @return
		 *
		 */
		public function removeTags(sInput:String):String
		{
			return (sInput.split("<b>").join("").split("</b>").join(""));
		}

		/**
		 *
		 * @param sBaseString
		 * @param aFindStrings
		 * @return
		 *
		 */
		public function removeSubstrings(sBaseString:String, aFindStrings:String):String
		{
			for (var k:Number=0; k < aFindStrings.length; ++k)
			{
				sBaseString=sBaseString.split(aFindStrings[k]).join("");
			}
			return (sBaseString);
		}

		/**
		 *
		 * @param sBaseString
		 * @param aFindStrings
		 * @return
		 *
		 */
		public function substringsToSpace(sBaseString:String, aFindStrings:Array):String
		{
			for (var k:Number=0; k < aFindStrings.length; ++k)
			{
				sBaseString=sBaseString.split(aFindStrings[k]).join(" ");
			}
			return sBaseString;
		}
	}
}
