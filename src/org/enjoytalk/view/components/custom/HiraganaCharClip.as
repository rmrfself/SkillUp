package org.enjoytalk.view.components.custom
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class HiraganaCharClip extends EnglishCharClip
	{
		public function HiraganaCharClip()
		{
			super();
		}

		override public function get isWrongAnswer():Boolean
		{
			return SpellCheckerJp.checkMatch(correctChar, char, false) != 0;
		}
	}
}
