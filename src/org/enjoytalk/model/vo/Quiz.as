/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Quiz Vo
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.model.vo
{
	import org.enjoytalk.view.components.custom.LanguageCodeManager;

	public class Quiz extends DataContent
	{
		protected var _answer:String;

		protected var _question:String;

		public function Quiz(type:String)
		{
			super(type);
		}

		public function get answer():String
		{
			return _answer;
		}

		public function set answer(value:String):void
		{
			_answer=value;
		}

		public function get question():String
		{
			return _question;
		}

		public function set question(value:String):void
		{
			_question=value;
		}

		public function setContent(q:String, a:String):void
		{
			this._question=q;
			this.answer=a;
		}
	}
}
