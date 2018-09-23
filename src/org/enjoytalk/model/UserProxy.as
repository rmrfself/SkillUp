/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: CourseProxy
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 * 3. 2011/01/27
 *
 **/
package org.enjoytalk.model
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.vo.ConstVar;
	import org.enjoytalk.model.vo.HistoryData;
	import org.enjoytalk.model.vo.User;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UserProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'UserProxy';

		public static const USER_STATE:String = "On";
		public static const USER_STATE_OFF:String = "Off";

		public static const USER_AUTH_SUC:String = "1";
		public static const USER_AUTH_FAIL:String = "0";

		public static const IS_VIP_USER:String = "true";

		private var _state:Boolean;

		private var _user:User;

		private var _historyData:HistoryData;

		private var _onUserLoaded:Function;
		private var _onUserFail:Function;
		private var _onUserProgress:Function;

		private var _onCheckLoaded:Function;
		private var _onCheckFail:Function;
		private var _onCheckProgress:Function;

		private var _loader:URLLoader;
		private var _request:URLRequest;

		private var _isAuthenticated:Boolean;


		public function UserProxy(data:Object = null)
		{
			super(NAME, null);
			_loader = new URLLoader();
			_request = new URLRequest();
		}

		public function loadUser(loadDone:Function = null, loadProgress:Function = null, loadFail:Function = null):void
		{
			var now:Date = new Date();
			var url:String = ConstVar.REQUEST_BASE_URL + ConstVar.GET_USER_PATH;
			_onUserLoaded = (loadDone == null ? null : loadDone);
			_onUserFail = (loadFail == null ? null : loadFail);
			_onUserProgress = (loadProgress == null ? null : loadProgress);
			_request.url = url;
			_loader.addEventListener(Event.COMPLETE, onUserLoaded);
			_loader.addEventListener(FaultEvent.FAULT, onUserFail);
			_loader.addEventListener(ProgressEvent.PROGRESS, onUserProgress);
			_loader.load(_request);
		}

		public function doAuth(doneCallback:Function, progressCallback:Function, failCallback:Function, param:Object):void
		{
			_onUserLoaded = (doneCallback == null ? null : doneCallback);
			_onUserFail = (failCallback == null ? null : failCallback);
			_onUserProgress = (progressCallback == null ? null : progressCallback);
			var service:HTTPService = new HTTPService;
			service.url = ConstVar.REQUEST_BASE_URL + ConstVar.POST_USER_VALIDATION;
			service.method = "POST";
			service.addEventListener(ResultEvent.RESULT, authSucHandler);
			service.addEventListener(FaultEvent.FAULT, onUserFail);
			_loader.addEventListener(ProgressEvent.PROGRESS, onUserProgress);
			param.authenticity_token = FlexGlobals.topLevelApplication.parameters._token;
			service.send(param);
		}

		private function authSucHandler(event:ResultEvent):void
		{
			setUserData(event.message.body.toString());
			if (_onUserLoaded != null)
			{
				_onUserLoaded(event);
			}

		}

		public function checkPayment(loadDone:Function = null, loadProgress:Function = null, loadFail:Function = null):void
		{
			var now:Date = new Date();
			var url:String = ConstVar.REQUEST_BASE_URL + ConstVar.GET_USER_PATH + "?v=" + now.getTime();
			_request.url = url;
			_loader.addEventListener(Event.COMPLETE, onCheckLoaded);
			_loader.addEventListener(FaultEvent.FAULT, onCheckFail);
			_loader.load(_request);
			_onCheckLoaded = (loadDone == null ? null : loadDone);
			_onCheckFail = (loadFail == null ? null : loadFail);
			_onCheckProgress = (loadProgress == null ? null : loadProgress);
		}

		private function onCheckLoaded(event:Event):void
		{
			onUserLoaded(event);
			if (_onCheckLoaded != null)
			{
				_onCheckLoaded();
			}
		}

		private function onCheckFail(event:FaultEvent):void
		{
			onUserFail(event);
			if (_onCheckFail != null)
			{
				_onCheckFail();
			}
		}

		private function onUserLoaded(event:Event):void
		{
			setUserData(event.target.data);
			if (_onUserLoaded != null)
			{
				_onUserLoaded(event);
			}
		}

		private function onUserFail(event:FaultEvent):void
		{
			if (_onUserFail != null)
			{
				_onUserFail(event);
			}
		}

		private function onUserProgress(event:ProgressEvent):void
		{
			if (_onUserProgress != null)
			{
				_onUserProgress(event);
			}
		}

		public function setUserData(xmlData:String):void
		{
			var user:User = new User();
			if (xmlData != null && xmlData != "")
			{
				var xmlTree:XML = new XML(xmlData);
				user.id = xmlTree.user.id;
				user.userName = xmlTree.user.nickname;
				user.pcode = xmlTree.user.pcode;
				if (xmlTree.user.status == USER_AUTH_SUC)
				{
					user.isExpired = false;
					user.isVip = true;
					user.expiredDate = xmlTree.user.expire_date;
					user.isAuthenticated = true;
					user.state = USER_STATE;
					state = true;
				}
				else
				{
					user.isAuthenticated = false;
					user.state = USER_STATE_OFF;
					state = false;
				}
			}
			else
			{
				user.isAuthenticated = false;
				state = false;
				user.state = USER_STATE_OFF;
			}
			this.user = user;
		}

		public function isFirstTimeUse():Boolean
		{
			return this.user.firstTimeIn;
		}

		public function isLoggedIn():Boolean
		{
			return state;
		}

		[Bindable]
		public function get user():User
		{
			return _user;
		}

		public function set user(value:User):void
		{
			_user = value;
		}

		public function get historyData():HistoryData
		{
			return _historyData;
		}

		public function set historyData(value:HistoryData):void
		{
			_historyData = value;
		}

		public function get state():Boolean
		{
			return _state;
		}

		public function set state(value:Boolean):void
		{
			_state = value;
		}
	}
}
