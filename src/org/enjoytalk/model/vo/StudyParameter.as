package org.enjoytalk.model.vo
{

	public class StudyParameter
	{
		public function StudyParameter()
		{
		}

		public var previewCue:String=DataContent.CUE;
		public var endCue:String=DataContent.CUE;
		public var cue:String=DataContent.CUE;
		public var cueExtra:String=DataContent.TRANSLITERATION_ROMANIZED;
		public var sentence:String=DataContent.SENTENCE;
		public var sentenceExtra:String=DataContent.TRANSLITERATION_ROMANIZED;
		public var isReversedMode:Boolean=false;
	}
}
