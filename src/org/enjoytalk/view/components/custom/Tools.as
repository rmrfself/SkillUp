package org.enjoytalk.view.components.custom
{

	public class Tools
	{
		public function Tools()
		{
		}

		public static function isBooleanData(value:*):Boolean
		{
			if (typeof(value) == "boolean")
			{
				return true;
			}
			if (isNaN(value))
			{
				var label:String=String(value).toLowerCase();
				return (Boolean(label == "true" || label == "false"));
			}
			else
			{
				return false;
			}
		}

		public static function toBoolean(value:*, isNullTrue:*):Boolean
		{
			if (typeof(value) == "boolean")
			{
				return (value);
			}
			if (isNaN(value))
			{
				if (isNullTrue && value == null)
				{
					return true;
				}
				return (String(value).toLowerCase() == "true");
			}
			else
			{
				return Boolean(value);
			}
		}

		public static function getParsedData(value:*):*
		{
			if (typeof(value) == "boolean")
			{
				return value;
			}
			else if (isNaN(value))
			{
				return isBooleanData(value) ? toBoolean(value, null) : value;
			}
			else
			{
				return Number(value);
			}
		}

		public static function mergeObject(target:*, src:*):*
		{
			if (target == null)
			{
				target=new Object();
			}
			for (var attr:* in src)
			{
				target[attr]=src[attr];
			}
			return target;
		}


		public static function randRange(min:Number, max:Number):Number
		{
			return (Math.round(Math.random() * (max - min)) + min);
		}

		public static function omitDecimals(ori:Number, digit:Number):Number
		{
			if (isNaN(digit))
			{
				digit=0;
			}
			var tmp:Number=Math.pow(10, digit);
			return (Math.round(ori * tmp) / tmp);
		}


		public static function validate(value:*, defaultValue:*):*
		{
			return (value == null ? (defaultValue) : (value));
		}
	}
}
