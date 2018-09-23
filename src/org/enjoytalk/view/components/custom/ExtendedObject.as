package org.enjoytalk.view.components.custom
{

	public class ExtendedObject
	{

		public function ExtendedObject()
		{
		}

		public static function extendPrototype():void
		{
			Object.prototype.proxy=function(f:*):*
			{
				var capturedThis:*=this;
				var delegatedArguments:*=arguments.slice(1);
				return (function():*
				{
					return (f.apply(capturedThis, delegatedArguments.concat(arguments)));
				});
			};
			Object.prototype.setPropertyIsEnumerable('proxy', false);

			Object.prototype.setDefinedValues=function(valueNames:*, values:*, defValues:*):*
			{
				for (var k:Number=0; k < valueNames.length; k++)
				{
					if (values[k] != null)
					{
						valueNames[k]=values[k];
						continue;
					}
					if (defValues != null)
					{
						valueNames[k]=defValues[k];
					}
				}
				return this;
			};
			Object.prototype.setPropertyIsEnumerable('setDefinedValues', false);

			Object.prototype.validate=function(value:*, defaultValue:*):*
			{
				return (value == null ? (defaultValue) : (value));
			};
			Object.prototype.setPropertyIsEnumerable('validate', false);

		}
	}
}
