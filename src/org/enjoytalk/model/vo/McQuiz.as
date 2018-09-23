package org.enjoytalk.model.vo
{

	public class McQuiz extends Quiz
	{
		private var _distractors:DistractorsData;

		private var _textAnswer:String;
		private var _textQuestion:String;


		public function McQuiz()
		{
			super(DataContent.MCQUIZ);
			_distractors=new DistractorsData();
		}

		public function hasDistractorsOf(type:String="text"):Boolean
		{
			return (this._distractors.getDistractors(type) != null && this._distractors.getDistractors(type).length > 0)
		}

		public function getRandDistractors(length:Number=10, type:String="text"):Array
		{
			var data:Array=distractors.getDistractors(type);
			var distractorsData:Array;
			if (data.length > 0)
			{
				distractorsData=new Array();
				var partLen:Number=(data.length > length ? length : data.length);
				for (var k:Number=0; k < partLen; k++)
				{
					distractorsData.push(data[k]);
				}
				if (length == 5 && distractorsData.length > 4)
				{
					distractorsData=distractorsData.slice(0, 4);
				}
				var noAnswerLabel:String=ConstVar.NO_ANSWER_ZH_HANS;
				switch (this.distractors.language)
				{
					case ConstVar.S_LANGUAGE_EN:
						noAnswerLabel=ConstVar.NO_ANSWER_EN;
						break;
					case ConstVar.S_LANGUAGE_JP:
						noAnswerLabel=ConstVar.NO_ANSWER_JP;
						break;
					case ConstVar.S_LANGUAGE_ZH_HANS:
						noAnswerLabel=ConstVar.NO_ANSWER_ZH_HANS;
						break;
					case ConstVar.S_LANGUAGE_ZH_HANT:
						noAnswerLabel=ConstVar.NO_ANSWER_ZH_HANT;
						break;
					default:
						noAnswerLabel=ConstVar.NO_ANSWER_ZH_HANS;
				}
				distractorsData=distractorsData.randomize();
				var random:Number=Math.floor(Math.random() * 10);
				var rightAnswer:DistractorData;
				rightAnswer=new DistractorData(0, this.answer);
				rightAnswer.isAnswer=true;
				if (random < 2)
				{
					var noAnswerData:DistractorData=new DistractorData(0, noAnswerLabel);
					noAnswerData.extraData=this.answer;
					distractorsData.push(noAnswerData);
					var randAnswer:Number=Math.floor((Math.random() * distractorsData.length));
					if (randAnswer > distractorsData.length - 1)
					{
						randAnswer=distractorsData.length - 1;
					}
					distractorsData[randAnswer]=rightAnswer;
				}
				else
				{
					if (distractorsData.length < length)
					{
						distractorsData.push(rightAnswer);
						distractorsData=distractorsData.randomize();
					}
				}
				var checkAnswer:Boolean=false;
				for each (var dt:DistractorData in distractorsData)
				{
					dt.isEnable=true;
					dt.language=distractors.language;
					if (dt.isAnswer)
					{
						if (checkAnswer)
						{
							dt.text="--";
							dt.isAnswer=false;
						}
						checkAnswer=true;
					}
				}
				if (!checkAnswer)
				{
					randAnswer=Math.floor((Math.random() * distractorsData.length));
					if (randAnswer > distractorsData.length - 1)
					{
						randAnswer=distractorsData.length - 1;
					}
					distractorsData[randAnswer]=rightAnswer;
				}
			}
			return distractorsData;
		}

		public function getDistractors(type:String="text"):Array
		{
			return distractors.getDistractors(type);
		}

		public function get distractors():DistractorsData
		{
			return _distractors;
		}

		public function set distractors(value:DistractorsData):void
		{
			_distractors=value;
		}

		public function get textAnswer():String
		{
			return this.answer;
		}

		public function get textQuestion():String
		{
			return this.question;
		}
	}
}
