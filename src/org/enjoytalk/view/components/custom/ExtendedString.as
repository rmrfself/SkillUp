package org.enjoytalk.view.components.custom
{

	public class ExtendedString
	{

		public function ExtendedString()
		{
		}

		public static function extendPrototype():void
		{
			String.prototype.removeAllTagsExcept=function():String
			{
				var args:*=arguments;
				var tags:Array=["<b>", "</b>", "<spell>", "</spell>", "<br>", "<BR>", "<br />", "<BR />"];
				for (var k:Number=0; k < tags.length; k++)
				{
					if (args == null || args.hasValue(tags[k]) == -1)
					{
						return this.split(tags[k]).join("");
					}
				}
				return this;
			};
			String.prototype.setPropertyIsEnumerable('removeAllTagsExcept', false);

			String.prototype.convertBoldToSpell=function():String
			{
				return (this.split("<b>").join("<spell>").split("</b>").join("</spell>"));
			};
			String.prototype.setPropertyIsEnumerable('convertBoldToSpell', false);

			String.prototype.trim=function():String
			{
				return this.ltrim().rtrim();
			};
			String.prototype.setPropertyIsEnumerable('trim', false);

			String.prototype.ltrim=function():String
			{
				for (var k:Number=0; this.charCodeAt(k) == 9 || this.charCodeAt(k) == 10 || this.charCodeAt(k) == 13 || this.charCodeAt(k) == 32; k++)
				{
				}
				return this.substring(k, length);
			};
			String.prototype.setPropertyIsEnumerable('ltrim', false);

			String.prototype.rtrim=function():String
			{
				for (var k:Number=length - 1; this.charCodeAt(k) == 9 || this.charCodeAt(k) == 10 || this.charCodeAt(k) == 13 || this.charCodeAt(k) == 32; k--)
				{
				}
				return this.substring(0, k + 1);
			};
			String.prototype.setPropertyIsEnumerable('rtrim', false);
		}
	}

}
