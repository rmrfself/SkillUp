package org.enjoytalk.model.vo
{

	public class AbstractData
	{
		protected function validate(value:*, defaultValue:*):*
		{
			return value == null ? defaultValue : value;
		}
	}
}
