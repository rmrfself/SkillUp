package org.enjoytalk.view.components.custom
{

	public class LanguageCodeManager extends Object
	{

		private var _cueLanguageCode:String;
		private var _contentCode:String;
		private var _responseLanguageCode:String;
		private var _supportEmbeddedFontContent:Boolean=false;

		public static var _instance:LanguageCodeManager;

		public var fontList:Array;

		public static var CODES:Object={ENGLISH: "en", JAPANESE: "ja", KOREAN: "ko", TAIWAN: "zh-Hant", MANDARIN: "zh-Hans", IPA: "ipa", MAORI: "mi"};
		public static var FONT_NAMES:Object=new Object();
		public static var useIPAFont:Boolean=false;

		public function LanguageCodeManager()
		{
			fontList=new Array();
		}

		public function validate(value:*, defaultValue:*):*
		{
			return (value == null ? (defaultValue) : (value));
		}

		public function isSupportEmbeddedFont(code:String):Boolean
		{
			code=this.validate(code, cueLanguageCode);
			switch (code)
			{
				case CODES.ENGLISH:
				case CODES.JAPANESE:
				{
					return true;
				}
			}
			return false;
		}

		public function isJapaneseCourse():Boolean
		{
			return isJapaneseCode(cueLanguageCode);
		}

		public function isEnglishCourse():Boolean
		{
			return isEnglishCode(cueLanguageCode);
		}

		public function isChineseCourse():Boolean
		{
			return isChineseCode(cueLanguageCode);
		}

		public function isKoreanCourse():Boolean
		{
			return isKoreanCode(cueLanguageCode);
		}

		public function get contentCode():String
		{
			return this.validate(_contentCode, CODES.MANDARIN) as String;
		}

		public function setContentCode(codes:Array):void
		{
			for (var k:Number=0; k < codes.length; k++)
			{
				if (codes[k] != CODES.ENGLISH)
				{
					_contentCode=codes[k];
					break;
				}
			}
		}

		public function get supportEmbeddedFontContent():Boolean
		{
			return (cueLanguageCode == CODES.ENGLISH || responseLanguageCode == CODES.ENGLISH || cueLanguageCode == CODES.JAPANESE && responseLanguageCode == CODES.JAPANESE);
		}

		public static function getInstance():LanguageCodeManager
		{
			if (LanguageCodeManager._instance == null)
			{
				_instance=new LanguageCodeManager();
			}
			return (LanguageCodeManager._instance);
		}

		public static function isKoreanCode(code:String):Boolean
		{
			return Boolean(code.toLowerCase() == CODES.KOREAN);
		}

		public static function isEnglishCode(code:String):Boolean
		{
			return Boolean(code.toLowerCase() == CODES.ENGLISH);
		}

		public static function isJapaneseCode(code:String):Boolean
		{
			return Boolean(code.toLowerCase() == CODES.JAPANESE);
		}

		public static function isChineseCode(code:String):Boolean
		{
			return Boolean(code.toLowerCase() == CODES.MANDARIN.toLowerCase());
		}

		public function getFontList():Array
		{
			fontList.addUnique(this.cueLanguageCode);
			fontList.addUnique(this.contentCode);
			if (LanguageCodeManager.useIPAFont)
			{
				fontList.addUnique(LanguageCodeManager.CODES.IPA);
			}
			return fontList;
		}


		public function getCueFontName():String
		{
			return this.getFontName(cueLanguageCode);
		}

		public function getResponseFontName():String
		{
			return this.getFontName(responseLanguageCode);
		}

		public function getContentFontName():String
		{
			return this.getFontName(this.contentCode);
		}

		public function getFontName(langCode:String):String
		{
			return this.isSupportEmbeddedFont(langCode) ? (LanguageCodeManager.FONT_NAMES[langCode.toLowerCase()]) : (null);
		}

		public function getIPAFontName():String
		{
			return (LanguageCodeManager.useIPAFont ? (LanguageCodeManager.FONT_NAMES[LanguageCodeManager.CODES.IPA]) : (this.getContentFontName()));
		}

		public function setFontName(code:String, name:String):void
		{
			FONT_NAMES[code]=name;
		}

		public function get cueLanguageCode():String
		{
			return _cueLanguageCode;
		}

		public function set cueLanguageCode(value:String):void
		{
			_cueLanguageCode=value;
		}

		public function get responseLanguageCode():String
		{
			return _responseLanguageCode;
		}

		public function set responseLanguageCode(value:String):void
		{
			_responseLanguageCode=value;
		}

		public function set supportEmbeddedFontContent(value:Boolean):void
		{
			_supportEmbeddedFontContent=value;
		}


	}
}
