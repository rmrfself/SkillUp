package org.enjoytalk.model.vo
{
	import mx.utils.StringUtil;

	import org.enjoytalk.view.components.custom.Tools;

	public class ContentDataFactory
	{
		private var _contentType:String;

		public function ContentDataFactory(type:String)
		{
			this._contentType = type;
		}

		public function parseData(root:XML):Array
		{
			try
			{
				var items:Array = this.makeItems(root);
				this.setMemories(items, root);
			}
			catch (e:Error)
			{
				return [];
			}
			return items;
		}


		public function setMemories(items:Array, node:XML):void
		{
			var ele_memories:XMLList = node.memory.progress;
			for each (var ele_progress:XML in ele_memories)
			{
				var status:ItemStatus = new ItemStatus();
				status.item_id = Number(ele_progress.@item_id);
				status.above_threshold_count = Number(ele_progress.@above_threshold_count);
				status.urgency = Number(ele_progress.@urgency);
				status.below_threshold_count = Number(ele_progress.@below_threshold_count);
				status.cumulative_ratio = Number(ele_progress.@cumulative_ratio);
				status.cumulative_ratio_required_to_complete = Number(ele_progress.@cumulative_ratio_required_to_complete);
				status.presentation_count = Number(ele_progress.@presentation_count);
				status.ratio = Number(ele_progress.@ratio);
				status.success_count = Number(ele_progress.@success_count);
				status.progress = Number(ele_progress.@progress);
				status.is_filter = Boolean(ele_progress.@is_filter == "1");
				if (Tools.isBooleanData(ele_progress.@skipped))
				{
					status.isSkipped = Boolean(ele_progress.@skipped.toLowerCase() == "true");
				}
				for each (var item:Item in items)
				{
					if (item.id == status.item_id)
					{
						if (item.session == null)
						{
							item.session = new ItemSession(item.id);
						}
						status.initializeStatus();
						item.session.itemStatus = status;
						break;
					}
					if (item.session == null)
					{
						item.session = new ItemSession(item.id);
						status.initializeStatus();
						item.session.itemStatus = status;
					}
				}
			}
		}


		public function makeItems(root:XML):Array
		{

			var items:Array = new Array();
			var xmlList:XMLList = root.items.item;
			for each (var ele_item:XML in xmlList)
			{

				items.push(this.makeItem(ele_item));
			}
			return items;
		}

		public function makeItem(ele_item:XML):Item
		{
			var item:Item = new Item(ele_item.@id, ele_item.@type);
			item.cue = this.makeCue(ele_item);
			item.images = this.makeImages(ele_item);
			item.responses = this.makeResponses(ele_item);
			item.sentences = this.makeSentences(ele_item);
			return item;
		}

		public function makeCue(ele_item:XML):CueData
		{

			var cue:CueData = new CueData();
			cue.text = ele_item.cue.text;
			if (this.hasPos(ele_item.cue.pos))
			{
				cue.partOfSpeech = ele_item.cue.pos;
			}
			if (StringUtil.trim(ele_item.cue.charactor) != null && StringUtil.trim(ele_item.cue.charactor).length > 0)
			{
				cue.character = StringUtil.trim(ele_item.cue.charactor);
			}
			if (StringUtil.trim(ele_item.cue.sound) != null && StringUtil.trim(ele_item.cue.sound).length > 0)
			{
				cue.sound = StringUtil.trim(ele_item.cue.sound);
			}
			makeTransliterations(cue, ele_item.cue);
			makeQuizzes(ele_item.cue, cue, ele_item.@type);
			return cue;
		}

		public function makeImages(ele_item:*):Array
		{
			var images:Array = new Array();
			var root_images:XMLList = ele_item.images.image;
			var cue_images:XMLList = ele_item.cue.image;
			var ele_image:XML;
			if (cue_images != null)
			{
				for each (ele_image in cue_images)
				{
					images.push(ele_image.text());
				}
			}
			if (root_images != null)
			{
				for each (ele_image in root_images)
				{
					images.push(ele_image.text());
				}
			}
			return images;
		}

		public function makeSentences(ele_item:XML):Array
		{
			var ele_sentences:XMLList = ele_item.sentences.sentence;
			if (ele_sentences == null)
			{
				return null;
			}
			var sentences:Array = new Array();
			for each (var ele_sentence:XML in ele_sentences)
			{

				var sentence:SentenceData = new SentenceData();
				sentence.text = ele_sentence.text;
				if (ele_sentence.sound != null)
				{
					sentence.sound = ele_sentence.sound;
				}
				if (ele_sentence.image != null)
				{
					sentence.image = ele_sentence.image;
				}
				if (ele_sentence.creator != null)
				{
					sentence.creator = ele_sentence.creator;
				}
				if (ele_sentence.source != null)
				{
					sentence.source = ele_sentence.source;
				}
				for each (var ele_trans:XML in ele_sentence.translations.sentence)
				{
					sentence.translation = ele_trans.text;
					break;
				}
				try
				{
					this.makeTransliterations(sentence, ele_sentence);
				}
				catch (e:Error)
				{
				}
				sentences.push(sentence);
			}
			return sentences;
		}

		private function hasPos(pos:String):Boolean
		{
			return (!(pos == "--" || pos.toUpperCase() == "NONE" || pos == null || pos.toLowerCase() == "null"));
		}


		public function makeResponses(ele_item:*):Array
		{
			var responses:Array = new Array();
			for each (var ele_response:XML in ele_item.responses.response)
			{
				var response:ResponseData = new ResponseData(ele_response.@type);
				response.text = StringUtil.trim(ele_response.text);
				response.sound = ele_response.sound.text();
				responses.push(this.makeQuizzes(ele_response, response, ele_item.@type));
			}
			return responses;
		}

		public function makeTransliterations(data:*, node:*):*
		{
			for each (var ele_node:XML in node.transliterations.transliteration)
			{
				var type:String = ele_node.@type;
				switch (type)
				{
					case DataContent.KANA:
						try
						{
							data.extraData = new DataContent(DataContent.TRANSLITERATION_KANA);
							data.extraData.value = ele_node.text();
						}
						catch (e:Error)
						{
						}
						break;
					case DataContent.SIMPLIFIED_CHINESE:
						try
						{
							data.extraData = new DataContent(DataContent.TRANSLITERATION_SIMPLIFIED);
							data.extraData.value = ele_node.text();
							data.character = ele_node.text();
						}
						catch (e:Error)
						{
						}
						break;
					case DataContent.ROMANIZED:
						data.romanized = ele_node.text();
						break;
				}
			}
			return data;
		}

		public function makeQuizzes(node:*, data:*, type:String):*
		{
			for each (var ele_quiz:XML in node.quizzes.quiz)
			{
				var type:String = ele_quiz.@type;
				switch (type)
				{
					case DataContent.SPELLING_QUIZ:
						data.spellQuiz = this.makeSpellQuiz(ele_quiz);
						break;
					case DataContent.MC_QUIZ:
						data.mcQuiz = this.makeMcQuiz(ele_quiz);
						break;
				}
			}
			return data;
		}

		private function makeMcQuiz(ele_quiz:XML):Quiz
		{
			var mcQuiz:McQuiz = new McQuiz();
			this.setQa(ele_quiz, mcQuiz);
			if (ele_quiz.distractors != null)
			{
				for each (var ele_distractors:XML in ele_quiz.distractors)
				{
					var type:String = ele_distractors.@type;
					mcQuiz.distractors.language = ele_distractors.@language;
					for each (var ele_distractor:XML in ele_distractors.distractor)
					{
						var tmp:DistractorData = new DistractorData(ele_distractor.@id, ele_distractor.text());
						tmp.isAnswer = false;
						tmp.language = ele_distractors.@language;
						tmp.isEnable = true;
						mcQuiz.getDistractors(type).push(tmp);
					}
				}
			}
			return mcQuiz;
		}

		private function setQa(ele_quiz:*, quiz:Quiz):Quiz
		{
			var ele_question:XML = XML(ele_quiz.question);
			var ele_answer:XML = XML(ele_quiz.answer);
			quiz.setContent(ele_question.text(), ele_answer.text());
			return quiz;
		}

		private function makeSpellQuiz(ele_quiz:*):Quiz
		{
			return SpellQuiz(this.setQa(ele_quiz, new SpellQuiz()));
		}
	}
}
