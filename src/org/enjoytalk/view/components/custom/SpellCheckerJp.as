/**
* SpellChecker for japanese
 *
*/
package org.enjoytalk.view.components.custom
{

	public class SpellCheckerJp extends SpellChecker
	{
		public var differ:Number=96;

		public function SpellCheckerJp()
		{
		}

		/**
		 *
		 * @param sInput
		 * @param sCorrect
		 * @param bStrictOn
		 * @return
		 *
		 */
		public function gradeSpelling(sInput:String, sCorrect:String, bStrictOn:Boolean=false):Number
		{
			if (sInput == null)
			{
				throw "SpellCheckerJP.gradeSpelling: sInput is undefined!";
			}
			if (sCorrect == null)
			{
				throw "SpellCheckerJP.gradeSpelling: sCorrect is undefined!";
			}
			sCorrect=this.cleanText(sCorrect);
			sInput=this.cleanText(sInput);
			var metchedLevel:Number=checkMatch(sCorrect, sInput, bStrictOn);
			return metchedLevel;
		}

		/**
		 *
		 * @param answer
		 * @param input
		 * @param strict
		 * @return
		 *
		 */
		public static function checkMatch(answer:String, input:String, strict:Boolean=false):Number
		{
			if (strict && (input == answer && answer != null && input != null))
			{
				return 0;
			}
			var level:Number=0;
			var diff_index:Number=Math.max(answer.length, input.length);
			for (var k:Number=0; k < diff_index; k++)
			{
				if (answer.charAt(k) != input.charAt(k) && (getTolerantChar(answer.charAt(k)) != input.charAt(k) || strict))
				{
					++level;
				}
			}
			return (level);
		}

		/**
		 *
		 * @param char
		 * @return
		 *
		 */
		public static function getTolerantChar(char:String):String
		{
			if (StringTools.isHiragana(char))
			{
				return (StringTools.changeZenkakuKatakanaFromHiragana(char));
			}
			else if (StringTools.isZenkakuKatakana(char))
			{
				return (String.fromCharCode(char.charCodeAt(0) - 96));
			}
			else
			{
				return (char);
			}
		}
	}
}
