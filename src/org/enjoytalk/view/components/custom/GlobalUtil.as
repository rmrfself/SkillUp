package org.enjoytalk.view.components.custom
{
	import flash.system.Security;
	import flash.system.System;

	public class GlobalUtil
	{
		public static function extendEnvironment():void
		{
			ExtendedArray.extendPrototype();
			ExtendedString.extendPrototype();
			ExtendedObject.extendPrototype();
			ExtendedNumber.extendPrototype();
			allowDomain();
		}

		public static function allowDomain():void
		{
			Security.allowDomain("study.f7tao.com", "*.f7tao.com", "asset1.f7tao.com", "asset3.f7tao.com", "asset2.f7tao.com", "asset0.f7tao.com");
		}
	}
}

