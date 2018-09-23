package org.enjoytalk.view.components.homeView.calendar
{
    import mx.controls.Label;
    import mx.core.IDataRenderer;
    import mx.core.UIComponent;
    import mx.formatters.DateFormatter;

    import org.enjoytalk.model.vo.HistoryData;

     

    [Style(name="borderColor", type="uint", format="Color", inherit="no")]
    [Style(name="backgroundColor", type="uint", format="Color", inherit="no")]
    [Style(name="disabledBackgroundColor", type="uint", format="Color", inherit="no")]

    public class CalendarDay extends UIComponent implements IDataRenderer
    {

        private var _dayLabel:Label;

        private var _countLabel:Label;

        private var _data:Object;

        private var _date:Date;

        private var _count:Number = 0;

        private var data_render:UIComponent;

        private static const HEADER_FILL:Number = 0x65C1E7;

        private static const TODAY_BORDER_LINE:Number = 2;

        private static const TODAY_FILL_COLOR:Number = 0xFF9900;

        private static const TODAY_FILL_BACKCOLOR:Number = 0xFFD699;

        override protected function createChildren():void
        {
            _dayLabel = new Label();
            _countLabel = new Label();
            addChild(_dayLabel);
            addChild(_countLabel);
        }

        override protected function measure():void
        {
            measuredWidth = _dayLabel.measuredWidth;
            measuredHeight = _dayLabel.measuredHeight;
        }

        public function set data(value:Object):void
        {
            _data = (value as CalendarData);
            _count = 0;
            if (_data)
            {
                _date = _data.date as Date;
                var history_data:HistoryData = _data.option;
                if (history_data != null)
                {
                    var days_session:Array = history_data.days;
                    for each (var session:Object in days_session)
                    {
                        if (session != null && session.day == _date.date)
                        {
                            _count = session.count;
                            break;
                        }
                    }
                }
            }
            else
            {
                _date = null;
                _count = 0;
            }
            invalidateProperties();
        }

        public function get data():Object
        {
            return _data;
        }

        override protected function commitProperties():void
        {
            _dayLabel.text = (_date == null) ? "" : _date.date.toString();
            _countLabel.text = (_count == 0) ? "" : _count.toString();
            invalidateSize();
            invalidateDisplayList();
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            var dateStr:String;
            var todayStr:String;
            var fm:DateFormatter = new DateFormatter();
            fm.formatString = "YYYYMMDD";

            var today:Date = new Date();

            _dayLabel.setActualSize(unscaledWidth, unscaledHeight);
            _countLabel.setActualSize(unscaledWidth, unscaledHeight);

            _dayLabel.setStyle("color", 0x000000);
            _dayLabel.setStyle("fontWeight", "bold");
            _countLabel.setStyle("fontWeight", "bold");

            graphics.clear();
            dateStr = fm.format(_date);
            todayStr = fm.format(today);

            if (_date != null)
            {
                if (dateStr == todayStr)
                {
                    graphics.beginFill(TODAY_FILL_BACKCOLOR);
                    graphics.lineStyle(3, TODAY_FILL_COLOR);
                    graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 8, 8);
                    graphics.endFill();
                }
                else
                {
                    graphics.beginFill(0xFFFFFF);
                    graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 8, 8);
                    graphics.endFill();
                }

                if (_count > 0)
                {
                    _countLabel.x = 24;
                    _countLabel.y = 7;
                    _countLabel.setStyle("color", 0xFFFFFF);
                    _countLabel.text = _count.toString();
                    graphics.beginFill(0xFF6600);
                    graphics.lineStyle(0, 0xFFFFFF, 0);
                    graphics.drawRoundRectComplex(21, 5, 22, 20, 6, 0, 0, 6);
                    graphics.endFill();
                    graphics.beginFill(0xFF9900);
                    graphics.drawRoundRectComplex(22, 6, 22, 20, 6, 0, 0, 6);
                    graphics.endFill();
                }
                else
                {
                    graphics.beginFill(0xA3A3A3);
                    graphics.lineStyle(0, 0xFFFFFF, 0);
                    graphics.drawRoundRectComplex(21, 5, 22, 20, 6, 0, 0, 6);
                    graphics.endFill();
                    graphics.beginFill(0xCCCCCC);
                    graphics.drawRoundRectComplex(22, 6, 22, 20, 6, 0, 0, 6);
                    graphics.endFill();
                }
            }
            else
            {
                graphics.beginFill(HEADER_FILL);
                graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 8, 8);
                graphics.endFill();
            }
        }

    }
}