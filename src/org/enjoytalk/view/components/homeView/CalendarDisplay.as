/*Copyright (c) 2009
   作者：张庆华
   邮箱：xanderzhang@live.com
   标注：
   1. 自定义日历控件
   2. 实现基本日历功能
   3. 从网络加载用于每天学完的单词数
 */

package org.enjoytalk.view.components.homeView
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    import mx.core.ClassFactory;
    import mx.core.IDataRenderer;
    import mx.core.UIComponent;

    import org.enjoytalk.model.vo.HistoryData;
    import org.enjoytalk.view.components.homeView.calendar.*;

    [Event(name="month_change", type="flash.events.Event")]

    public class CalendarDisplay extends UIComponent
    {
        private var _animator:LayoutAnimator;

        private var _cellWidth:int;

        private var _cellHeight:int;

        private static const MAXIMUM_COLUMN_LENGTH:Number = 7;

        private static const DAY_CATHE_COUNT:int = 42;

        private var _rowLength:int;

        private var _columnLength:int;

        private var _dayCache:InstanceCache;

        private var _currentRange:DateRange;

        private var _pendingRange:DateRange;

        private var _visibleRange:DateRange;

        private var _computedRange:DateRange;

        private var _tz:TimeZone;

        private var _history_data:HistoryData;

        public function CalendarDisplay()
        {
            var dt:Date = new Date();
            _tz = TimeZone.localTimeZone;
            range = new DateRange(_tz.startOfMonth(dt), _tz.endOfMonth(dt));

            _visibleRange = new DateRange();

            _animator = new LayoutAnimator();
            _animator.layoutFunction = generateLayout;

            _dayCache = new InstanceCache();
            _dayCache.destroyUnusedInstances = false;
            _dayCache.createCallback = dayChildCreated;
            _dayCache.assignCallback = InstanceCache.showInstance;
            _dayCache.releaseCallback = hideInstance;
            _dayCache.destroyCallback = InstanceCache.removeInstance;
            _dayCache.factory = new ClassFactory(CalendarDay);

            /**
             * item's history data;
             *
             * **/
            _history_data = new HistoryData();
        }

        // 用于与用户交互 ，设置每个月的显示范围 ， 比如 2 月，3月
        public function set range(value:DateRange):void
        {
            _pendingRange = value;
            //分发一个事件 ，通知被绑定的控件更新自己的数据
            dispatchEvent(new Event("change"));
            //下面函数将触发 commitProperties 被调用
            invalidateProperties();
            dispatchEvent(new Event("month_change"));
        }

        //分发事件时调用的函数
        [Bindable("change")]
        public function get range():DateRange
        {
            var result:DateRange = _computedRange;
            var bRecompute:Boolean = false;
            var pr:DateRange = _currentRange;
            if (_pendingRange != null)
            {
                bRecompute = true;
                pr = _pendingRange;
            }
            if (bRecompute)
            {
                var ranges:Object = computeRanges(pr);
                result = ranges._computedRange;
            }
            return result;
        }

        //覆盖commitProperties函数 ，用于属性改变时的调用 ，先于updateDisplayList被调用
        //这个函数被 invalidateProperties 触发
        override protected function commitProperties():void
        {
            //var prevDM:String=_displayMode;
            var prevFirstDate:Date = new Date(_visibleRange.start);
            var startIndex:int;
            var endIndex:int;
            var dayCount:int;

            // update our current range if changed by the client.
            if (_pendingRange != null)
            {
                _currentRange = _pendingRange;
                _pendingRange = null;
            }

            var ranges:Object = computeRanges(_currentRange);

            _visibleRange = ranges._visibleRange;
            _computedRange = ranges._computedRange;
            updateDetails();

            _dayCache.count = DAY_CATHE_COUNT;

            // 给对象赋值
            var tmp:Date = new Date(_visibleRange.start);
            for (var rPos:int = 0; rPos < _rowLength; rPos++)
            {
                for (var cPos:int = 0; cPos < _columnLength; cPos++)
                {
                    var index:int = rPos + cPos * _rowLength;
                    var inst:UIComponent = _dayCache.instances[index];

                    if (_computedRange.contains(tmp) == false)
                    {
                        IDataRenderer(inst).data = null;
                    }
                    else
                    {
                        var cal_data:CalendarData = new CalendarData();
                        cal_data.date = new Date(tmp);
                        cal_data.option = historyData;
                        IDataRenderer(inst).data = cal_data;
                    }
                    tmp.date++;
                }
            }
            //属性更新完毕
            //触发updateDisplayList函数 显示画面的组件
            invalidateDisplayList();
        }

        // 这个函数被invalidateDisplayList触发
        // 这个函数 有 flex 框架调用
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            _animator.updateLayoutWithoutAnimation();
        }

        // visibleRange is the computedRange expanded to the nearest day or week boundary.	
        private function computeRanges(value:DateRange):Object
        {
            var _visibleRange:DateRange;
            var _computedRange:DateRange;

            _visibleRange = new DateRange(value.start);
            _tz.expandRangeToMonths(_visibleRange, true);
            _computedRange = _visibleRange.clone();
            _tz.expandRangeToWeeks(_visibleRange);
            return { _visibleRange: _visibleRange, _computedRange: _computedRange };
        }


        // various cached calculations based on the current state of the calculation
        private function updateDetails():void
        {
            // now how long (in days) a row and column of the visible range is
            _columnLength = MAXIMUM_COLUMN_LENGTH;
            _rowLength = 6;
            // how big each day area will be
            _cellWidth = (unscaledWidth) / _columnLength;
            _cellHeight = (unscaledHeight) / _rowLength;
        }

        // given a date, find its 0 based index in the current visible range of the calendar (in days).
        private function indexForDate(value:Date):int
        {
            return Math.floor((value.getTime() - _visibleRange.start.getTime()) / DateUtils.MILLI_IN_DAY);
        }

        // returns the date of the nth date currently visible in the calendar.
        private function dateForIndex(index:int):Date
        {
            var result:Date = new Date(_visibleRange.start.getTime());
            result.date = result.date + index;
            return result;
        }

        // 布局日历的网格函数
        private function generateLayout():void
        {
            layOutCells();
        }

        public function layOutCells():void
        {
            for (var rPos:int = 0; rPos < _rowLength; rPos++)
            {
                for (var cPos:int = 0; cPos < _columnLength; cPos++)
                {
                    var index:int = rPos + cPos * _rowLength;
                    var inst:UIComponent = _dayCache.instances[index];

                    var target:LayoutTarget = _animator.targetFor(inst);
                    target.unscaledHeight = _cellHeight - 3;
                    target.unscaledWidth = _cellWidth - 3;
                    target.x = cPos * _cellWidth;
                    target.y = rPos * _cellHeight;
                }
            }
        }

        //布局结束

        //----------------------------------------------------------------------------------------------------
        // 有父画面调用的导航函数
        //----------------------------------------------------------------------------------------------------
        public function next():void
        {
            var r:DateRange = _currentRange.clone();
            r.start.month++;
            r.end.month++;
            range = r;
        }

        public function previous(data:Dictionary):void
        {
            var r:DateRange = _currentRange.clone();
            r.start.month--;
            r.end.month--;
            r.extraData = data;
            range = r;
        }

        //----------------------------------------------------------------------------------------------------
        //Day catche 的回调函数
        //----------------------------------------------------------------------------------------------------
        // callback called by the day/header caches whenever a day/header renderer is no longer needed. Rather than
        // destroying it, we hide it.		
        private function hideInstance(child:UIComponent):void
        {

        }

        private function dayChildCreated(instance:UIComponent, idx:int):void
        {
            instance.styleName = getStyle("dayStyleName");
            addChild(instance);
            //instance.addEventListener(MouseEvent.CLICK, dayClickHandler);
        }

        private function headerChildCreated(instance:UIComponent, idx:int):void
        {

        }

        public function set historyData(value:HistoryData):void
        {
            this._history_data = value;
            this.invalidateProperties();
        }

        public function get historyData():HistoryData
        {
            return this._history_data;
        }
    }
}