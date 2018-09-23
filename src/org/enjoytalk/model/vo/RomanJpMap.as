/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/
package org.enjoytalk.model.vo
{
	import flash.utils.Dictionary;

	public class RomanJpMap
	{
		public static var maps:Dictionary;

		public static function getInstance():Dictionary
		{
			if (maps)
			{
				return maps;
			}
			else
			{
				maps=new Dictionary();
				maps["a"]="あ";
				maps["i"]="い";
				maps["u"]="う";
				maps["e"]="え";
				maps["o"]="お";
				maps["ka"]="か";
				maps["ki"]="き";
				maps["ku"]="く";
				maps["ke"]="け";
				maps["ko"]="こ";
				maps["sa"]="さ";
				maps["shi"]="し";
				maps["su"]="す";
				maps["se"]="せ";
				maps["so"]="そ";
				maps["ta"]="た";
				maps["chi"]="ち";
				maps["tsu"]="つ";
				maps["te"]="て";
				maps["to"]="と";
				maps["na"]="な";
				maps["ni"]="に";
				maps["nu"]="ぬ";
				maps["ne"]="ね";
				maps["no"]="の";
				maps["ha"]="は";
				maps["hi"]="ひ";
				maps["fu"]="ふ";
				maps["he"]="へ";
				maps["ho"]="ほ";
				maps["ma"]="ま";
				maps["mi"]="み";
				maps["mu"]="む";
				maps["me"]="め";
				maps["mo"]="も";
				maps["ya"]="や";
				maps["i"]="い";
				maps["yu"]="ゆ";
				maps["e"]="え";
				maps["yo"]="よ";
				maps["ra"]="ら";
				maps["ri"]="り";
				maps["ru"]="る";
				maps["re"]="れ";
				maps["ro"]="ろ";
				maps["wa"]="わ";
				maps["wo"]="を";

				maps["ga"]="が";
				maps["gi"]="ぎ";
				maps["gu"]="ぐ";
				maps["ge"]="げ";
				maps["go"]="ご";

				maps["za"]="ざ";
				maps["ji"]="じ";
				maps["zu"]="ず";
				maps["ze"]="ぜ";
				maps["zo"]="ぞ";

				maps["da"]="だ";
				maps["ji"]="じ";
				maps["zu"]="ず";
				maps["de"]="で";
				maps["do"]="ど";

				maps["ba"]="ば";
				maps["bi"]="び";
				maps["bu"]="ぶ";
				maps["be"]="べ";
				maps["bo"]="ぼ";

				maps["pa"]="ぱ";
				maps["pi"]="ぴ";
				maps["pu"]="ぷ";
				maps["pe"]="ぺ";
				maps["po"]="ぽ";

				maps["kya"]="きゃ";
				maps["kyu"]="きゅ";
				maps["kyo"]="きょ";

				maps["sha"]="しゃ";
				maps["shu"]="しゅ";
				maps["sho"]="しょ";

				maps["cha"]="ちゃ";
				maps["chu"]="ちゅ";
				maps["cho"]="ちょ";

				maps["nya"]="にゃ";
				maps["nyu"]="にゅ";
				maps["nyo"]="にょ";
				maps["hya"]="ひゃ";

				maps["hyu"]="ひゅ";
				maps["hyo"]="ひょ";
				maps["mya"]="みゃ";
				maps["myu"]="みゅ";
				maps["myo"]="みょ";

				maps["rya"]="りゃ";
				maps["ryu"]="りゅ";
				maps["ryo"]="りょ";
				maps["gya"]="ぎゃ";
				maps["gyu"]="ぎゅ";
				maps["gyo"]="ぎょ";

				maps["ja"]="じゃ";
				maps["ju"]="じゅ";
				maps["jo"]="じょ";

				maps["bya"]="びゃ";
				maps["byu"]="びゅ";
				maps["byo"]="びょ";

				maps["pya"]="ぴゃ";
				maps["pyu"]="ぴゅ";
				maps["pyo"]="ぴょ";
			}
			return maps;
		}
	}
}