/*
   作者：
   张庆华
   邮箱：
   xanderzhang@live.com
   标注：
   		字典类的 key 和 value 操作类
 */

package org.enjoytalk.model.utils
{
	import flash.utils.Dictionary;
	public class DictionaryUtil
	{
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array=new Array();

			for (var key:Object in d)
			{
				a.push(key);
			}
			return a;
		}

		public static function getValues(d:Dictionary, count:int):Array
		{
			var a:Array=new Array();
			var i:int=0;
			for (var key:Object in d)
			{
				a.push(d[key]);
				if (count > 0)
				{
					if (i == count - 1)
					{
						break;
					}
				}
				i++;
			}
			return a;
		}
	}
}