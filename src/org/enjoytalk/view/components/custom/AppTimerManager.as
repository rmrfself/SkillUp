package org.enjoytalk.view.components.custom
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	public class AppTimerManager extends UIComponent
	{
		static public var _instance:AppTimerManager;

		private var _timer:Timer;

		public static var INTERVAL:Number=1000;

		private var _appLifeCount:Number=0;
		private var _studyLifeCount:Number=0;
		private var _currentCount:Number=0;

		private var _parentReference:SkillUp;

		private var _timerCallbacks:Dictionary;

		static public var STUDY_TIMER:String="studyTimer";
		static public var APP_TIMER:String="appTimer";
		static public var ITEM_TIMER:String="itemTimer";

		static public var PAUSE_EVENT_NAME:String="pauseEvent";
		static public var RESUME_EVENT_NAME:String="resumeEvent";

		private var _pauseWindow:PauseWindow;


		private var _pauseState:Boolean=false;

		private var _idleStateCounter:Number=0;

		private var _isBeginStudy:Boolean=false;

		public static var MAX_IDLE_TIME:Number=900;

		public function AppTimerManager()
		{
			super();
		}

		public function get isBeginStudy():Boolean
		{
			return _isBeginStudy;
		}

		public function set isBeginStudy(value:Boolean):void
		{
			_isBeginStudy=value;
		}

		public function setParentReference(_app:SkillUp):void
		{
			_parentReference=_app;
		}


		public function get idleStateCounter():Number
		{
			return _idleStateCounter;
		}

		public function set idleStateCounter(value:Number):void
		{
			_idleStateCounter=value;
		}

		public function get pauseState():Boolean
		{
			return _pauseState;
		}

		public function set pauseState(value:Boolean):void
		{
			_pauseState=value;
		}

		public function get currentCount():Number
		{
			return _currentCount;
		}

		public function set currentCount(value:Number):void
		{
			_currentCount=value;
		}

		public function get studyLifeCount():Number
		{
			return _studyLifeCount;
		}

		public function set studyLifeCount(value:Number):void
		{
			_studyLifeCount=value;
		}

		public function get appLifeCount():Number
		{
			return _appLifeCount;
		}

		public function set appLifeCount(value:Number):void
		{
			_appLifeCount=value;
		}

		static public function getInstance():AppTimerManager
		{
			if (_instance == null)
			{
				_instance=new AppTimerManager();
			}
			return _instance;
		}

		private function resetIdleCounter(event:MouseEvent):void
		{
			_idleStateCounter=0;
		}


		public function pauseTimer():void
		{
			if (_timer)
				_timer.stop();
		}


		public function resumeTimer():void
		{
			if (_timer)
				_timer.start();
		}

		public function resetTimer():void
		{
			_idleStateCounter=0;
			_studyLifeCount=0;
		}


		public function getTimer():Timer
		{
			return _timer;
		}


		public function startTimer():void
		{
			_timerCallbacks == new Dictionary();
			_timer=new Timer(INTERVAL, 0);
			_timer.addEventListener(TimerEvent.TIMER, intervalHandler);
			this._parentReference.addEventListener(MouseEvent.MOUSE_MOVE, resetIdleCounter);
			_timer.start();
		}

		private function intervalHandler(event:TimerEvent):void
		{
			_currentCount++;
			if (_isBeginStudy)
			{
				if (_idleStateCounter++ > MAX_IDLE_TIME)
				{
					try
					{
						pauseTimer();
						dispatchEvent(new Event(PAUSE_EVENT_NAME));
						popUpPauseWin();
					}
					catch (e:Error)
					{
					}
					return;
				}
			}
			for (var key:* in _timerCallbacks)
			{
				switch (String(key))
				{
					case STUDY_TIMER:
						_studyLifeCount++;
						var studyTimerCallback:Function=_timerCallbacks[STUDY_TIMER];
						if (studyTimerCallback != null)
						{
							studyTimerCallback(_studyLifeCount);
						}
						break;
					case APP_TIMER:
						_appLifeCount++;
						break;
					case ITEM_TIMER:
						var itemSessionCallback:Function=_timerCallbacks[ITEM_TIMER];
						if (itemSessionCallback != null)
						{
							itemSessionCallback();
						}
					default:
						break;
				}
			}
		}

		public function unRegisterJobs(name:String):void
		{
			if (_timerCallbacks[name] != null)
			{
				delete _timerCallbacks[name];
			}

		}

		public function pauseAppTimer():void
		{
			pauseTimer();
			dispatchEvent(new Event(PAUSE_EVENT_NAME));
			popUpPauseWin();
		}

		private function popUpPauseWin():void
		{
			_pauseWindow=new PauseWindow();
			PopUpManager.addPopUp(_pauseWindow, _parentReference, true);
			PopUpManager.centerPopUp(_pauseWindow);
			_pauseWindow.addEventListener("resumeStudy", resumeStudy);
		}

		private function resumeStudy(event:Event):void
		{
			_idleStateCounter=0;
			PopUpManager.removePopUp(_pauseWindow);
			resumeTimer();
			dispatchEvent(new Event(RESUME_EVENT_NAME, true));
		}

		public function registerTimerJob(name:String, callback:Function):void
		{
			if (name == null || name.length == 0 || callback == null)
			{
				return;
			}
			if (_timerCallbacks == null)
			{
				_timerCallbacks=new Dictionary();
			}
			if (name == STUDY_TIMER)
			{
				this.studyLifeCount=0;
			}
			_timerCallbacks[name]=callback;
		}

	}
}
