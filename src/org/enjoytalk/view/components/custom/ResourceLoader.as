package org.enjoytalk.view.components.custom
{

	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import mx.core.FlexGlobals;
	
	public class ResourceLoader
	{
		private var _remote_host:String;

		public static const DEFAULT_HOST:String="http://" + (mx.core.Application.application.parameters.host == null ? "192.168.1.133":mx.core.Application.application.parameters.host);

		private var _sound_effect_instance:Object;

		private var _application_background_image:UIComponent;

		private var loader:Loader;

		private var loaderContext:LoaderContext;

		public static const HOST_NUMBER:Array=[0, 1, 2, 3];

		public var HOST_STR:String= DEFAULT_HOST;

		public static const SOUND_EFFECT_URL:String="/apps/learning_tools/20110125/SoundEffects.swf"

		public static const DEFAULT_BACKGROUND_IMAGE:String="/apps/learning_tools/20110125/assets/sky.jpg"

		public function ResourceLoader()
		{
			loader=new Loader();
			loaderContext=new LoaderContext();
			loaderContext.applicationDomain=ApplicationDomain.currentDomain;
		}

		public function loadSoundEffects():void
		{
			var v:Number=new Date().getTime();
			var request:URLRequest=new URLRequest(SOUND_EFFECT_URL);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, soundLoadComplete);
			loader.load(request, loaderContext);
		}


		private function soundLoadComplete(event:Event):void
		{
			soundEffectInstance=loader.content["soundHolder"];
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, soundLoadComplete);
			loader.unload();
		}

		public function loadAppBackgroundImage():void
		{
			var request:URLRequest=new URLRequest(DEFAULT_BACKGROUND_IMAGE);
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, appImageLoadComplete);
			loader.load(request, loaderContext);
		}

		private function appImageLoadComplete(event:Event):void
		{
			applicationBackgroundImage=UIComponent(loader);
		}

		public function get remoteHost():String
		{
			var host:String="";
			var rand:Number=Math.floor(HOST_NUMBER.length * Math.random());
			host=HOST_STR.replace(/s%/ig, rand.toString());
			if (host.length > 0)
			{
				return host;
			}
			return DEFAULT_HOST;
		}

		public function get backgroundImageUrl():String
		{
			return DEFAULT_BACKGROUND_IMAGE;
		}

		public function set soundEffectInstance(value:Object):void
		{
			this._sound_effect_instance=value;
		}

		public function get soundEffectInstance():Object
		{
			return this._sound_effect_instance;
		}

		public function set applicationBackgroundImage(value:UIComponent):void
		{
			this._application_background_image=value;
		}

		public function get applicationBackgroundImage():UIComponent
		{
			return this._application_background_image;
		}
	}
}
