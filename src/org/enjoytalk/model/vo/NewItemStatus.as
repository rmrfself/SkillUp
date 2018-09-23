/**
* ItemStatus
*
*
*/
package org.enjoytalk.model.vo
{

	public class NewItemStatus extends ItemStatus
	{
		public function NewItemStatus()
		{
			super();
			performance=new ItemPerformance;
		}

		/**
		 *
		 * @return
		 *
		 */
		override public function getPresenter():String
		{
			if (presenter == ItemStatus.STATE_VALUE[DONE])
			{
				return presenter;
			}

			if (presenter == null)
			{
				if (presenter == null && stateValue == 0)
				{
					stateValue++;
				}
				performance.studyCount++;
				performance.studyGotItCount++;
				presenter=ItemStatus.STATE_VALUE[TWOBUTTONRECALL];
				return ItemStatus.STATE_VALUE[STUDY];
			}

			if (stateValue > 0 && (presenter == ItemStatus.STATE_VALUE[STUDY]))
			{
				this.performance.studyCount++;
				presenter=ItemStatus.STATE_VALUE[TWOBUTTONRECALL];
				return ItemStatus.STATE_VALUE[STUDY];
			}

			if (_presenter == ItemStatus.STATE_VALUE[RESTUDY])
			{
				this.performance.revStudyCount++;
				this.performance.revStudyGotItCount++;
				presenter=ItemStatus.STATE_VALUE[TWOBUTTONRECALL];
				return ItemStatus.STATE_VALUE[RESTUDY];
			}

			if (presenter == ItemStatus.STATE_VALUE[TWOBUTTONRECALL])
			{
				/**
					 * recall veiw presenter / update ?
					 *
					 *
					 * **/
				this.performance.displayRecallScreenCount++;
				return presenter;
			}
			return presenter;
		}

		/**
		 * reStudy
		 *
		 */
		override public function reStudy():void
		{
			if (stateValue == ItemStatus.MCQUIZ_REVERSE)
			{
				presenter=ItemStatus.STATE_VALUE[RESTUDY];
			}
			else
			{
				presenter=ItemStatus.STATE_VALUE[STUDY];
			}
		}

		/**
		 *
		 * @param value
		 *
		 */
		override public function set know(value:Boolean):void
		{
			this._know=value;
			if (value)
			{
				switch (stateValue)
				{
					case ItemStatus.MCQUIZ_FIVE:
						presenter=ItemStatus.STATE_VALUE[MCQUIZ_FIVE];
						break;
					case ItemStatus.MCQUIZ_TEN:
						presenter=ItemStatus.STATE_VALUE[MCQUIZ_TEN];
						break;
					case ItemStatus.MCQUIZ_REVERSE:
						presenter=ItemStatus.STATE_VALUE[MCQUIZ_REVERSE];
						break;
					case ItemStatus.SPELL:
						presenter=ItemStatus.STATE_VALUE[SPELL];
						break;
				}
				if (this.stateValue < ItemStatus.MCQUIZ_REVERSE)
				{
					if (this.performance.highConfRecallCount == 0 && this.performance.noConfRecallCount == 0)
					{
						this.performance.highConf1stRecallCorrect=1;
					}
					this.performance.highConfRecallCount++;
				}
				else
				{
					this.performance.revHiConfRecallCount++;
				}
			}
			else
			{
				if (this.stateValue < ItemStatus.MCQUIZ_REVERSE)
				{
					presenter=ItemStatus.STATE_VALUE[ItemStatus.STUDY];
					this.performance.noConfRecallCount++;
				}
				else
				{
					presenter=ItemStatus.STATE_VALUE[ItemStatus.RESTUDY];
					this.performance.revNoConfRecallCount++;
				}
			}
		}

		/**
		 *
		 * @param value
		 *
		 */
		override public function set result(value:Boolean):void
		{
			this._result=value;
			if (value)
			{
				/**
				 * update answer counter
				 *
				 * **/
				if (stateValue < ItemStatus.MCQUIZ_REVERSE)
				{
					if (this.performance.noConfRecallCount == 0 && this.performance.confCorrectCount == 0)
					{
						this.performance.highConf1stRecallCorrect=1;
					}
					this.performance.confCorrectCount++;
				}
				else
				{
					this.performance.revConfCorrectCount++;
				}
				if (stateValue < DONE)
				{
					stateValue++;
					presenter=ItemStatus.STATE_VALUE[TWOBUTTONRECALL];
				}
				else
				{
					presenter=ItemStatus.STATE_VALUE[DONE];
				}
			}
			else
			{
				if (stateValue < ItemStatus.MCQUIZ_REVERSE)
				{
					presenter=ItemStatus.STATE_VALUE[STUDY];
				}
				else
				{
					presenter=ItemStatus.STATE_VALUE[RESTUDY];
				}
			}
		}

		/**
		 *
		 * @param value
		 *
		 */
		override public function set progressDegree(value:Number):void
		{
			_progress_degree=value;
		}

		/**
		 *
		 * @param value
		 *
		 */
		override public function set stateValue(value:Number):void
		{
			this._state_value=value;
			switch (value)
			{
				case 1:
					progressDegree=ItemStatus.PROGRESS_DEGREE[ItemStatus.PROGRESS_STUDY];
					break;
				case 2:
					progressDegree=ItemStatus.PROGRESS_DEGREE[ItemStatus.PROGRESS_MC_FIRST];
					break;
				case 3:
					progressDegree=ItemStatus.PROGRESS_DEGREE[ItemStatus.PROGRESS_MC_SEC];
					break;
				case 4:
					progressDegree=ItemStatus.PROGRESS_DEGREE[ItemStatus.PROGRESS_MC_REVERSE];
					break;
				case 5:
					progressDegree=ItemStatus.PROGRESS_DEGREE[ItemStatus.PROGRESS_SPELL];
					break;
				case 6:
					progressDegree=ItemStatus.PROGRESS_DEGREE[ItemStatus.PROGRESS_OVER];
					break;
			}
		}

		/**
		 *
		 * @return
		 *
		 */
		override public function get presenter():String
		{
			return _presenter;
		}

		override public function set presenter(value:String):void
		{
			this._presenter=value;
		}
	}
}
