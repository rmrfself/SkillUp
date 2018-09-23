/**
* SpellBox
 *
 *
*/
package org.enjoytalk.view.components.custom
{
	import flash.events.KeyboardEvent;

	import mx.containers.HBox;
	 
	import mx.core.UIComponent;
	import mx.messaging.events.MessageAckEvent;

	import org.enjoytalk.model.vo.Item;
	import org.enjoytalk.view.events.ToolsEvent;


	[Event(name="enterHandler", type="org.enjoytalk.view.events.ToolsEvent")]
	[Event(name="inputHandler", type="org.enjoytalk.view.events.ToolsEvent")]

	[Style(name="fontColor", type="Number", inherit="no")]
	[Style(name="lineColor", type="Number", inherit="no")]

	public class SpellBox extends UIComponent
	{
		public var smartSpell:SpellQuiz;

		public var input_str:String;

		public static const ENTER_DOWN_EVENT:String="enterDownEvent";

		public static const LAN_JA:String="ja";

		public static const LAN_EN:String="en";

		public static const LAN_HANS:String="zh-Hans";
		public static const LAN_HANT:String="zh-Hant";

		private var _item:Item;

		public function SpellBox()
		{
			super();
		}

		/**
		 * Display a new spell box
		 *
		 */
		public function display():void
		{
			var fontColor:Number;
			cleanUp();
			var languageManager:LanguageCodeManager=LanguageCodeManager.getInstance();
			switch (languageManager.cueLanguageCode)
			{
				case LAN_JA:
					smartSpell=new HiraganaSpellQuiz();
					break;
				case LAN_EN:
					smartSpell=new EnglishSpellQuiz();
					break;
				case LAN_HANS:
					smartSpell=new PinyinSpellQuiz();
					break;
				case LAN_HANT:
					smartSpell=new PinyinSpellQuiz();
					break;
			}
			if (smartSpell)
			{
				smartSpell.setSize(600, 200);
				smartSpell.setContent(item.cue.text, null);
				if (this.getStyle("fontColor") is Number)
				{
					fontColor=this.getStyle("fontColor");
					smartSpell.setCustomColor(fontColor);
				}
				smartSpell.name="smartSpell";
				addChildAt(smartSpell, 0);
				this.invalidateProperties();
				smartSpell.onDone=this.doneHandler;
				smartSpell.onFail=this.failHandler;
				smartSpell.onKeyDown=this.onKeyDownHandler;
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (smartSpell != null)
			{
				this.width=smartSpell.width;
				this.height=smartSpell.height;
			}
		}

		/**
		 *
		 *
		 */
		public function displayErrorInput(spellBox:SpellBox):void
		{
			smartSpell=spellBox.smartSpell;
			this.cleanUp();
			if (smartSpell != null)
			{
				smartSpell.setKeys(true);
				smartSpell.highlightWrongClips();
				addChild(smartSpell);
				this.width=smartSpell.width;
				this.height=smartSpell.height;
				this.invalidateSize();
			}
		}

		/**
		 *
		**/
		public function showRightAnswer(spellBox:SpellBox):void
		{
			smartSpell=spellBox.smartSpell;
			this.cleanUp();
			if (smartSpell != null)
			{
				smartSpell.setKeys(true);
				addChild(smartSpell);
				smartSpell.finish();
				this.width=smartSpell.width;
				this.height=smartSpell.height;
				this.invalidateSize();
			}
		}

		private function keyPressHandler(event:ToolsEvent):void
		{

		}

		private function doneHandler(level:Number, sInput:String, sCorrect:String):void
		{
			this.dispatchEvent(new ToolsEvent("enterHandler", true, false));
		}

		private function failHandler(level:Number, sInput:String, sCorrect:String):void
		{
			this.dispatchEvent(new ToolsEvent("enterHandler", false, false));
		}

		private function onKeyDownHandler(sInput:String):void
		{
			SoundManager.playEffectSound(SoundManager.SPELL_PRESS);
		}

		public function set item(value:Item):void
		{
			this._item=value;
		}

		public function get item():Item
		{
			return this._item;
		}

		public function get allCorrectText():String
		{
			return smartSpell.getAllCorrectText();
		}


		public function removeStageListener():void
		{
			if (smartSpell != null)
			{
				smartSpell.stage.removeEventListener(KeyboardEvent.KEY_UP, smartSpell.onKeyUp);
				smartSpell.removeEventListener(KeyboardEvent.KEY_UP, smartSpell.onKeyUp);
			}
		}

		public function cleanUp():void
		{

			if (this.numChildren > 0)
			{
				while (numChildren > 0)
				{
					var oldSpell:SpellQuiz=SpellQuiz(this.getChildAt(0));
					if (oldSpell)
					{
						oldSpell.unRender();
					}
					this.removeChildAt(0);
					oldSpell=null;
				}
			}
		}

	}
}
