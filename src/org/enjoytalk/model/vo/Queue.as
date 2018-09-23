/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Queue data structure for  study targets
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/

package org.enjoytalk.model.vo
{

	public dynamic class Queue extends Array
	{
		private var index:Number=0;

		public function Queue():void
		{
			super();
		}

		public function empty():Boolean
		{
			return length == 0 ? true : false;
		}

		public function remove(obj:*):*
		{
			var item:*;
			var c_index:Number=indexOf(obj);
			if (c_index > -1)
			{
				item=super.splice(c_index, 1)[0];
			}
			return item;
		}

		public function next():*
		{
			if (this.index > super.length - 1)
			{
				index=0;
			}
			return this[index++];
		}
	}
}
