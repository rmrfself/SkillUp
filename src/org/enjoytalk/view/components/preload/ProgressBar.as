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
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ProgressBar extends Sprite
	{
		public var timer:Timer;

		private var fadeOutRate:Number=.10;

		private var _ready:Boolean=false;

		public var loadScreen:Mc_Preloader;

		public function ProgressBar()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, 0, true);
		}

		private function addToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			loadScreen=new Mc_Preloader();
			this.addChild(loadScreen);
		}

		public function set ready(b:Boolean):void
		{
			if (b)
			{
				closeScreen();
			}
		}

		public function get ready():Boolean
		{
			return _ready;
		}

		public function set progress(n:Number):void
		{
		}

		public function closeScreen(event:Event=null):void
		{
			loadScreen.alpha=0;
			removeChild(loadScreen);
		}


	}
}
