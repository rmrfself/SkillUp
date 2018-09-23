package org.enjoytalk.model.vo
{
	import org.enjoytalk.view.components.custom.LanguageCodeManager;

	public class PreviewObject
	{
		public function PreviewObject(data:Item, userState:Boolean=false)
		{
			this._item=data;
			this._onlineState=userState;
			setupContent();
		}

		private var _item:Item;

		private var _text:String;

		private var _extraData:String;

		private var _response:String;

		private var _progress:Number=0;

		private var _hint:Boolean;

		private var _language:String;

		private var _isSelected:Boolean=false;

		private var _charactor:String;

		private var _soundUrl:String;

		private var _imageUrl:String;

		private var _onlineState:Boolean;

		private var _isSkipped:Boolean;

		private var _hasImage:Boolean;

		public function setupContent():void
		{
			getCueText();
			getResponseText();
			getExtraData();
			if (hasImage())
			{
				getImage();
			}
			if (hasSound())
			{
				getSoundUrl();
			}
			getSessionProgress();

		}


		public function getCueText():String
		{
			this.text=this._item.cue.text;
			if (this._item.hasCharacter())
			{
				this.text=this._item.character;
			}
			else if (this._item.cue.extraData != null)
			{
				this.text=this._item.cue.extraData.value;
			}
			else if (this._item.cue.romanized != null)
			{
				this.text=this._item.cue.romanized;
			}
			return this._text;
		}


		public function hasCharacter():Boolean
		{
			return this._item.hasCharacter();
		}

		public function getExtraData():String
		{
			if (LanguageCodeManager.getInstance().isChineseCourse())
			{
				this.extraData=_item.cue.romanized;
			}
			else
			{
				this.extraData=_item.cue.text;
			}
			return this.extraData;
		}

		public function hasExtraData():Boolean
		{
			if (this.extraData != null && this.extraData.length > 0 && this.extraData != this.text)
			{
				return true;
			}
			return false;
		}

		public function hasImage():Boolean
		{
			if (_imageUrl != null)
			{
				return true;
			}
			for each (var sentence:SentenceData in _item.sentences)
			{
				if (sentence.image != null)
				{
					return true;
				}
			}
			return false;
		}


		public function getResponseText():String
		{
			this.response=_item.response.text;
			return _response;
		}

		public function getImage():String
		{
			if (this._item.sentences == null || this._item.sentences.length == 0)
			{
				return _imageUrl;
			}
			var images:Array=new Array();
			for each (var sentence:SentenceData in _item.sentences)
			{
				if (sentence.image != null)
				{
					images.push(sentence.image);
				}
			}
			if (images.length > 0)
			{
				_imageUrl=images.randomize()[0];
			}
			return _imageUrl;
		}

		public function getSessionProgress():Number
		{
			try
			{
				progress=item.session.itemStatus.progress;
			}
			catch (e:Error)
			{
				return 0;
			}
			return this._progress;
		}

		public function hasSound():Boolean
		{
			if (_soundUrl != null)
			{
				return true;
			}
			if (_item.cue.sound == null || _item.cue.sound == "" || _item.cue.sound.length == 0)
			{
				return false;
			}
			return true;
		}

		public function getSoundUrl():String
		{
			soundUrl=_item.cue.sound;
			return this._soundUrl;
		}

		private function isCueText():Boolean
		{
			return true;
		}


		public function get item():Item
		{
			return _item;
		}

		public function set item(value:Item):void
		{
			_item=value;
		}

		[Bindable]
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text=value;
		}

		[Bindable]
		public function get response():String
		{
			return _response;
		}

		public function set response(value:String):void
		{
			_response=value;
		}

		[Bindable]
		public function get progress():Number
		{
			return _progress;
		}

		public function set progress(value:Number):void
		{
			_progress=value;
		}

		[Bindable]
		public function get hint():Boolean
		{
			return _hint;
		}

		public function set hint(value:Boolean):void
		{
			_hint=value;
		}

		[Bindable]
		public function get language():String
		{
			return _language;
		}

		public function set language(value:String):void
		{
			_language=value;
		}

		[Bindable]
		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			_isSelected=value;
		}

		[Bindable]
		public function get charactor():String
		{
			if (_charactor == null)
			{
				this._charactor=_item.character;
			}
			return _charactor;
		}

		public function set charactor(value:String):void
		{
			_charactor=value;
		}

		[Bindable]
		public function get soundUrl():String
		{
			this._soundUrl=item.cue.sound;
			return _soundUrl;
		}

		public function set soundUrl(value:String):void
		{
			_soundUrl=value;
		}

		public function get imageUrl():String
		{
			return _imageUrl;
		}

		[Bindable]
		public function get onlineState():Boolean
		{
			return _onlineState;
		}

		public function set onlineState(value:Boolean):void
		{
			_onlineState=value;
		}

		[Bindable]
		public function get isSkipped():Boolean
		{
			var status:ItemStatus=item.session.itemStatus;
			_isSkipped=status.isSkipped;
			return _isSkipped;
		}

		public function set isSkipped(value:Boolean):void
		{
			var status:ItemStatus=item.session.itemStatus;
			status.isSkipped=value;
			_isSkipped=value;
		}

		[Bindable]
		public function get extraData():String
		{
			return _extraData;
		}

		public function set extraData(value:String):void
		{
			_extraData=value;
		}

	}
}
