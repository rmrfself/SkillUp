/**
* Item progress tracer
 *
 *
*/
package org.enjoytalk.model.vo
{
	import org.enjoytalk.model.utils.Tools;

	public class ItemProgress extends AbstractData
	{
		public static var STUDY_WEIGHT:Number=1;

		public var LC1Weight:Number=4;

		public var LC2Weight:Number=2;

		public var HC1Weight:Number=8;

		public var HC2Weight:Number=4;

		public var SUCCESS_RATIO_THRESHOLD:Number=70;

		public var SUCCESS_COUNT_FOR_COMPLETE:Number=4;

		public var ABOVE_THRESHOLD:Number=70;

		public var oldStatus:ItemStatus;

		public var performance:ItemPerformance;

		private var _ratio:Number=0;

		private var _is_weak:Boolean=false;

		private var _new_status:ItemStatus;

		/**
		 *
		 * @param perf
		 * @param stat
		 *
		 */
		public function ItemProgress(perf:ItemPerformance, stat:ItemStatus)
		{
			oldStatus=stat;
			performance=perf;
			_new_status=new ItemStatus();
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getProgress():Number
		{
			if (oldStatus.isCompleted)
			{
				_new_status.isCompleted=true;
				return (1);
			}
			_new_status.progress=calculateProgress(ratio, oldStatus.success_count, oldStatus.presentation_count, oldStatus.cumulative_ratio_required_to_complete, oldStatus.cumulative_ratio);
			return _new_status.progress;
		}

		/**
		 *
		 * @param sessionPerformanceScore
		 * @param sessionBestScore
		 * @return
		 *
		 */
		public function calculateRatio(sessionPerformanceScore:Number, sessionBestScore:Number):Number
		{
			return (sessionBestScore > 0 ? (Math.round(100 * sessionPerformanceScore / sessionBestScore)) : (0));
		}

		/**
		 *
		 * @param ratioValue
		 * @param success_count
		 * @param presentationCount
		 * @param cumulative_ratio_required_to_complete
		 * @param cumulativeRatio
		 * @return
		 *
		 */
		public function calculateProgress(ratioValue:Number, success_count:Number, presentationCount:Number, cumulative_ratio_required_to_complete:Number, cumulativeRatio:Number):Number
		{
			/**
			 * success ratio
			 */
			var r_suc_ratio:Number=calculateSuccessRatioThreshold(success_count);

			var r_complete_ratio:Number=isFirstStudy(presentationCount) ? (initalCumulativeRatioRequiredToComplete) : (cumulative_ratio_required_to_complete);
			/**
			 * Require to complete
			 *
			 */
			var calculated_complete_ratio:Number=calculateCumulativeRatioRequiredToComplete(ratioValue, r_suc_ratio, r_complete_ratio);
			/**
			 * calcuted cumulative ratio
			 *
			 */
			var calculated_ratio:Number=calculateCumulativeRatio(cumulativeRatio, ratioValue);
			if (calculated_ratio > calculated_complete_ratio)
			{
				return (1);
			}
			return (Tools.omitDecimals(calculated_ratio / calculated_complete_ratio, 2));
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getBestScore():Number
		{
			/**
			 * Study count
			 *
			 **/
			var study_weight:Number=STUDY_WEIGHT * (performance.studyCount + performance.revStudyCount);
			/**
			 * Recall counter
			 *
			 */
			var local_var2:Number=performance.noConfRecallCount + performance.lowConfRecallCount + performance.highConfRecallCount;
			var local_var7:Number=HC1Weight * Math.min(local_var2, 1);
			local_var2=(local_var2 > 0 ? (local_var2 - 1) : (local_var2));
			var local_var5:Number=HC2Weight * local_var2;
			/**
			 * Review counter
			 *
			 */
			var local_var6:Number=Math.max(performance.revNoConfRecallCount + performance.revLoConfRecallCount + performance.revHiConfRecallCount, 1);
			var local_var3:Number=HC2Weight * local_var6;
			/**
			* Result
			*
			*/
			return (study_weight + local_var7 + local_var5 + local_var3);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function getPerformanceScore():Number
		{
			var study_weight:Number=STUDY_WEIGHT * (performance.studyGotItCount + performance.revStudyGotItCount);
			/**
			 * Quiz result
			 *
			 */
			var local_var4:Number=LC1Weight * performance.lowConf1stRecallCorrect + HC1Weight * performance.highConf1stRecallCorrect;
			/**
			 * Second and so on  study result
			 *
			 */
			var local_var2:Number=LC2Weight * (performance.lowConfCorrectCount - performance.lowConf1stRecallCorrect) + HC2Weight * (performance.confCorrectCount - performance.highConf1stRecallCorrect);
			/**
			 * Review study count
			 */
			var local_var5:Number=LC2Weight * performance.lowRevConfCorrectCount + HC2Weight * performance.revConfCorrectCount;
			var p:Number=study_weight + local_var4 + local_var2 + local_var5;
			return (study_weight + local_var4 + local_var2 + local_var5);
		}

		/**
		 *
		 * @param ratioValue
		 * @param successRatioThreshold
		 * @param oldCumulativeRatioRequiredToComplete
		 * @return
		 *
		 */
		public function calculateCumulativeRatioRequiredToComplete(ratioValue:Number, successRatioThreshold:Number, oldCumulativeRatioRequiredToComplete:Number):Number
		{
			ratioValue=validate(ratioValue, ratio);
			successRatioThreshold=validate(successRatioThreshold, calculateSuccessRatioThreshold(successRatioThreshold));
			if (!(oldCumulativeRatioRequiredToComplete is Number))
			{
				if (isFirstStudy(oldStatus.presentation_count))
				{
					oldCumulativeRatioRequiredToComplete=initalCumulativeRatioRequiredToComplete;
				}
				else
				{
					oldCumulativeRatioRequiredToComplete=oldStatus.cumulative_ratio_required_to_complete;
				}
			}
			_new_status.cumulative_ratio_required_to_complete=(ratioValue < successRatioThreshold ? (oldCumulativeRatioRequiredToComplete + ratioValue) : (oldCumulativeRatioRequiredToComplete + ratioValue - successRatioThreshold));
			return _new_status.cumulative_ratio_required_to_complete;
		}

		/**
		 *
		 * @param presentationCountToUse
		 * @return
		 *
		 */
		public function isFirstStudy(presentationCountToUse:Number):Boolean
		{
			if (!(presentationCountToUse is Number))
			{
				presentationCountToUse=oldStatus.presentation_count;
			}
			return (presentationCountToUse == 0);
		}

		/**
		 *
		 * @param successCountToUse
		 * @return
		 *
		 */
		public function calculateSuccessRatioThreshold(successCountToUse:Number):Number
		{
			if (!(successCountToUse is Number))
			{
				successCountToUse=oldStatus.success_count;
			}
			return (Math.min(SUCCESS_RATIO_THRESHOLD + (100 - SUCCESS_RATIO_THRESHOLD) / (SUCCESS_COUNT_FOR_COMPLETE - 1) * (successCountToUse), 100));
		}

		/**
		 *
		 * @param oldRatio
		 * @param newRatio
		 * @return
		 *
		 */
		public function calculateCumulativeRatio(oldRatio:Number, newRatio:Number):Number
		{
			oldRatio=validate(oldRatio, oldStatus.cumulative_ratio);
			newRatio=validate(newRatio, ratio);
			_new_status.cumulative_ratio=oldRatio + newRatio;
			return _new_status.cumulative_ratio;
		}

		/**
		 *
		 * @param ratioToUse
		 * @param successCountToUse
		 * @param successRatioThresholdToUse
		 * @return
		 *
		 */
		public function calculateNewSuccessCount(ratioToUse:Number, successCountToUse:Number, successRatioThresholdToUse:Number):Number
		{
			ratioToUse=validate(ratioToUse, ratio);
			successCountToUse=validate(successCountToUse, oldStatus.success_count);
			successRatioThresholdToUse=validate(successRatioThresholdToUse, calculateSuccessRatioThreshold(oldStatus.success_count));
			_new_status.success_count=(ratioToUse < successRatioThresholdToUse ? (successCountToUse) : (successCountToUse + 1));
			return _new_status.success_count;
		}

		/**
		 *
		 * @param ratioVal
		 * @param oldAboveThresholdCountVal
		 * @return
		 *
		 */
		public function getAboveThresholdCount(ratioVal:Number, oldAboveThresholdCountVal:Number):Number
		{
			var old_above_count:Number=validate(oldAboveThresholdCountVal, oldStatus.above_threshold_count);
			var ratio_val:Number=validate(ratioVal, ratio);
			_new_status.above_threshold_count=(ratio_val >= ABOVE_THRESHOLD ? (old_above_count + 1) : (old_above_count))
			return _new_status.above_threshold_count;
		}

		/**
		 *
		 * @param ratioValue
		 * @param oldBelowThresholdCountValue
		 * @return
		 *
		 */
		public function getBelowThresholdCount(ratioValue:Number, oldBelowThresholdCountValue:Number):Number
		{
			var old_below_value:Number=validate(oldBelowThresholdCountValue, oldStatus.below_threshold_count);
			var ratio_value:Number=validate(ratioValue, ratio);
			_new_status.below_threshold_count=(ratio_value < ABOVE_THRESHOLD) ? (old_below_value + 1) : (old_below_value);
			return _new_status.below_threshold_count;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get initalCumulativeRatioRequiredToComplete():Number
		{
			return ((SUCCESS_RATIO_THRESHOLD + 100) * SUCCESS_COUNT_FOR_COMPLETE / 2);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get isWeak():Boolean
		{
			return Boolean(getProgress() < 5.000000E-001);
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set isWeak(value:Boolean):void
		{
			_is_weak=value;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get ratio():Number
		{
			_new_status.ratio=calculateRatio(getPerformanceScore(), getBestScore());
			return _new_status.ratio;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get newItemStatus():ItemStatus
		{
			return _new_status;
		}
	}
}
