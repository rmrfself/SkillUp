/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.view.components.custom
{
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;

	import mx.core.EdgeMetrics;
	import mx.skins.halo.HaloBorder;
	import mx.utils.GraphicsUtil;

	public class CustomBorder extends HaloBorder
	{
		private var topCornerRadius:Number;
		private var bottomCornerRadius:Number;

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			topCornerRadius=getStyle("cornerRadius") as Number;

			if (!topCornerRadius)
			{
				topCornerRadius=0;
			}

			bottomCornerRadius=getStyle("bottomCornerRadius") as Number;

			if (!bottomCornerRadius)
			{
				bottomCornerRadius=0;
			}

			var g:Graphics=graphics;
			var b:EdgeMetrics=borderMetrics;
			var w:Number=unscaledWidth - b.left - b.right;
			var h:Number=unscaledHeight - b.top - b.bottom;

			var bgColor:int=getStyle("backgroundColor");
			if (!bgColor)
			{
				bgColor=0xFFFFFF;
			}
			var bgAlpha:Number=getStyle("backgroundAlpha");
			if (!bgAlpha)
			{
				bgAlpha=1;
			}
			
			g.beginFill(bgColor, bgAlpha);
			g.lineStyle(1,0x12A6E9);
			drawRoundRect(0,0,unscaledWidth,unscaledHeight-1,{tl:topCornerRadius,tr:topCornerRadius,bl:0,br:0},0xFFFFFF ,0.1);
			g.endFill();
		}

	}
}