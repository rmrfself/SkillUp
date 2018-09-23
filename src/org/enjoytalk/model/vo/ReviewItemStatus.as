package org.enjoytalk.model.vo
{

    public class ReviewItemStatus extends NewItemStatus
    {
        public function ReviewItemStatus()
        {
            super();
            stateValue = ItemStatus.MCQUIZ_FIVE;
        }

        /**
         *
         * @return which presenter
         *
         */
        override public function getPresenter():String
        {
            if (_presenter == ItemStatus.STATE_VALUE[DONE])
            {
                return _presenter;
            }

            if (_presenter == null)
            {
                _presenter = ItemStatus.STATE_VALUE[STUDY];
                this.performance.displayRecallScreenCount++;
                return ItemStatus.STATE_VALUE[TWOBUTTONRECALL];
            }

            if (stateValue > 0 && (presenter == ItemStatus.STATE_VALUE[STUDY]))
            {
                this.performance.studyCount++;
                presenter = ItemStatus.STATE_VALUE[TWOBUTTONRECALL];
                return ItemStatus.STATE_VALUE[STUDY];
            }

            if (_presenter == ItemStatus.STATE_VALUE[RESTUDY])
            {
                this.performance.revStudyCount++;
                this.performance.revStudyGotItCount++;
                presenter = ItemStatus.STATE_VALUE[TWOBUTTONRECALL];
                return ItemStatus.STATE_VALUE[RESTUDY];
            }

            if (presenter == ItemStatus.STATE_VALUE[TWOBUTTONRECALL])
            {
                /**
                  * recall veiw presenter / update ?
                  *
                  *
                  ***/
                this.performance.displayRecallScreenCount++;
                return presenter;
            }
            return _presenter;
        }
    }
}