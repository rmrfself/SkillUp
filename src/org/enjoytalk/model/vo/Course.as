/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Course Vo
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.model.vo
{
	import flash.utils.Dictionary;

	public class Course
	{
		private var _course_id:Number;

		private var _courseTitle:String;

		private var _courseDisc:String;

		private var _cueLanguageCode:String;

		private var _responseLanguageCode:String;

		private var _icon:String;

		private var _totalItems:int;

		private var _author:User;

		public var session:CourseSession;

		public static var MINIMUM_REQUIRED_ITEM_COUNT:Number=5;

		public function Course()
		{
		}

		/***
		 * Lock the course
		 *
		 * */
		public function canStudy():Boolean
		{
			if (this._totalItems >= MINIMUM_REQUIRED_ITEM_COUNT)
			{
				return (this.session.remainingItemsToStudy > 0 && !this.session.completed)
			}
			else
			{
				return false;
			}
		}


		public function get courseId():Number
		{
			return _course_id;
		}

		public function set courseId(value:Number):void
		{
			this._course_id=value;
		}

		[Bindable]
		public function get courseTitle():String
		{
			return _courseTitle;
		}

		public function set courseTitle(value:String):void
		{
			_courseTitle=value;
		}

		[Bindable]
		public function get courseDisc():String
		{
			return _courseDisc;
		}

		public function set courseDisc(value:String):void
		{
			_courseDisc=value;
		}

		[Bindable]
		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			this._icon=value;
		}

		[Bindable]
		public function get cueLanguageCode():String
		{
			return _cueLanguageCode;
		}

		public function set cueLanguageCode(value:String):void
		{
			this._cueLanguageCode=value;
		}

		[Bindable]
		public function get responseLanguageCode():String
		{
			return _responseLanguageCode;
		}

		public function set responseLanguageCode(value:String):void
		{
			this._responseLanguageCode=value;
		}

		[Bindable]
		public function get totalItems():int
		{
			return _totalItems;
		}

		public function set totalItems(value:int):void
		{
			this._totalItems=value;
		}

		[Bindable]
		public function get author():User
		{
			return _author;
		}

		public function set author(value:User):void
		{
			this._author=value;
		}
	}
}
