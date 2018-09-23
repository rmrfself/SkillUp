package org.enjoytalk.view.components.custom
{
	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.UserProxy;
	import org.enjoytalk.model.vo.Course;
	import org.enjoytalk.model.vo.User;

	public class AppSettins
	{
		private var _user:User;
		protected var _facade:ApplicationFacade;
		protected var _userProxy:UserProxy;
		private var _course:Course;


		public function AppSettins()
		{
		}

		public function needScheduleOption():Boolean
		{
			return _user.isAuthenticated;
		}

		public function supportLanguage():Boolean
		{
			return (LanguageCodeManager.getInstance().isJapaneseCourse() || LanguageCodeManager.getInstance().isChineseCourse());
		}

		public function needToDisplayTrialMode():Boolean
		{
			return (Boolean(!this._user.isAuthenticated && !this.supportLanguage() || this._user.isAuthenticated && this._user.firstTimeIn && !this.supportLanguage()));
		}

		public function get course():Course
		{
			return _course;
		}

		public function set course(value:Course):void
		{
			_course=value;
		}

		public function get user():User
		{
			return _user;
		}

		public function set user(value:User):void
		{
			_user=value;
		}


	}
}
