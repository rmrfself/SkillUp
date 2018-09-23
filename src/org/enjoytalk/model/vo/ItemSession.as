/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note: Item Status Vo
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.model.vo
{

	public class ItemSession
	{
		private var _itemId:Number;

		/**
		 * indicates the items phase
		 *
		 * **/
		private var _current_state:String=null;

		/**
		 * flag of completed
		 *
		 * **/
		private var _completed:Boolean=false;

		/**
		 * result
		 *
		 * **/
		private var _result:Boolean=false;


		private var _itemStatus:ItemStatus;

		private var _progress:ItemProgress;

		private var _performance:ItemPerformance;

		public function ItemSession(id:Number)
		{
			this.itemId=id;
		}

		public function get progress():ItemProgress
		{
			if (_progress == null)
			{
				_progress=new ItemProgress(itemStatus.currentState.performance, itemStatus);
			}
			return _progress;
		}

		public function get result():Boolean
		{
			return _result;
		}

		public function set result(value:Boolean):void
		{
			_result=value;
		}

		public function get completed():Boolean
		{
			return _completed;
		}

		public function set completed(value:Boolean):void
		{
			_completed=value;
		}

		public function get isBlocked():Boolean
		{
			return itemStatus.isBlocked;
		}

		public function get itemStatus():ItemStatus
		{
			return _itemStatus;
		}

		public function set itemStatus(value:ItemStatus):void
		{
			_itemStatus=value;
		}

		public function get performance():ItemPerformance
		{
			return _performance;
		}

		public function set performance(value:ItemPerformance):void
		{
			_performance=value;
		}

		/**
		 * Item id
		 *
		 * **/
		public function get itemId():Number
		{
			return _itemId;
		}

		/**
		 * @private
		 */
		public function set itemId(value:Number):void
		{
			_itemId=value;
		}


	}
}
