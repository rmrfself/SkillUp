package org.enjoytalk.view.components.custom
{
	import flash.net.SharedObject;

	public class SharedObjectManager
	{
		private var _sharedObject:SharedObject;
		private var _currentCourseId:Number;
		private var _allowingSpecialCharacter:Boolean=false;
		private var _spellCheckMode:Number;
		private var _checkingMode:Number;
		private var _spellType:Number;
		private var _performanceQuality:Number;
		private var _useEmbeddedFont:Boolean=true;
		private var _playResponseSound:Boolean=false;

		private var _differentCourse:Boolean;

		private static var _instance:SharedObjectManager;


		public function SharedObjectManager()
		{
			_sharedObject=SharedObject.getLocal(AppConstants.appName(), "/");
			_differentCourse=true;
		}

		private function validate(src:*, obj:*):*
		{
			return src == null ? obj : src;
		}

		public function get hasSharedObject():Boolean
		{
			return (Boolean(_sharedObject != null));
		}

		public function get isDifferentCourseFromLast():Boolean
		{
			return _differentCourse;
		}

		public function get currentCourseID():Number
		{
			return 0;
		}

		public function set currentCourseID(id:Number):void
		{
			_differentCourse=this.getValue("courseID") != id;
			if (_differentCourse)
			{
				this.resetCourseBasedValues();
			}
			this.setValue("courseID", id);
		}

		public function resetCourseBasedValues():void
		{
			this.clearValue("selectedSequenceID");
		}

		public static function getInstance():SharedObjectManager
		{
			if (_instance == null)
			{
				_instance=new SharedObjectManager();
			}
			return _instance;
		}

		public function getValue(sDataName:String, defaultValue:*=null):*
		{
			var data:*=_sharedObject.data[sDataName];
			if (data == null)
			{
				data=defaultValue;
			}
			return data;
		}

		public function setValue(sDataName:String, value:*):void
		{
			_sharedObject.data[sDataName]=value;
			_sharedObject.flush();
		}

		public function get size():Number
		{
			return _sharedObject.size;
		}

		public function clearValue(sDataName:String):void
		{
			delete _sharedObject.data[sDataName];
		}


		public function get useEmbeddedFont():Boolean
		{
			return (this.getValue("useEmbeddedFont", true));
		}

		public function set useEmbeddedFont(bn:Boolean):void
		{
			this.setValue("useEmbeddedFont", this.validate(bn, true));
		}

		public function set sessionLength(limit:Number):void
		{
			this.setValue("sessionLength", this.validate(limit, 10));
		}

		public function get sessionLength():Number
		{
			return this.getValue("sessionLength", 10);
		}

		public function get sharedObject():SharedObject
		{
			return _sharedObject;
		}

		public function set sharedObject(value:SharedObject):void
		{
			_sharedObject=value;
		}

		public function get currentCourseId():Number
		{
			return this.validate(this.getValue("courseID"), _currentCourseId);
		}

		public function set currentCourseId(value:Number):void
		{
			this._differentCourse=(this.getValue("courseID") != value)
			this.setValue("courseID", value);
			_currentCourseId=value;
		}
	}
}
