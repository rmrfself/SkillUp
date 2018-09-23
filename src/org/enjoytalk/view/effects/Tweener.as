package org.enjoytalk.view.effects
{
	import spark.effects.Move;

	public class Tweener
	{
		private var _target:Object;

		public function Tweener(target:Object)
		{
			this._target=target;
		}

		public function tweenTo(propNames:String, startValues:Number, endValues:Number, msecs:Number=-1, callback:Function=null, transitionType:Function=null):void
		{
			if (msecs == -1)
			{
				for (var _loc2=0; _loc2 < propNames.length; ++_loc2)
				{
					target[propNames[_loc2]]=endValues[_loc2];
				} // end of for
				callback();
				return;
			} // end if
			if (transitionType == undefined)
			{
				transitionType=common.visual.Tweener.strongIn;
			} // end if
			var _loc5=new mx.transitions.TweenExtended(target, propNames, transitionType, startValues, endValues, msecs / 1000, true);
			if (tweens == undefined)
			{
				tweens=[];
			} // end if
			var tweenName=String(getTimer());
			tweens[tweenName]=_loc5;
			_loc5.onMotionFinished=this.proxy(function()
			{
				delete tweens[tweenName];
				callback();
			});
		} // End of the function


	}
}
