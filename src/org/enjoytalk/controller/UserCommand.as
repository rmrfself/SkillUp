package org.enjoytalk.controller
{
	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.*;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class UserCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var user_proxy:UserProxy;
			switch (notification.getName())
			{
				case ApplicationFacade.STARTUP:
					facade.registerProxy(new UserProxy());
					break;
			}
		}
	}
}
