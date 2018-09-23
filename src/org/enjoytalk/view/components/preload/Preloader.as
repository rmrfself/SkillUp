/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/

package org.enjoytalk.view.components.preload
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.events.FlexEvent;
	import mx.managers.BrowserManager;
	import mx.managers.SystemManager;
	import mx.preloaders.DownloadProgressBar;
	import mx.preloaders.SparkDownloadProgressBar;

	public class Preloader extends SparkDownloadProgressBar
	{
		public var loader:ProgressBar;
		private var _timer:Timer;

		public function Preloader()
		{
			super();
		}

		override public function initialize():void
		{
			super.initialize();
			this.loader = new ProgressBar();
			this.addChild(this.loader);
			this._timer = new Timer(1);
			this._timer.addEventListener(TimerEvent.TIMER, handleTimerTick);
			this._timer.start();
		}

		override public function set preloader(preloader:Sprite):void
		{
			preloader.addEventListener(ProgressEvent.PROGRESS, SWFDownLoadScreen);
			preloader.addEventListener(Event.COMPLETE, SWFDownloadComplete);
			preloader.addEventListener(FlexEvent.INIT_PROGRESS, FlexInitProgress);
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, FlexInitComplete);
		}

		private function SWFDownLoadScreen(event:ProgressEvent):void
		{
			var prog:Number = event.bytesLoaded / event.bytesTotal * 100;
			if (this.loader)
			{
				this.loader.progress = prog;
			}
		}

		private function handleTimerTick(event:TimerEvent):void
		{
			this.stage.addChild(this);
			this.loader.x = (this.stageWidth - this.loader.width) / 2;
			this.loader.y = (this.stageHeight - this.loader.height) / 2;
		}

		private function SWFDownloadComplete(event:Event):void
		{
		}

		private function FlexInitProgress(event:Event):void
		{
		}

		private function FlexInitComplete(event:Event):void
		{
			this.loader.ready = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		override protected function showDisplayForInit(elapsedTime:int, count:int):Boolean
		{
			return true;
		}

		override protected function showDisplayForDownloading(elapsedTime:int, event:ProgressEvent):Boolean
		{
			return true;
		}
	}
}
