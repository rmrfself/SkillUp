/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.view.events
{
	import flash.events.Event;

	public class AnswerResult extends Event
	{
		public static const ANSWER_NAME:String = "answer";
		public static const ANSWER_RIGHT:String = "right";
		public static const ANSWER_WRONG:String = "wrong";
		
		public function AnswerResult(type:String, data:Object,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		public var data:Object ;
	}
}