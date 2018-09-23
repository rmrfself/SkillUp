package org.enjoytalk.model.vo
{

	public class DataContent
	{
		private var _type:String;
		private var _value:*;
		private var _extraData:DataContent;

		public static const CUE:String="cue";
		public static const RESPONSE:String="response";
		public static const MEANING_RESPONSE:String="meaning";
		public static const CHARACTER:String="character";
		public static const SOUND:String="sound";
		public static const IMAGE:String="image";
		public static const TEXT:String="text";
		public static const TRANSLATION:String="translation";
		public static const SENTENCE:String="sentence";
		public static const MCQUIZ:String="mcquiz";
		public static const SPELLQUIZ:String="spellquiz";
		public static const TRANSLITERATION_KANA:String="kana";
		public static const TRANSLITERATION_SIMPLIFIED:String="simplified_chinese";
		public static const TRANSLITERATION_EXTRA:String="extra";
		public static const TRANSLITERATION_ROMANIZED:String="roman";

		public static var ROMANIZED:String="Latn";
		public static var KANA:String="Hrkt";
		public static var SIMPLIFIED_CHINESE:String="Hans";
		public static var NATIVE_TRANSLITERATION:String="Zyyy";

		public static var SPELLING_QUIZ:String="spelling";
		public static var MC_QUIZ:String="multiple_choice";

		public function DataContent(type:String)
		{
			this._type=type;
		}

		public function toString():*
		{
			return value ? value : null;
		}


		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type=value;
		}

		public function get value():*
		{
			return _value;
		}

		public function set value(value:*):void
		{
			_value=value;
		}

		public function get extraData():DataContent
		{
			return _extraData;
		}

		public function set extraData(value:DataContent):void
		{
			_extraData=value;
		}

	}
}
