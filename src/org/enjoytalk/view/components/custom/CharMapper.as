package org.enjoytalk.view.components.custom
{

	public class CharMapper
	{
		private var _map:Object;
		private var validate:Object;

		static var _instance:CharMapper;

		public function CharMapper()
		{
			_map={Ą: "a", ą: "a", Ą: "a", ą: "a", ā: "a", á: "a", ǎ: "a", à: "a", a: "a", Á: "a", À: "a", Â: "a", Ã: "a", Ä: "a", Å: "a", Æ: "a", å: "a", ä: "a", ã: "a", â: "a", æ: "a", Ā: "a", Ă: "a", ă: "a", Ạ: "a", ạ: "a", ả: "a", Ả: "a", Ấ: "a", ấ: "a", Ầ: "a", ầ: "a", Ẩ: "a", ẩ: "a", Ẫ: "a", ẫ: "a", Ậ: "a", ậ: "a", Ắ: "a", ắ: "a", Ằ: "a", ằ: "a", Ẳ: "a", ẳ: "a", Ẵ: "a", ẵ: "a", Ặ: "a", ặ: "a", Ǎ: "a", ǻ: "a", Ǻ: "a", ǽ: "a", Ǽ: "a", Ć: "c", ć: "c", Ĉ: "c", ĉ: "c", Ċ: "c", ċ: "c", Č: "c", č: "c", Ç: "c", ç: "c", Ď: "d", ď: "d", Đ: "d", đ: "d", ē: "e", é: "e", ě: "e", è: "e", e: "e", É: "e", Ê: "e", Ë: "e", ê: "e", ë: "e", Ē: "e", Ĕ: "e", ĕ: "e", Ė: "e", ė: "e", Ę: "e", ę: "e", Ě: "e", ế: "e", ề: "e", Ề: "e", Ể: "e", ể: "e", ễ: "e", Ễ: "e", ệ: "e", Ệ: "e", ə: "e", Ẹ: "e", ẹ: "e", Ẻ: "e", ẻ: "e", ẽ: "e", Ẽ: "e", Ế: "e", Ĥ: "h", ĥ: "h", Ħ: "h", ħ: "h", ī: "i", í: "i", ǐ: "i", ì: "i", i: "i", Ì: "i", Í: "i", Î: "i", Ï: "i", î: "i", ï: "i", Ĩ: "i", ĩ: "i", Ī: "i", Ĭ: "i", ĭ: "i", Į: "i", į: "i", İ: "i", ı: "i", Ĳ: "i", Ỉ: "i", ỉ: "i", Ị: "i", ị: "i", ĳ: "i", Ĵ: "j", ĵ: "j", Ķ: "k", ķ: "k", ĸ: "k", Ĺ: "l", ĺ: "l", ļ: "l", Ļ: "l", Ľ: "l", ľ: "l", Ŀ: "l", ŀ: "l", Ł: "l", ł: "l", Ñ: "n", ñ: "n", Ń: "n", ń: "n", Ņ: "n", Ň: "n", ň: "n", ŉ: "n", Ŋ: "n", ŋ: "n", ō: "o", ó: "o", ǒ: "o", ò: "o", o: "o", Ò: "o", Ó: "o", Ô: "o", Õ: "o", Ö: "o", õ: "o", ô: "o", ö: "o", Ọ: "o", ọ: "o", Ỏ: "o", ỏ: "o", Ố: "o", ố: "o", Ồ: "o", ồ: "o", Ổ: "o", ổ: "o", Ỗ: "o", ỗ: "o", Ộ: "o", ộ: "o", Ớ: "o", ớ: "o", Ờ: "o", ờ: "o", Ở: "o", ở: "o", Ỡ: "o", ỡ: "o", Ợ: "o", ợ: "o", Ø: "o", Ō: "o", Ŏ: "o", ŏ: "o", Ő: "o", ő: "o", Ǒ: "o", Ǿ: "o", ǿ: "o", Ơ: "o", Ŕ: "r", ŕ: "r", Ŗ: "r", ŗ: "r", Ř: "r", ř: "r", ǖ: "u", ǘ: "u", ǚ: "u", ǜ: "u", ü: "u", ū: "u", ú: "u", ǔ: "u", ù: "u", u: "u", Ù: "u", Ú: "u", Û: "u", Ü: "u", û: "u", Ũ: "u", ũ: "u", Ū: "u", Ŭ: "u", ŭ: "u", Ů: "u", ů: "u", Ű: "u", ű: "u", Ų: "u", ų: "u", Ụ: "u", ụ: "u", Ủ: "u", ủ: "u", Ứ: "u", ứ: "u", Ừ: "u", ừ: "u", Ử: "u", ử: "u", Ữ: "u", ữ: "u", Ự: "u", ự: "u", Ư: "u", ư: "u", Ǔ: "u", Ǖ: "u", Ǘ: "u", Ǚ: "u", Ǜ: "u", Ś: "s", ś: "s", Ŝ: "s", ŝ: "s", Ş: "s", ş: "s", Š: "s", š: "s", ß: "s", Ţ: "t", ţ: "t", Ť: "t", Ŧ: "t", ŧ: "t", Þ: "t", þ: "t", Ĝ: "g", ĝ: "g", Ğ: "g", ğ: "g", Ġ: "g", Ģ: "g", ģ: "g", Ŵ: "w", ŵ: "w", Ẁ: "w", ẁ: "w", Ẃ: "w", ẃ: "w", Ẅ: "w", ẅ: "w", Ỳ: "y", ỳ: "y", Ỵ: "y", ỵ: "y", Ỷ: "y", ỷ: "y", Ỹ: "y", ỹ: "y", Ý: "y", Ŷ: "y", ŷ: "y", Ÿ: "y", ý: "y", ÿ: "y", Ź: "z", ź: "z", Ż: "z", ż: "z", Ž: "z", ž: "z"};
		}

		static function getInstance():CharMapper
		{
			if (CharMapper._instance == null)
			{
				_instance=new CharMapper();
			}
			return _instance;
		}

		public function getMappedChar(char:String):String
		{
			var ch:String=char.charAt(0);
			return (this.validate(_map[ch], ch));
		}

		private function validate(value:*, defaultValue:*):*
		{
			return (value == null ? (defaultValue) : (value));
		}

		public function getMappedString(str:String):String
		{
			var mappedStr="";
			for (var k:Number=0; k < str.length; k++)
			{
				mappedStr=mappedStr + this.getMappedChar(str.charAt(_loc2));
			}
			return mappedStr;
		}
	}
}
