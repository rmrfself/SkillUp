package org.enjoytalk.model.utils
{

    public class Tools
    {
        public function Tools()
        {
        }

        public static function randRange(min:Number, max:Number):Number
        {
            return (Math.round(Math.random() * (max - min)) + min);
        }

        public static function omitDecimals(ori:Number, digit:Number):Number
        {
            if (!(digit is Number))
            {
                digit = 0;
            }
            var cal:Number = Math.pow(10, digit);
            return (Math.round(ori * cal) / cal);
        }


        public static function validate(value:Object, defaultValue:Object):Object
        {
            return (value == null ? (defaultValue) : (value));
        }
    }
}