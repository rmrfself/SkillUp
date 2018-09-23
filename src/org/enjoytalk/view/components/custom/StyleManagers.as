package org.enjoytalk.view.components.custom
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import mx.events.StyleEvent;
	import mx.modules.ModuleLoader;
	import mx.rpc.events.FaultEvent;
	import mx.styles.IStyleManager2;

	public class StyleManagers
	{
		private var _styleLoader:IStyleManager2;

		private var defaultStyle:String="Default.swf";

		private var _requestUrl:String;

		private var _onStyleLoaded:Function;
		private var _onStyleFail:Function;
		private var _onStyleProgress:Function;

		public function StyleManagers()
		{

		}

		public static var _instance:StyleManagers;

		public static function getInstance():StyleManagers
		{
			if (_instance == null)
			{
				_instance=new StyleManagers();
			}
			return _instance;
		}

		private function validate(src:*, obj:*):*
		{
			return (src == null ? obj : src);
		}

		public function loadStyle(_worker:IStyleManager2, styleName:String=null, callbackDown:Function=null, callbackFail:Function=null, callbackProgress:Function=null):void
		{
			_styleLoader=_worker;
			var name:String=this.validate(styleName, defaultStyle);
			requestUrl=AppConstants.styleFolder + name;
			var eventDispatcher:EventDispatcher=_styleLoader.loadStyleDeclarations(requestUrl, true) as EventDispatcher;
			eventDispatcher.addEventListener(StyleEvent.PROGRESS, onStyleProgress);
			eventDispatcher.addEventListener(StyleEvent.ERROR, onStyleFail);
			eventDispatcher.addEventListener(StyleEvent.COMPLETE, onStyleLoaded);
			_onStyleLoaded=(callbackDown == null ? null : callbackDown);
			_onStyleFail=(callbackFail == null ? null : callbackFail);
			_onStyleProgress=(callbackProgress == null ? null : callbackProgress);
		}


		private function onStyleLoaded(event:StyleEvent):void
		{
			if (_onStyleLoaded != null)
			{
				_onStyleLoaded(event);
			}
		}

		private function onStyleFail(event:StyleEvent):void
		{
			if (_onStyleLoaded != null)
			{
				_onStyleLoaded(event);
			}
		}

		private function onStyleProgress(event:StyleEvent):void
		{
			if (_onStyleProgress != null)
			{
				_onStyleProgress(event);
			}
		}

		public function get styleLoader():IStyleManager2
		{
			return _styleLoader;
		}

		public function set styleLoader(value:IStyleManager2):void
		{
			_styleLoader=value;
		}

		public function get requestUrl():String
		{
			return _requestUrl;
		}

		public function set requestUrl(value:String):void
		{
			_requestUrl=value;
		}

	}
}
