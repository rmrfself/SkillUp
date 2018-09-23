/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.controller
{
	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.*;
	import org.enjoytalk.view.ApplicationMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class CourseCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var courseProxy:CourseProxy;
			var sequenceProxy:SequenceProxy;
			switch (notification.getName())
			{
				/**
				* On start up
				*
				*/
				case ApplicationFacade.STARTUP:
					facade.registerProxy(new CourseProxy());
					break;
			}
		}
	}
}
