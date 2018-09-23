/**
* String utils
 *
*/
package org.enjoytalk.view.components.custom
{
    import mx.utils.StringUtil;

    public class StringTools
    {
        public static function trimInTaggedWord(word:String, tag:String, startIndex:Number):String
        {
            if (tag == null)
            {
                tag = "b";
            }
            if (!(startIndex is Number))
            {
                startIndex = 0;
            }
            var head_index:Number = word.indexOf("<" + tag + ">", startIndex);
            var end_index:Number = word.indexOf("</" + tag + ">", startIndex);
            if (head_index <= -1 || end_index <= -1 || startIndex >= word.length)
            {
                return (word);
            }
            else
            {
                word = StringUtil.trim(word.substring(0, head_index + tag.length + 2) + word.substring(head_index + tag.length + 2, end_index)) + word.substring(end_index);
                return trimInTaggedWord(word, tag, word.indexOf("</" + tag + ">", startIndex) + tag.length + 3);
            }
        }

        public static function setBoldTag(text:String, value:String):String
        {
            var index:Number = text.indexOf(value);
            if (index < 0 || value == "")
            {
                return (text);
            }
            var next_index:Number = index + value.length;
            return (text.substring(0, index) + "<b>" + text.substring(index, next_index) + "</b>" + text.substring(next_index));
        }

        public static function getBoldPositions(text:String):Array
        {
            var positions:Array = [];
            var index_b:Number = text.indexOf("<b>");
            var index_current:Number;
            while (index_b > -1)
            {
                text = text.substring(0, index_b) + text.substring(index_b + 3);
                index_current = text.indexOf("</b>", index_b);
                if (index_current > 0)
                {
                    positions.push({ startPos: index_b, endPos: index_current });
                    text = text.substring(0, index_current) + text.substring(index_current + 4);
                }
                index_current = text.indexOf("<b>", index_current);
            } // end while
            return (positions);
        }

        public static function hasTag(src:String, tag:String):Boolean
        {
            return (src.indexOf("<" + tag + ">") > -1 && src.indexOf("</" + tag + ">") > -1);
        }

        public static function getTagedString(text:String, tag:String):String
        {
            return "";
        }

        public static function convertBRTagToCR(src:String):String
        {
            var tags:Array = [ "<br>", "<BR>", "<br />", "<BR />" ];
            for (var k:Number = 0; k < tags.length; ++k)
            {
                src = String(src).split(tags[k]).join("\n");
            }
            return (src);
        }

        public static function parseTags(text:String, tag:String):Array
        {
            return [];
        }

        public static function removeBadCharacters(txt:String):String
        {
            var dash_all:Array = [ "~", "～" ];
            var text:String = txt;
            for (var k:Number = 0; k < dash_all.length; k++)
            {
                text = text.split(dash_all[k]).join(" ");
            }
            return (text);
        }

        public static function getNestedStrings(tag:String, str:String):String
        {
            return "";
        }

        public static function isAllAscii(text:String, exceptions:Array):Boolean
        {
            for (var k:Number = 0; k < text.length; k++)
            {
                var char:Number = text.charCodeAt(k);
                if (char <= 31 || char >= 127)
                {
                    if (exceptions.indexOf(char) == -1)
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        public static function isEnglish(text:String):Boolean
        {
            return (isAllAscii(text, [ "～", "。", "…", "’", "－", "　", "\n" ]));
        }

        public static function isAllKana(text:String):Boolean
        {
            for (var k:Number = 0; k < text.length; k++)
            {
                var char:String = text.charAt(k);
                if (!isHiragana(char) && !isZenkakuKatakana(char) && [ "～", "。", "…", "’", "－", "　", "\n", " " ].indexOf(char) == -1)
                {
                    return false;
                }
            }
            return true;
        }

        public static function isKanji(char:String):Boolean
        {
            return (!isHiragana(char) && !isEnglish(char) && !isZenkakuKatakana(char));
        }

        public static function isHiragana(char:String):Boolean
        {
            var char_code:Number = char.charCodeAt(0);
            return (Boolean(char_code >= 12353 && char_code <= 12436));
        }

        public static function isZenkakuKatakana(char:String):Boolean
        {
            var char_code:Number = char.charCodeAt(0);
            return (Boolean(char_code >= 12449 && char_code <= 12531 || char_code == 12540));
        }

        public static function changeZenkakuKatakanaFromHiragana(char:String):String
        {
            return (String.fromCharCode(char.charCodeAt(0) + 96));
        }

        public static function pad(text:String, size:Number, char:String  =  null):String
        {
            text = text == null ? ("") : (text.toString());
            if (char == null)
            {
                char = " ";
            }
            while (text.length < size)
            {
                text = char + text;
            }
            return (text);
        }

        public static var HIRAGANA:String = "あいうえおかきくけこさしすせそたちつってとなにぬねのはひふへほまみむめもやゆよらりるれろわぁぃぅぇぉをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゃゅょゎゑゐゔ";

        public static var KATAGANA:String = "アイウエオカキクケコサシスセソタチツッテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンァィゥェォガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポャュョー";

        public static var IGNORED_CHARA:String = " ()!?#$%&\'=-~^|[]{}*\"+/\\;,.:<>@`_　、。・￥「」：；ｌ＠ﾞﾟ？！゛゜´｀¨＾－￣＿￡＃＆’";

        public static var NUMERALS:String = "0123456789";
    }
}