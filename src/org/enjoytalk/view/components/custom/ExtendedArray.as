package org.enjoytalk.view.components.custom
{

	public class ExtendedArray
	{

		public static function extendPrototype():void
		{
			Array.prototype.each=function(f:*):Array
			{
				for (var k:Number=0; k < length; k++)
				{
					f(this[k]);
				}
				return (this);
			};
			Array.prototype.setPropertyIsEnumerable('each', false);
			Array.prototype.find=function(f:*):*
			{
				for (var k:Number=0; k < length; k++)
				{
					if (f(this[k]))
					{
						return (this[k]);
					}
				}
				return null;
			};
			Array.prototype.setPropertyIsEnumerable('find', false);
			Array.prototype.select=function(f:*):Array
			{
				var tmp:Array=[];
				for (var k:Number=0; k < length; k++)
				{
					if (f(this[k]))
					{
						tmp.push(this[k]);
					}
				}
				return tmp;
			};
			Array.prototype.setPropertyIsEnumerable('select', false);
			Array.prototype.collect=function(f:*):Array
			{
				var ret:Array=[];
				for each (var it:* in this)
					ret.push(f(it));
				return ret;
			};
			Array.prototype.setPropertyIsEnumerable('collect', false);
			Array.prototype.inject=function(memo:*, f:*):*
			{
				for (var k:Number=0; k < length; k++)
				{
					memo=f(memo, this[k]);
				}
				return memo;
			};
			Array.prototype.setPropertyIsEnumerable('inject', false);
			Array.prototype.randomize=function():*
			{
				var tmp:Array=this.collect(function(el:*):*
				{
					var obj:Object=new Object();
					obj.key=Math.random();
					obj.value=el;
					return (obj);
				});
				tmp=tmp.sortOn("key", Array.NUMERIC);
				return (tmp.collect(function(container:*):*
				{
					return container.value;
				}));
			};
			Array.prototype.setPropertyIsEnumerable('randomize', false);
			Array.prototype.addUnique=function(value:*):Array
			{
				for (var k:Number=0; k < length; k++)
				{
					if (this[k] == value)
					{
						return (this);
					}
				}
				this.push(value);
				return this;
			};
			Array.prototype.setPropertyIsEnumerable('addUnique', false);
			Array.prototype.hasValue=function(value:*):Number
			{
				for (var k:Number=0; k < length; k++)
				{
					if (this[k] == value && typeof(this[k]) == typeof(value))
					{
						return k;
					}
				}
				return -1;
			};
			Array.prototype.setPropertyIsEnumerable('hasValue', false);
			Array.prototype.random=function():Number
			{
				return (this[int(Math.random() * (length - 1.000000E-003))]);
			};
			Array.prototype.setPropertyIsEnumerable('random', false);

			Array.prototype.collectProp=function(propName:String):Array
			{
				var tmp:Array=[];
				for (var k:Number=0; k < length; k++)
				{
					tmp.push(this[k][propName]);
				}
				return tmp;
			};
			Array.prototype.setPropertyIsEnumerable('collectProp', false);

			Array.prototype.selectByPropValue=function(propName:*, selectValue:*):Array
			{
				var tmp:Array=[];
				if (selectValue == null)
				{
					return tmp;
				}
				for (var k:Number=0; k < length; k++)
				{
					if (this[k][propName] == null)
					{
						return tmp;
					}
					if (this[k][propName] == selectValue)
					{
						tmp.push(this[k]);
					}
				}
				return tmp;
			};
			Array.prototype.setPropertyIsEnumerable('selectByPropValue', false);

			Array.prototype.sumProp=function(propName:String):Number
			{
				var tmp:Number=0;
				for (var k:Number=0; k < length; k++)
				{
					if (this[k][propName] != undefined)
					{
						tmp=tmp + this[k][propName];
					}
				}
				return tmp;
			};
			Array.prototype.setPropertyIsEnumerable('sumProp', false);

			Array.prototype.sumOf=function(getter:*):Number
			{
				var tmp:Number=0;
				for (var k:Number=0; k < length; k++)
				{
					var re:Number=getter(this[k]);
					if (!isNaN(re))
					{
						tmp=tmp + re;
					}
				}
				return tmp;
			};
			Array.prototype.setPropertyIsEnumerable('sumOf', false);

			Array.prototype.applyEach=function(methodName:Array):Array
			{
				var tmp:Array=arguments.slice(1);
				for (var k:Number=0; k < length; k++)
				{
					this[k][methodName].apply(this[k], tmp);
				}
				return this;
			};
			Array.prototype.setPropertyIsEnumerable('applyEach', false);


			Array.prototype.applyRange=function(methodName:String, start:Number, end:Number):Array
			{
				var tmp:Array=arguments.slice(3);
				var re:Array=[];
				for (var k:Number=0; k < length; k++)
				{
					this[k][methodName].apply(this[k], tmp);
					re.push(this[k]);
				}
				return re;
			};
			Array.prototype.setPropertyIsEnumerable('applyRange', false);


			Array.prototype.setPropValues=function(... arguments):Array
			{
				var halfArgsLen:Number=arguments.length / 2;
				var topHalfData:Array=arguments.slice(0, halfArgsLen);
				var bottomHalfData:Array=arguments.slice(halfArgsLen, arguments.length);
				for (var j:Number=0; j < length; j++)
				{
					for (var k:Number=0; k < halfArgsLen; k++)
					{
						this[j][topHalfData[k]]=bottomHalfData[k];
					}
				}
				return this;
			};
			Array.prototype.setPropertyIsEnumerable('setPropValues', false);
		}
	}
}
