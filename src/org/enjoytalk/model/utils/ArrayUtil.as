package org.enjoytalk.model.utils
{
	import org.enjoytalk.model.vo.Item;
	import org.enjoytalk.model.vo.ItemSession;

	public class ArrayUtil
	{
		public static function sortOnPhase(arr:Array):Array
		{
			return arr.sort(comparePhase);
		}

		private static function comparePhase(a:Item, b:Item):int
		{
			var c:ItemSession=a.session;
			var d:ItemSession=b.session;

			if (c.phase < d.phase)
			{
				return 1;
			}
			else if (c.phase > d.phase)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

	}
}