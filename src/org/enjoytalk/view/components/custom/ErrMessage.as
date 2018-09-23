package org.enjoytalk.view.components.custom
{
	import flash.events.Event;

	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	public class ErrMessage extends UIComponent
	{
		public static var _instance:ErrMessage;

		private var _parentContainer:UIComponent;

		private static var _messageWindow:MessageWindow;

		public static const CLOSE_POPWIN:String="closePopWin";

		public static var ERR_COMMIT_SESSION:String="学习数据提交失败，请稍候再试，或者点右上角“反馈”按钮，反馈信息给我们。";

		public function ErrMessage()
		{
			super();
		}


		public static function getInstance():ErrMessage
		{
			if (_instance == null)
			{
				_instance=new ErrMessage();
			}
			return _instance;
		}

		public function setParentContainer(app:UIComponent):void
		{
			_parentContainer=app;
		}


		public function showErrorMessage(msg:String=null, showTitle:Boolean=false, title:String=""):void
		{
			if (msg == null)
				return;
			_messageWindow=new MessageWindow();
			PopUpManager.addPopUp(_messageWindow, _parentContainer);
			PopUpManager.centerPopUp(_messageWindow);
			_messageWindow.setMessage(msg);
			_messageWindow.addEventListener(CLOSE_POPWIN, removeMessageWindow);
		}

		private function removeMessageWindow(event:Event):void
		{
			PopUpManager.removePopUp(_messageWindow);
		}
	}
}
