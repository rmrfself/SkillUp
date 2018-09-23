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
	import org.puremvc.as3.patterns.command.MacroCommand;
	public class ApplicationStartupCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(UserCommand);
			addSubCommand(CourseCommand);
			addSubCommand(SequenceCommand);
		}
	}
}