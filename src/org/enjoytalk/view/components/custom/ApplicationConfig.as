package org.enjoytalk.view.components.custom
{
	import flash.external.ExternalInterface;

	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.CourseProxy;
	import org.enjoytalk.model.UserProxy;

	public class ApplicationConfig
	{
		private static var _instance:ApplicationConfig;

		private var _facade:ApplicationFacade;
		private var _userProxy:UserProxy;
		private var _courseProxy:CourseProxy;

		private var _fontList:Array;

		private var _setting:AppSettins;

		public function ApplicationConfig()
		{
			_facade=ApplicationFacade.getInstance();
			_userProxy=UserProxy(_facade.retrieveProxy(UserProxy.NAME));
			_courseProxy=CourseProxy(_facade.retrieveProxy(CourseProxy.NAME));
			_setting=new SkillupSettings();
			_setting.course=(_courseProxy == null ? null : _courseProxy.course);
			_setting.user=(_userProxy == null ? null : _userProxy.user);
		}

		public function killBrowse():void
		{
			ExternalInterface.call("javascript:logout()");
		}

		public static function getInstance():ApplicationConfig
		{
			if (_instance == null)
			{
				_instance=new ApplicationConfig();
			}
			return _instance;
		}

		public function get setting():AppSettins
		{
			return _setting;
		}

		public function set setting(value:AppSettins):void
		{
			_setting=value;
		}

	}
}
