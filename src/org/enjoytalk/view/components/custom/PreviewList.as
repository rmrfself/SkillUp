package org.enjoytalk.view.components.custom
{
	import spark.components.List;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.BitmapAsset;


	public class PreviewList extends List
	{

		[Embed(source="org/enjoytalk/assets/images/pr_item_bg.png")]
		public var rowbgCls:Class;

		public function PreviewList()
		{
			super();
		}

		override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			
		}


		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
		{

		}

		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
		}


		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			var g:Graphics = Sprite(indicator).graphics;
			var imgObj:BitmapAsset = new rowbgCls() as BitmapAsset;
			g.clear();
			g.beginBitmapFill(imgObj.bitmapData, null, false, true);
			g.drawRoundRect(0, 0, this.unscaledWidth, height, 12, 12);
			g.endFill();
			indicator.x = x;
			indicator.y = y;
		}

	}
}