/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Selection Vo
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.model.vo
{

	public class Selection
	{
		[Bindable]
		public var label:String;
		[Bindable]
		public var isAnswer:Boolean;
		[Bindable]
		public var isEnable:Boolean;
		[Bindable]
		public var answered:Boolean;

		[Bindable]
		public var language:String;

		[Bindable]
		public var transLanguage:String;

		[Bindable]
		public var correctLabel:String;
	}
}
