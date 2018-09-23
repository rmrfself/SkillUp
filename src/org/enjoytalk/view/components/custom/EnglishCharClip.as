/**
* English charclip holder
* Code by enjoytalk
*
*/
package org.enjoytalk.view.components.custom
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	 
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.effects.Sequence;
	import mx.effects.Tween;
	import mx.effects.easing.Elastic;

	import spark.effects.animation.Animation;

	public class EnglishCharClip extends CharClip
	{
		protected var _isTweening:Boolean=false;
		protected var moveSeq:Sequence=new Sequence();
		protected var moveUpEffect:Move=new Move();
		protected var moveDownEffect:Move=new Move();

		protected var _animateBasePos:Number=0;

		/**
		 * fontSize set
		 * fontName embed
		 *
		 */
		public function EnglishCharClip()
		{
			super();
			_mcLine=new MovieClip();
			_mcLine.visible=false;
			_cursor=new MovieClip();
			_cursor.visible=false;
		}


		public function setBreakCount(num:Number):void
		{
			breakCount=num;
		}


		override public function set isSpell(value:Boolean):void
		{
			_mcLine.visible=value;
			super.isSpell=value;
		}

		override public function setIsSpell(value:Boolean):void
		{
			isSpell=value;
		}

		override public function unRender():void
		{
			next=null;
			previous=null;
			this.removeChild(this.txtChar);
		}

		/**
		 *
		 * @param nWd
		 * @param nHt
		 *
		 */
		override public function setSize(nWd:Number, nHt:Number):void
		{
			super.setSize(nWd, nHt);
			txtChar.width=nWd;
			txtChar.height=nHt;
			this.width=nWd;
			this.height=nHt;
			this.setIsKeyword(isKeyword);
			this.initCursor(nWd, nHt);
		}

		override public function setPos(xp:Number, yp:Number):void
		{
			this.x=xp;
			this.y=yp;
		}

		/**
		 *
		 * @return
		 *
		 */
		override public function get isWrongAnswer():Boolean
		{
			return char.toLowerCase() == this.correctChar.toLowerCase();
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isHightlighted():Boolean
		{
			return this._cursor.visible;
		}

		/**
		 *
		 * @param fontColor
		 *
		 */
		override public function setCustomColor(fontColor:Number):void
		{
			_fontColor=CLR_NOSPELL=CLR_SPELL=CLR_KEYWORD=fontColor;
			txtChar.setTextFormat(new TextFormat(_fontName, _fontSize, fontColor));
		}

		/**
		 * setNormal color . refered by quiz
		 *
		 */
		override public function setNormalColor(fontColor:Number=0xFFFFFF):void
		{
			var color:Number=CLR_NOSPELL;
			if (isKeyword)
			{
				color=CLR_KEYWORD;
			}
			else if (isSpell)
			{
				color=CLR_SPELL;
			}
			_cursor.visible=false;
			var normalFormat:TextFormat=new TextFormat(_fontName, _fontSize, color);
			normalFormat.align=TextFormatAlign.CENTER;
			txtChar.setTextFormat(normalFormat);
			isShowingWrongLetter=false;
		}

		/**
		 *
		 * @param color
		 *
		 */
		override public function setWrongColor():void
		{
			txtChar.setTextFormat(new TextFormat(_fontName, _fontSize, CLR_WRONG));
			_cursor.visible=true;
			isShowingWrongLetter=true;
		}

		/**
		 *
		 * @param sChar
		 *
		 */
		override public function setChar(sChar:String):void
		{
			char=sChar;
			if (char.toLowerCase() == correctChar.toLowerCase())
			{
				char=correctChar;
			}
			txtChar.text=char;
			var newFormat:TextFormat=new TextFormat(_fontName, _fontSize, _fontColor);
			newFormat.align=TextFormatAlign.CENTER;
			txtChar.setTextFormat(newFormat);
		}

		override public function setCorrectChar(sChar:String):void
		{
			correctChar=sChar;
			txtChar.text=sChar;
		}

		override public function showCorrectChar():void
		{
			txtChar.text=correctChar;
		}

		public function clearChar():void
		{
			this.setChar(" ");
		}

		public function get isHighlighted():Boolean
		{
			return _cursor.visible;
		}

		/**
		 *
		 * @param doHighlight
		 *
		 */
		override public function highlight(doHighlight:Boolean):void
		{
			_cursor.visible=doHighlight != false;
		}

		/**
		 *
		 * @param nWd
		 * @param lineColor
		 *
		 */
		override public function initMcLine(nWd:Number, lineColor:Number):void
		{
			_mcLine.graphics.lineStyle(1, this._fontColor);
			_mcLine.graphics.moveTo(0, 0);
			_mcLine.graphics.lineTo(0, 0);
			_mcLine.graphics.lineTo(nWd, 0);
			_mcLine.y=this.height + CharClip.CHAR_MGN;
			_animateBasePos=_mcLine.y;
			addChild(_mcLine);
		}

		public function drawMcLine(nWd:Number, lineColor:Number=0xFFFFFF):void
		{
			this.initMcLine(nWd, lineColor);
		}

		/**
		 *
		 * @param nWd
		 * @param nHt
		 *
		 */
		override public function initCursor(nWd:Number, nHt:Number):void
		{
			_cursor.graphics.clear();
			_cursor.graphics.beginFill(CLR_CURSOR);
			_cursor.graphics.drawRect(0, 0, nWd, nHt);
			_cursor.graphics.endFill();
			_cursor.name="cursor";
			addChild(_cursor);
			swapChildren(this.txtChar, _cursor);
			_cursor.visible=false;
		}

		override public function animateBackspace():void
		{
			this.animateScore(-10, 300, 500);
		}

		public function animateShowLine(callback:Function=null):void
		{
			this.animateAlpha(0, 100, callback);
		}

		override public function animateHideLine():void
		{
			this.animateAlpha(100, 0, null);
		}

		public function animateAlpha(startAlpha:Number, endAlpha:Number, callback:Function):void
		{
			if (!_isTweening)
			{
				var fadeEffect:Fade=new Fade(_mcLine);
				fadeEffect.alphaFrom=startAlpha;
				fadeEffect.alphaTo=endAlpha;
				fadeEffect.duration=300;
				fadeEffect.play();
			}
			else
			{
				this.hideLine();
				if (callback != null)
				{
					callback();
				}
			}
		}

		override public function animateEnter():void
		{
			this.animateScore(15, 200, 500);
		}

		public function animateScore(yOffset:Number, nSpeed1:Number, nSpeed2:Number):void
		{

			var startY:Number=_animateBasePos;
			if (_isTweening)
			{
				return;
			}
			_isTweening=true;
			function tweenerOne():void
			{
				_isTweening=true;
				var _downTweener:Tween=new Tween(_mcLine, 0, 0, nSpeed1, 24, downBeginFunction, downEndFunction);
				_downTweener.easingFunction=Elastic.easeInOut;
				function downBeginFunction():void
				{
					_mcLine.y=startY;
				};
				function downEndFunction():void
				{
					_mcLine.y=startY + yOffset;
					tweenerNext();
				};
			}
			function tweenerNext():void
			{
				var _upTweener:Tween=new Tween(_mcLine, 0, 0, nSpeed2, 24, upBeginFunction, upEndFunction);
				_upTweener.easingFunction=Elastic.easeInOut;
				function upBeginFunction():void
				{
					_mcLine.y=startY + yOffset;
				};
				function upEndFunction():void
				{
					_mcLine.y=startY;
					_isTweening=false;
				};
			}
			tweenerOne();
		}

		public function animateFinished():void
		{
			_isTweening=false;
		}
	}
}
