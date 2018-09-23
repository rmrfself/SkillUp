/**
*  Class for checking user's input
 *
*/
package org.enjoytalk.view.components.custom
{

	public class SpellChecker
	{
		public function SpellChecker()
		{
		}

		/**
		 *
		 * @param sText
		 * @param caseSensitive
		 * @return
		 *
		 */
		public function cleanText(sText:String, caseSensitive:Boolean=false):String
		{
			sText=this.removeTaggedBlocks(sText, "(", ")");
			sText=sText.split("-").join(" ");
			if (!caseSensitive)
			{
				sText=sText.toLowerCase();
			}
			return (this.cleanSpaces(sText));
		}

		/**
		 *
		 * @param sText
		 * @param sOpenTag
		 * @param sCloseTag
		 * @return
		 *
		 */
		public function removeTaggedBlocks(sText:String, sOpenTag:String, sCloseTag:String):String
		{
			for (var k:Number=sText.lastIndexOf(sOpenTag); k > -1; k=sText.lastIndexOf(sOpenTag, k + 1))
			{
				var index:Number=sText.indexOf(sCloseTag, k);
				if (index > -1)
				{
					sText=sText.substr(0, k) + sText.substr(index + sCloseTag.length);
					k=index;
				}
			}
			return (this.cleanSpaces(sText));
		}

		/**
		 *
		 * @param text
		 * @return
		 *
		 */
		public function cleanSpaces(text:String):String
		{
			var eSpace:String=" ";
			var cSpace:String="　";
			for (var text:String=text.split(cSpace).join(eSpace); text.charAt(0) == eSpace; text=text.substring(1))
			{
			}
			while (text.charAt(text.length - 1) == eSpace)
			{
				text=text.substring(0, text.length - 1);
			}
			while (text.indexOf("  ") > -1)
			{
				text=text.split("  ").join(eSpace);
			}
			return (text);
		}
	}
}
