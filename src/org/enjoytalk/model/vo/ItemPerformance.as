package org.enjoytalk.model.vo
{

	public class ItemPerformance
	{
		/**
		 *
		 *
		 * **/
		public var lastSessionPresentationCount:Number=-1;
		/**
		 * presentationCount
		 *
		 * **/
		public var presentationCount:Number=0;
		/**
		 * studyCount
		 *
		 * **/
		public var studyCount:Number=0;
		/**
		 * noConfRecallCount
		 *
		 *
		 * ***/
		public var noConfRecallCount:Number=0;
		/**
		 * lowConfRecallCount
		 *
		 * **/
		public var lowConfRecallCount:Number=0;
		/**
		 * highConfRecallCount
		 *
		 *
		 * **/
		public var highConfRecallCount:Number=0;
		/**
		 * revStudyCount
		 *
		 * **/
		public var revStudyCount:Number=0;
		/**
		 * revNoConfRecallCount
		 *
		 * **/
		public var revNoConfRecallCount:Number=0;
		/**
		 * revLoConfRecallCount
		 *
		 * **/
		public var revLoConfRecallCount:Number=0;
		/**
		 * revHiConfRecallCount
		 *
		 * **/
		public var revHiConfRecallCount:Number=0;
		/**
		 * studyGotItCount
		 *
		 * **/
		public var studyGotItCount:Number=0;
		/**
		 *
		 *  **/
		public var lowConf1stRecallCorrect:Number=0;

		/**
		 *
		 ***/
		public var highConf1stRecallCorrect:Number=0;

		/**
		 * correct count
		 *
		 * **/
		public var confCorrectCount:Number=0;
		public var revConfCorrectCount:Number=0;
		/**
		 *
		 *
		 ***/
		public var lowConfCorrectCount:Number=0;

		/**
		 * highConfCorrectCount
		 *
		 *
		 * **/
		public var highConfCorrectCount:Number=0;

		/**
		 * revStudyGotItCount
		 *
		 *
		 ***/
		public var revStudyGotItCount:Number=0;

		/**
		 * lowRevConfCorrectCount
		 *
		 * **/
		public var lowRevConfCorrectCount:Number=0;

		/**
		 * highRevConfCorrectCount
		 *
		 ***/
		public var highRevConfCorrectCount:Number=0;

		/**
		 * displayRecallScreenCount
		 *
		 * **/
		public var displayRecallScreenCount:Number=0;

		public var _studyTimeMS:Number=0;

		public var isSkip:Boolean=false;


		/** get / set functions below  **/
		public function get recallPresentationCount():Number
		{
			return (noConfRecallCount + lowConfRecallCount + highConfRecallCount);
		}

		public function get revRecallPresentationCount():Number
		{
			return (revNoConfRecallCount + revLoConfRecallCount + revHiConfRecallCount);
		}

		public function get studyTimeSec():Number
		{
			return (Math.ceil(_studyTimeMS));
		}

		public function set studyTimeSec(time:Number):void
		{
			_studyTimeMS=time;
		}
	}
}
