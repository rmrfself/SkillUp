package org.enjoytalk.model.helper
{
	import flash.utils.Dictionary;
	
	import org.enjoytalk.model.SessionProxy;
	import org.enjoytalk.model.vo.ItemSession;
	import org.enjoytalk.model.vo.ListStatus;


	public class Progress
	{
		private var _statusProxy:SessionProxy;
		private var _courseProxy:ListStatus ;
		private var _itemsStatus:Dictionary ;
		private var _itemStatus:ItemSession ;

		public function Progress(statusProxy:SessionProxy)
		{
			this._statusProxy=statusProxy;
		}
		
		public function  initilize():void{
			_courseProxy = _statusProxy.status ;
			if(_courseProxy == null){
				_courseProxy = new ListStatus() ;
				if(_courseProxy.itemsStatus == null){
					_courseProxy.itemsStatus = new Dictionary();
				}
			}
		}
		
	}
}