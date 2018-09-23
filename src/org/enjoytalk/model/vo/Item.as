/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Item Vo
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 *
 **/
package org.enjoytalk.model.vo
{
	import mx.collections.ArrayCollection;

	public class Item
	{
		private var _id:Number;
		private var _type:String;

		private var _character:String;

		private var _response:ResponseData;
		private var _responses:Array;

		private var _cue:CueData;
		private var _cues:Array;

		private var _cueExtra:DataContent;

		private var _cueImage:String;

		private var _images:Array;
		private var _image:String;

		private var _sentence:SentenceData;

		private var _sentences:Array;

		private var _reversedItem:Item;

		private var _isImageType:Boolean;

		private var _mcQuiz:Quiz;

		private var _spellQuiz:Quiz;

		private var _romanized:String;

		private var _studyParameter:StudyParameter;

		/**
		 * a reference of session;
		 *
		 * **/
		public var session:ItemSession;

		protected function validate(src:*, obj:*):*
		{
			return (src == null ? obj : src);
		}


		public function setStudyParameter(param:StudyParameter):void
		{
			this._studyParameter=param;
		}

		public function Item(id:Number, type:String):void
		{
			_id=id;
			_type=this.validate(type, "text");
		}

		public function hasCharacter():Boolean
		{
			return (this.character != null && this.character.length > 0);
		}

		public function get id():Number
		{
			return _id;
		}

		public function set id(value:Number):void
		{
			_id=value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type=value;
		}

		public function get hasSound():Boolean
		{
			return Boolean(this.cue.sound != null && this.cue.sound != "");
		}

		/**
		 * single response instance
		 *
		 * **/
		public function get response():*
		{
			return this.responses[0];
		}


		public function get responses():Array
		{
			return _responses;
		}

		public function set responses(value:Array):void
		{
			_responses=value;
		}

		public function get cue():*
		{
			if (_cues == null)
			{
				_cues=new Array();
				if (_cue == null)
				{
					_cue=new CueData();
					cues.push(_cue);
				}
			}
			return _cues[0];
		}

		public function set cue(value:CueData):void
		{
			if (this._cues == null)
			{
				_cues=new Array();
			}
			_cues.push(value);
			_cue=value;
		}

		public function get cues():Array
		{
			return _cues;
		}

		public function set cues(value:Array):void
		{
			_cues=value;
		}

		public function get cueImage():String
		{
			return _cueImage;
		}

		public function set cueImage(value:String):void
		{
			_cueImage=value;
		}

		public function get images():Array
		{
			return _images;
		}

		public function set images(value:Array):void
		{
			_images=value;
		}

		/**
		 * sentences
		 *
		 * **/
		public function get sentence():SentenceData
		{
			return this.sentences[0] as SentenceData;
		}

		public function get sentences():Array
		{
			return _sentences;
		}

		public function set sentences(value:Array):void
		{
			_sentences=value;
		}

		/**
		 * reversed item
		 *
		 * **/
		public function get reversedItem():Item
		{
			if (_reversedItem == null)
			{
				_reversedItem=new Item(_id, _type);
				_reversedItem.cue=new CueData();
				_reversedItem.cue.text=this.response.text;
				_reversedItem.cue.sound=this.cue.sound;
				_reversedItem.responses=this.cues;
				_reversedItem.sentences=this.sentences;
				_reversedItem.images=this.images;
			}
			return _reversedItem;
		}

		/**
		 * @private
		 */
		public function set reversedItem(value:Item):void
		{
			_reversedItem=value;
		}

		public function get isImageType():Boolean
		{
			return _isImageType;
		}

		public function set isImageType(value:Boolean):void
		{
			_isImageType=value;
		}

		public function get mcQuiz():Quiz
		{
			return _mcQuiz;
		}

		public function set mcQuiz(value:Quiz):void
		{
			_mcQuiz=value;
		}

		public function get spellQuiz():Quiz
		{
			return _spellQuiz;
		}

		public function set spellQuiz(value:Quiz):void
		{
			_spellQuiz=value;
		}

		public function get character():String
		{
			return this.cue.character;
		}

		public function get image():String
		{
			return _image;
		}

		public function get cueExtra():DataContent
		{
			_cueExtra=this.cue.extraData;
			return _cueExtra;
		}

		public function get getTab():String
		{
			return "      	  \n";
		}

		public function get debugInfo():String
		{
			var result:String="";
			result=result + "item-text: " + cue.text + getTab;
			if (this.hasCharacter())
			{
				result=result + "item-character: " + this.character + getTab;
			}
			result=result + "item-sound: " + cue.sound + getTab;
			result=result + "item-image: " + this.image + getTab;
			result=result + "item-sentence: " + this.sentence.text + getTab;
			if (this.session == null)
			{
				return result;
			}
			var status:ItemStatus=this.session.itemStatus;
			result=result + "item-ratio: " + status.ratio + getTab;
			result=result + "item-cumulative_ratio_required_to_complete: " + status.cumulative_ratio_required_to_complete + getTab;
			result=result + "item-cumulative_ratio: " + status.cumulative_ratio + getTab;
			result=result + "item-presentation_count: " + status.presentation_count + getTab;
			result=result + "item-success_count: " + status.success_count + getTab;
			result=result + "item-above_threshold_count: " + status.above_threshold_count + getTab;
			result=result + "item-below_threshold_count: " + status.below_threshold_count + getTab;
			result=result + "item-cumulative_tatio: " + status.cumulative_tatio + getTab;
			result=result + "item-_is_skipped: " + status.isSkipped + getTab;
			result=result + "item-_progress: " + status.progress + getTab;
			result=result + "item-_is_new: " + status.isNew + getTab;
			result=result + "item-_is_completed: " + status.isCompleted + getTab;
			result=result + "item-_presenter: " + status.presenter + getTab;

			return result;
		}

	}
}
