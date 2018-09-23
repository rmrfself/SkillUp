package org.enjoytalk.view.components.custom
{

	public class ExtendedNumber
	{
		function ExtendedNumber()
		{
		}

		public static function extendPrototype():void
		{
			Number.prototype.isIn=function(low:Number, high:Number):Boolean
			{
				return (this >= low && this <= high);
			};
			Number.prototype.setPropertyIsEnumerable('isIn', false);

			Number.prototype.isOut=function(low:Number, high:Number):Boolean
			{
				return (this < low || this > high);
			};
			Number.prototype.setPropertyIsEnumerable('isOut', false);
		}
	}
}
