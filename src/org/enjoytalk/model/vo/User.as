/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: StudyTarget Vo
 * 1. The studytarget  defines a  abstract middle layer between  veiw and model.
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.model.vo
{

	public class User
	{
		private var _id:Number;
		private var _email:String;
		private var _href:String;
		private var _icon:String;
		private var _user_name:String;
		private var _password:String;
		private var _state:String;
		private var _firstTimeIn:Boolean;
		private var _canStudy:Boolean;
		private var _isExpired:Boolean;
		private var _isAuthenticated:Boolean;
		private var _expiredDate:String;
		private var _isVip:Boolean;
		private var _pcode:String;


		public function guestName():String
		{
			return "用户";
		}

		public function get id():Number
		{
			return _id;
		}

		public function set id(value:Number):void
		{
			this._id = value;
		}

		public function getPopulizeLink():String
		{
			return "http://localhost/begin_study?pcode=" + this.pcode;
		}

		public function get pcode():String
		{
			return this._pcode;
		}

		public function set pcode(value:String):void
		{
			this._pcode = value;
		}

		public function get isVip():Boolean
		{
			return this._isVip;
		}

		public function set isVip(value:Boolean):void
		{
			this._isVip = value;
		}

		[Bindable]
		public function get email():String
		{
			return _email;
		}

		public function set email(value:String):void
		{
			this._email = value;
		}

		[Bindable]
		public function get userName():String
		{
			return _user_name;
		}

		public function set userName(value:String):void
		{
			this._user_name = value;
		}

		[Bindable]
		public function get icon():String
		{

			return _icon;
		}

		public function set icon(value:String):void
		{
			this._icon = value;
		}

		public function get password():String
		{
			return _password;
		}

		public function set password(value:String):void
		{
			this._password = value;
		}

		[Bindable]
		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			this._state = value;
		}

		public function get firstTimeIn():Boolean
		{
			return _firstTimeIn;
		}

		public function set firstTimeIn(value:Boolean):void
		{
			_firstTimeIn = value;
		}

		public function get canStudy():Boolean
		{
			return _canStudy;
		}

		public function set canStudy(value:Boolean):void
		{
			_canStudy = value;
		}

		public function get isExpired():Boolean
		{
			return _isExpired;
		}

		public function set isExpired(value:Boolean):void
		{
			_isExpired = value;
		}

		public function get isAuthenticated():Boolean
		{
			return _isAuthenticated;
		}

		public function set isAuthenticated(value:Boolean):void
		{
			_isAuthenticated = value;
		}

		public function get newUserMessage():String
		{
			return this.userName + ",欢迎您";
		}

		public function get oldUserMessage():String
		{
			return this.userName + ",欢迎您再回来";
		}

		public function get expiredDate():String
		{
			return _expiredDate;
		}

		public function set expiredDate(value:String):void
		{
			_expiredDate = value;
		}

	}
}
