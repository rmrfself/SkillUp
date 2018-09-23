package org.enjoytalk.view.components.custom
{

	public class AppConstants
	{
		public static function get defaultBackgroundImage():String
		{
			return "/docTools/extensions/shMaritimeUniv/tools/20110125/assets/sky.jpg"
		}

		public static function get skillUpSoundEffect():String
		{
			return "/docTools/extensions/shMaritimeUniv/tools/20110125/SoundEffects.swf"
		}

		public static function get defaultCouseXML():String
		{
			return (AppConstants.dataFolder + "default_course.xml");
		}

		public static function get dataFolder():String
		{
			return (AppConstants.appName() + "_data/");
		}

		public static function get commonImagesFolder():String
		{
			return "images/";
		}

		public static function get soundsFolder():String
		{
			return "sounds/";
		}

		public static function get sharedFolder():String
		{
			return "shared/";
		}

		public static function get appImagesFolder():String
		{
			return AppConstants.dataFolder + "images/";
		}

		public static function get fontFolder():String
		{
			return "/docTools/extensions/shMaritimeUniv/tools/20110125/assets/fonts";
		}

		public static function get styleFolder():String
		{
			return "/docTools/extensions/shMaritimeUniv/tools/20110125/";
		}

		public static function getUserInfoURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "get_user.xml";
		}

		public static function getLoginURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "login";
		}

		public static function getLogoutURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "logout";
		}

		public static function getRegisterUserURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "register_user";
		}

		public static function getLoginNameAvailabilityURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "username_available";
		}

		public static function getEmailAvailabilityURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "email_available";
		}

		public static function getFeedbackURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "send_screen_feedback";
		}

		public static function errorReportURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "flash_app_error";
		}

		public static function getSaveCourseParameterURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "save_course_parameters";
		}

		public static function getCourseDetailsURL():String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "set_user_course_details";
		}

		public static function getCourseURL(courseID:Number, userID:Number):String
		{
			return AppConstants.urlPrefix() + AppConstants.apiPath + "get_course.xml?" + "user_id=" + Tools.validate(userID, 1) + "&course_id=" + Tools.validate(courseID, 1) + "&time=";
		}


		public static function urlPrefix():String
		{
			return AppConstants.getServerUrl();
		}

		public static function getServerUrl():String
		{
			return "";
		}

		public static function appName():String
		{
			return "skillup";
		}

		public static var PLATFORMS:Array=["Browser"];
		public static var apiPath:String="/data_api/browser/";
		public static var _appName:String;
	}
}
