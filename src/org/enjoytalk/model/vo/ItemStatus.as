package org.enjoytalk.model.vo
{
    import org.enjoytalk.model.utils.*;

    public class ItemStatus
    {
        public static const NEW:Number = 0;

        public static const REVIEW:Number = 1;

        public static const FINAL:Number = 2;

        public static const COMPLETED:Number = 3;

        public static const STATE_CATEGORY_LABELS:Array = [ "new", "review", "final", "completed" ];


        public static const ITEM_STATES:Array = [ "study", "mc_quiz", "spell", "done" ];

        public static const STATE_STUDY:Number = 0;

        public static const STATE_MCQUIZ:Number = 1;

        public static const STATE_SPELL:Number = 2;

        public static const STATE_DONE:Number = 3;

        public static const PROGRESS_DEGREE:Array = [ 10, 30, 50, 80, 100 ];

        public static const PROGRESS_STUDY:Number = 0;

        public static const PROGRESS_MC_FIRST:Number = 1;

        public static const PROGRESS_MC_SEC:Number = 2;

        public static const PROGRESS_MC_REVERSE:Number = 3;

        public static const PROGRESS_SPELL:Number = 4;

        public static const PROGRESS_OVER:Number = 5;

        /**
         * 0 - STUDY
         * 1 - MUL-CHOICE  5
         * 2 = MUL-CHOICE  10
         * 3 - RE-STTUDY
         * 4 - RESPONSE-MUL-CHOICE 5
         * 5 - SPELL
         * 6 - DONE
         *
         * **/
        public static const STATE_VALUE:Array = [ "study", "mc_quiz_1", "mc_quiz_2", "mc_quiz_reverse", "spell", "done", "twobutton_recall", "threebutton_recall", "mc_quiz", "restudy" ];

        public static const STUDY:Number = 0;

        public static const MCQUIZ_FIVE:Number = 1;

        public static const MCQUIZ_TEN:Number = 2;

        public static const MCQUIZ_REVERSE:Number = 3;

        public static const SPELL:Number = 4;

        public static const DONE:Number = 5;

        public static const TWOBUTTONRECALL:Number = 6;

        protected static const THREEBUTTONRECALL:Number = 7;

        public static const MC_QUIZ:Number = 8;

        public static const RESTUDY:Number = 9;

        protected var _state_value:Number = 0;

        public static const HIGH_URGENCY:Number = 21;

        public static const NEW_ITEM:Number = 0;

        public static const WEAK_ITEM:Number = 1;

        public static const STRONG_ITEM:Number = 2;

        public static const COMPLETED_ITEM:Number = 3;

        public static const SKIP_ITEM:Number = 4;

        public static const FILTER:Number = 5;

        public var item_id:Number = 0;

        public var ratio:Number = 0;

        public var cumulative_ratio_required_to_complete:Number = 0;

        public var cumulative_ratio:Number = 0;

        public var presentation_count:Number = 0;

        public var success_count:Number = 0;

        public var above_threshold_count:Number = 0;

        public var below_threshold_count:Number = 0;

        public var cumulative_tatio:Number = 0;

        public var urgency:Number = 0;

        public var is_filter:Boolean = false;

        private var _progress:Number = 0;

        private var _is_skipped:Boolean = false;

        private var _is_new:Boolean = false;

        private var _is_completed:Boolean = false;

        private var _current_category:String = null;

        private var _current_state:ItemStatus = null;

        protected var _presenter:String = null;

        protected var _next_presenter:String = null;

        protected var _result:Boolean = true;

        protected var _know:Boolean = false;

        protected var _progress_degree:Number = 0;

        private var _performance:ItemPerformance;


        public function ItemStatus()
        {
        }

        public function initializeStatus():void
        {
            switch (success_count)
            {
                case 0:
                    currentCategory = STATE_CATEGORY_LABELS[NEW];
                    currentState = new NewItemStatus();
                    break;
                case 1:
                    currentCategory = STATE_CATEGORY_LABELS[REVIEW];
                    currentState = new ReviewItemStatus();
                    break;
                case 2:
                    currentCategory = STATE_CATEGORY_LABELS[FINAL];
                    currentState = new FinalItemStatus();
                    break;
                case 3:
                    currentCategory = STATE_CATEGORY_LABELS[COMPLETED];
                    currentState = new CompletedItemStatus();
                    break;
            }
        }

        public function get isBlocked():Boolean
        {
            if (currentState.progressDegree == PROGRESS_DEGREE[PROGRESS_MC_SEC] || currentState.progressDegree == PROGRESS_DEGREE[PROGRESS_SPELL])
            {
                return true;
            }
            return false;
        }

        public function getPresenter():String
        {
            return null;
        }

        public function reStudy():void
        {
        }

        private function getProgressFloat(precision:Number):Number
        {
            return (Tools.omitDecimals(cumulative_ratio / cumulative_ratio_required_to_complete, precision));
        }

        public function get isSkipped():Boolean
        {
            return this._is_skipped;
        }

        public function set isSkipped(value:Boolean):void
        {
            this._is_skipped = value;
        }

        public function get isNew():Boolean
        {
            return this._is_new;
        }

        public function set isNew(value:Boolean):void
        {
            this._is_new = value;
        }

        public function get isCompleted():Boolean
        {
            return this._is_completed;
        }

        public function set isCompleted(value:Boolean):void
        {
            this._is_completed = value;
        }

        public function set progress(value:Number):void
        {
            this._progress = value;
        }

        public function get progress():Number
        {
            return this._progress;
        }


        public function get statusType():Number
        {
            if (this._is_skipped)
            {
                return SKIP_ITEM;
            }
            else if (presentation_count == 0)
            {
                return NEW_ITEM;
            }
            else if (_progress == 100)
            {
                return COMPLETED_ITEM;
            }
            else if (_progress >= 50)
            {
                return STRONG_ITEM;
            }
            else
            {
                return WEAK_ITEM;
            }
        }

        public function get currentState():ItemStatus
        {
            return this._current_state;
        }

        public function set currentState(value:ItemStatus):void
        {
            this._current_state = value;
        }

        public function get currentCategory():String
        {
            return this._current_category;
        }

        public function set currentCategory(value:String):void
        {
            this._current_category = value;
        }

        public function get result():Boolean
        {
            return _result;
        }

        public function set result(value:Boolean):void
        {
            this._result = value;
        }

        public function set performance(value:ItemPerformance):void
        {
            _performance = value;
        }

        public function get performance():ItemPerformance
        {
            return _performance;
        }

        public function get know():Boolean
        {
            return this._know;
        }

        public function set know(value:Boolean):void
        {
            this._know = value;
        }

        public function get stateValue():Number
        {
            return this._state_value;
        }

        public function set stateValue(value:Number):void
        {
            this._state_value = value;
        }

        public function get presenter():String
        {
            return _presenter;
        }

        public function set presenter(value:String):void
        {
            this._presenter = value;
        }


        public function set nextPresenter(value:String):void
        {
            this._next_presenter = value;
        }

        public function get nextPresenter():String
        {
            return this._next_presenter;
        }

        [Bindable]
        public function get progressDegree():Number
        {
            return this._progress_degree;
        }

        public function set progressDegree(value:Number):void
        {
            this._progress_degree = value;
        }
    }
}