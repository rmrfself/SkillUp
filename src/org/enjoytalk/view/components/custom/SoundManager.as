/**
* Sound manager  / single tai
 *
*/
package org.enjoytalk.view.components.custom
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;


	public class SoundManager
	{
		public static const ANSWER_RIGHT:String="AnswerRight";

		public static const ANSWER_WRONG:String="AnswerWrong";

		public static const BTN_CLICK_ONE:String="BtnClickOne";

		public static const BTN_CLICK_TWO:String="BtnClickTwo";

		public static const LESSION_INTRO:String="LessionIntro";

		public static const LOADCOMPLETE:String="LoadComplete";

		public static const RECALL:String="Recall";

		public static const SPELL_PRESS:String="SpellPress";

		public static const SPELL_RIGHT:String="SpellRight";

		public static const SPELL_WRONG:String="SpellWrong";

		public static const TIMEOUT:String="TimeOut";

		private static var _instance:SoundManager;

		private static var _data:Object;

		public static var isPlaying:Boolean=false;

		public static var request:URLRequest;
		public static var sound:Sound=new Sound();
		public static var channel:SoundChannel=new SoundChannel();
		public static var soundTransform:SoundTransform=new SoundTransform(1);


		public static function getInstance():SoundManager
		{
			if (_instance == null)
			{
				sound=new Sound();
				channel=new SoundChannel();
				soundTransform=new SoundTransform
				_instance=new SoundManager();
			}
			return _instance;
		}


		public static function playEffectSound(label:String):void
		{
			if (data != null)
			{
				data.gotoAndPlay(label);
				data.gotoAndStop(0);
			}
		}

		public static function playAudioByUrl(url:String):void
		{
			if (url != null && url.length != 0 && url != "")
			{
				sound=null;
				if (isPlaying)
				{
					isPlaying=false;
				}
				request=new URLRequest(url);
				sound=new Sound();
				sound.load(request);
				sound.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				sound.addEventListener(Event.COMPLETE, loadComplete);
			}
		}

		private static function loadError(event:Event):Boolean
		{
			isPlaying=false;
			return false;
		}

		private static function loadComplete(event:Event):void
		{
			if (isPlaying)
			{
				channel.stop();
				isPlaying=false;
			}
			channel.soundTransform=soundTransform;
			channel=sound.play();
		}

		public static function get data():Object
		{
			return _data;
		}

		public static function set data(value:Object):void
		{
			_data=value;
		}

	}
}
