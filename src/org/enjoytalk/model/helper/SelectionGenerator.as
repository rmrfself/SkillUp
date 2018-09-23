package org.enjoytalk.model.helper
{
	import org.enjoytalk.model.vo.ConstVar;
	import org.enjoytalk.model.vo.Course;
	import org.enjoytalk.model.vo.Item;
	import org.enjoytalk.model.vo.Selection;

	public class SelectionGenerator
	{
		public function makeSelections(course:Course, currentItem:Item, num:int, type:String, answerRandom:Number):Array
		{

			var itemsList:Array=new Array();
			var seedList:Array=new Array();
			var selectionList:Array=new Array();

			var tmp:Object;

//			for (var key:Object in course.items)
//			{
//				tmp=course.items[key] as Item;
//				seedList.push(tmp);
//			}

			var length:int=seedList.length;
			num=(length < num ? length : num);

			while (true)
			{
				if (itemsList.length == num)
				{
					break;
				}
				var ti:Item=seedList[Math.floor(Math.random() * seedList.length)];
				if (itemsList.indexOf(ti) == -1)
				{
					itemsList.push(ti);
					// 从种子中删掉
					seedList.splice(seedList.indexOf(ti),1);
				}
			}
			return selectionList;
		}

		public function mixInAnswer(selectionList:Array, item:Item, random:Number, type:String):void
		{
			var hasAnswer:Boolean=false;
			var sel:Selection;
			for (var i:int=0; i < selectionList.length; i++)
			{
				sel=selectionList[i];
				if (sel.isAnswer)
				{
					hasAnswer=true;
				}
			}
			// 设置 没有答案 的出现几率
			var rand:Number=Math.random();
			if (!hasAnswer)
			{
				sel=new Selection();
				sel.isAnswer=true;
				sel.isEnable=true;
				sel.answered=false;
				if (rand < random)
				{
					sel.label=ConstVar.NO_ANSWER_SELECT;
					selectionList[selectionList.length - 1]=sel;
				}
				else
				{
//					sel.label=(type == ConstVar.CH_SELECTION_TPYE ? item.explaination : item.kana);
					selectionList[Math.floor(Math.random() * selectionList.length)]=sel;
				}
			}
		}
	}
}