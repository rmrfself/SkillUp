package org.enjoytalk.view.components.custom
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.effects.Tween;
	import mx.effects.easing.Elastic;

	public class CharClip extends MovieClip
	{
		protected var _index:Number=0;

		protected var _txtChar:TextField=null;

		protected var _char:String=" ";

		protected var _mcLine:MovieClip;

		protected var _cursor:MovieClip;

		protected var _text:String;

		protected var _correct_char:String=" ";

		protected var _break_count:Number=0;

		protected var _fontName:String=null;

		protected var _fontSize:Number=20;

		protected var _fontColor:Number=0xFFFFFF;

		protected var _textFormat:TextFormat;

		private var _next:CharClip;

		private var _previous:CharClip;

		public var CLR_NOSPELL:Number=16777215;

		public var CLR_SPELL:Number=16777215;

		public var CLR_KEYWORD:Number=0;

		public var CLR_WRONG:Number=16711680;

		public var CLR_WRONG_BG:Number=15724527;

		public var CLR_CURSOR:Number=14540253;

		public static var CHAR_MGN:Number=1;

		protected var _is_correct:Boolean=false;

		private var _isWrongAnswer:Boolean;

		protected var _is_spell:Boolean=false;

		protected var _is_keyword:Boolean=false;

		protected var _selected:Boolean=false;

		public var isShowingWrongLetter:Boolean=false;

		public function CharClip()
		{
			super();
			_txtChar=new TextField();
			addChildAt(_txtChar, 0);
		}

		public function validate(value:*, defaultValue:*):*
		{
			return (value == null ? (defaultValue) : (value));
		}

		public function setPos(xp:Number, yp:Number):void
		{
			this.x=xp;
			this.y=yp;
		}

		public function unRender():void
		{
		}

		/**
		 *
		 * @param fontSize
		 *
		 */
		public function setFontSize(fontSize:Number):void
		{
			_fontSize=fontSize;
			_fontName=this.validate(LanguageCodeManager.getInstance().getCueFontName(), "_sans");
		}

		/**
		 *
		 * @param color
		 *
		 */
		public function setCustomColor(color:Number):void
		{
			this._fontColor=color;
		}

		/**
		 *
		 * @param color
		 *
		 */
		public function setWrongColor():void
		{
		}

		/**
		 * normal color;
		 *
		 */
		public function setNormalColor(fontColor:Number=0xFFFFFF):void
		{
			return;
		}

		public function showChar():void
		{
			return;
		}

		public function animateBackspace():void
		{
		}

		public function animateEnter():void
		{
		}

		public function animateHideLine():void
		{
		}

		public function pause():void
		{
		}

		/**
		 *
		 * @param nWd
		 * @param nHt
		 *
		 */
		public function setSize(nWd:Number, nHt:Number):void
		{
			return;
		}

		/**
		 *
		 * @param doHightLight
		 *
		 */
		public function highlight(doHightLight:Boolean):void
		{
			return;
		}

		/**
		 * nothing but show the correct answer;
		 *
		 */
		public function showCorrectChar():void
		{
			return;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function setCorrectChar(char:String):void
		{
			this.correctChar=char;
			txtChar.text=char;
		}

		public function getTextField():TextField
		{
			return txtChar;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isBlank():Boolean
		{
			return this.txtChar.text == " ";
		}

		public function hideLine():void
		{
			_mcLine.visible=false;
		}


		public function getCorrectChar():String
		{
			return this.correctChar;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isSpace():Boolean
		{
			return this.correctChar == " ";
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getCharWidth():Number
		{
			return (txtChar.textWidth);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getCharHeight():Number
		{
			return txtChar.textHeight;
		}

		public function setIsSpell(value:Boolean):void
		{
			this._is_spell=value;
		}

		public function initCursor(nWd:Number, nHt:Number):void
		{
		}

		public function initMcLine(nWd:Number, nHt:Number):void
		{
		}

		/**
		 *
		 * @return getter / setter  s;
		 *
		 */
		public function get index():Number
		{
			return _index;
		}

		public function set index(value:Number):void
		{
			this._index=value;
		}

		/**
		 *
		 * @return txtChar
		 *
		 */
		public function get txtChar():TextField
		{
			return _txtChar;
		}

		public function set txtChar(value:TextField):void
		{
			this._txtChar=value;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getChar():String
		{
			return _char;
		}

		public function setChar(c:String):void
		{
			_char=c;
		}

		public function get char():String
		{
			return _char;
		}

		public function set char(c:String):void
		{
			_char=c;
		}


		/**
		 *
		 * @return
		 *
		 */
		public function get text():String
		{
			return _txtChar.text;
		}

		public function set text(value:String):void
		{
			_txtChar.text=value;
		}



		public function get fontName():String
		{
			return _fontName;
		}

		public function set fontName(value:String):void
		{
			this._fontName=value;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set correctChar(value:String):void
		{
			this._correct_char=value;
		}

		public function get correctChar():String
		{
			return this._correct_char;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get isCorrect():Boolean
		{
			return this._is_correct;
		}

		public function set isCorrect(value:Boolean):void
		{
			this._is_correct=false;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get isSpell():Boolean
		{
			return this._is_spell;
		}

		public function set isSpell(value:Boolean):void
		{
			this._is_spell=value;
		}

		public function set isKeyword(value:Boolean):void
		{
			this._is_keyword=value;
		}

		public function get isKeyword():Boolean
		{
			return _is_keyword;
		}

		public function setIsKeyword(value:Boolean):void
		{
			_is_keyword=value;
		}

		public function get selected():Boolean
		{
			return this._selected;
		}

		public function set selected(value:Boolean):void
		{
			this._selected=value;
		}

		public function get breakCount():Number
		{
			return _break_count;
		}

		public function set breakCount(value:Number):void
		{
			_break_count+=value;
		}

		public function get isWrongAnswer():Boolean
		{
			return _isWrongAnswer;
		}

		public function set isWrongAnswer(value:Boolean):void
		{
			_isWrongAnswer=value;
		}

		public function get previous():CharClip
		{
			return _previous;
		}

		public function set previous(value:CharClip):void
		{
			_previous=value;
		}

		public function get next():CharClip
		{
			return _next;
		}

		public function set next(value:CharClip):void
		{
			_next=value;
		}

		public function proxy(callback:Function):*
		{
			callback();
		}
	}
}
