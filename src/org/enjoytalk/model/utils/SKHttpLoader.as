package org.enjoytalk.model.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent ;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.ProgressBar;

	public class SKHttpLoader extends Sprite
	{
		private var _loader:URLLoader;
		

		public function SKHttpLoader(format:String)
		{
			super();
			_loader=new URLLoader();
			configureListeners();
			_loader.dataFormat=format;
		}

		public function load(req:URLRequest):void
		{
			try
			{
				_loader.load(req);
			}
			catch (error:Error)
			{
				trace("Unable to load  request document");
			}

		}
		
		
		public function getLoadedData():*{
			return _loader.data ;
		}


		private function configureListeners():void
		{
			_loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.addEventListener(Event.COMPLETE , completeHandler);
			_loader.addEventListener(Event.OPEN , openHandler);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}


		private function progressHandler(event:ProgressEvent, proressBar:ProgressBar):void
		{
			proressBar.setProgress(event.bytesLoaded , event.bytesTotal) ;
		}
		
		private function completeHandler(event:Event):void
		{
			
		}
		
		private function openHandler(event:Event):void
		{
			
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			
		}
	}
}