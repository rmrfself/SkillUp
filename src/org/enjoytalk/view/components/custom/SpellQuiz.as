/**
 * Spell quiz class
 * Date: 2011/03/09
 *
 * **/
package org.enjoytalk.view.components.custom
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;



	public class SpellQuiz extends MovieClip
	{
		public var fontSize:Number=22;

		public var additionalGoodChars:String=null;

		protected var _goodChars:String=null;

		protected var _char_manger:CharClipManager;

		protected var _characters:String;

		protected var _text:String;

		protected var _nWd:Number=0;

		protected var _nHt:Number=0;

		protected var _onDone:Function;

		protected var _onFail:Function;

		protected var _onKeyDown:Function;

		protected var _forceToUseStricMode:Boolean=false;

		protected var _answered:Boolean=false;

		public static const BREAK_COUNT:Number=15;

		public static const GOODCHARS:String="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ";

		/**
		 * Init
		 *
		 */
		public function SpellQuiz()
		{
			super();
			_goodChars=GOODCHARS + this.validate(additionalGoodChars, "");
			addEventListener(Event.ADDED_TO_STAGE, stageInit);
		}

		protected function validate(value:*, defaultValue:*):*
		{
			return (value == null ? (defaultValue) : (value));
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function stageInit(event:Event):void
		{
			if (stage.hasEventListener(KeyboardEvent.KEY_UP))
			{
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		/**
		 *
		 * @param nWd
		 * @param nHt
		 *
		 */
		public function setSize(nWd:Number, nHt:Number):void
		{
			_nWd=nWd;
			_nHt=nHt;
		}

		public function setCustomColor(color:Number):void
		{
			charManager.setCustomColor(color);
		}

		public function setFontSize(value:Number):void
		{
			this.fontSize=value;
		}

		/**
		 *
		 * @param text
		 * @param characters
		 *
		 */
		public function setContent(text:String, characters:String, readOnly:Boolean=false):void
		{
			_characters=characters;
			_text=text.replace("<br>", "|").replace("<br />", "|");
			_text=StringTools.trimInTaggedWord(_text, "b", 0);
			this.setCharManager();
			this.setKeys(readOnly);
		}

		/**
		 * Called back by setContent();
		 *
		 */
		public function setCharManager():void
		{
			this.charManager.setSize(_nWd, _nHt);
			this.charManager.createCharClips(_text, _goodChars, fontSize);
			addChild(charManager);
			this.charManager.select(0);
		}

		/**
		 *
		 * @param bOn
		 *
		 */
		public function setKeys(bOn:Boolean=false):void
		{
			if (!bOn)
			{
				this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			else
			{
				this.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
		}

		/**
		 *
		 * @param event
		 * Spell application input handler entry!
		 *
		 */
		public function onKeyUp(event:KeyboardEvent):void
		{
			var nKeyCode:Number=event.keyCode;
			if (nKeyCode == 8)
			{
				this.backspaceChar();
				return;
			}

			if (nKeyCode == 13)
			{
				checkSpelling();
				return;
			}

			if (nKeyCode == Keyboard.LEFT)
			{
				leftKeyHandler();
				return;
			}

			if (nKeyCode == Keyboard.RIGHT)
			{
				rightKeyHandler();
				return;
			}

			if (nKeyCode != 13)
			{
				onKeyEventHandler(nKeyCode);
			}
		}

		public function backspaceChar(count:Number=1):void
		{
			charManager.backspace(count);
			onKeyDown("");
		}

		/**
		 *
		 * @param nKeyCode
		 *
		 */
		public function onKeyEventHandler(nKeyCode:Number):void
		{
			if (nKeyCode != 13)
			{
				this.processKey(String.fromCharCode(nKeyCode));
			}
		}

		/**
		 * keyup event handler
		 * @param char
		 *
		 */
		public function processKey(char:String):void
		{
			if (charManager == null)
			{
				return;
			}
			if (charManager.process(char))
			{
				onKeyDown(char);
			}
		}

		public function unRender():Boolean
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
			this.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
			return false;
		}

		public function remove():Boolean
		{
			return false;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getAllEnteredText():String
		{
			return charManager.allEnteredText;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getAllCorrectText():String
		{
			return charManager.allCorrectText;
		}

		/**
		 *
		 *
		 */
		private function leftKeyHandler():void
		{
			charManager.moveBackward();
		}

		/**
		 *
		 *
		 */
		private function rightKeyHandler():void
		{
			charManager.moveForward();
		}

		public function highlightWrongClips():void
		{
			charManager.highlightWrongClips();
		}

		/**
		 * Check spelling
		 *
		 */
		public function checkSpelling():void
		{
		}

		/**
		 * Finish handler
		 *
		 */
		public function finish():void
		{
		}

		/**
		 * playTypeSound - effect
		 *
		 */
		public function playTypingEffectSound():void
		{
			SoundManager.playEffectSound(SoundManager.SPELL_PRESS);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function useStrictSpelling():Boolean
		{
			return true;
		}

		/**
		 *
		 * @return  getter/setter
		 *
		 */
		public function set onKeyDown(func:Function):void
		{
			this._onKeyDown=func;
		}

		public function get onKeyDown():Function
		{
			return this._onKeyDown;
		}

		public function set onDone(func:Function):void
		{
			this._onDone=func;
		}

		public function get onDone():Function
		{
			return this._onDone;
		}

		public function set onFail(func:Function):void
		{
			this._onFail=func;
		}

		public function get onFail():Function
		{
			return this._onFail;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get charManager():CharClipManager
		{
			return this._char_manger;
		}

		public function set charManager(value:CharClipManager):void
		{
			this._char_manger=value;
		}

		/**
		 *
		 * @return default format
		 *
		 */
		public function get defaultTextFormat():TextFormat
		{
			return null;
		}
	}
}
