package org.enjoytalk.controller
{
	import org.enjoytalk.ApplicationFacade;
	import org.enjoytalk.model.*;
	import org.enjoytalk.view.ApplicationMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SequenceCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var app:SkillUp=notification.getBody() as SkillUp;
			var sequenceProxy:SequenceProxy;
			switch (notification.getName())
			{
				case ApplicationFacade.STARTUP:
					facade.registerProxy(new SequenceProxy());
					facade.registerMediator(new ApplicationMediator(notification.getBody() as SkillUp));
					break;
				case ApplicationFacade.DO_SEQUENCE:
					sequenceProxy=facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
					sequenceProxy.doSequence();
					break;
			}
		}
	}
}
