/**
 * Created by  zhang qing hua
 * Date: 2009-08-20
 * Note:
 * Rebuild-history:
 * 1. 2009/08/24
 * 2. 2009/08/27
 **/

package org.enjoytalk.view.components.custom
{
    import flash.display.MovieClip;

    import mx.core.UIComponent;

    import org.enjoytalk.model.vo.Item;
    import org.enjoytalk.model.vo.ItemSession;
    import org.enjoytalk.model.vo.ItemStatus;

    public class ItemsGrpManager extends UIComponent
    {
        private var _item:Item;

        private var _session:ItemSession;

        private var pIndicators:PIndicators;

        public function ItemsGrpManager()
        {
            super();
        }


        public function init(items:Array):void
        {
            var itemIds:Array = new Array();
            for each (var item:Item in items)
            {
                itemIds.push(item.id);
            }
            var old_indicators:MovieClip = this.getChildByName("indicators") as MovieClip;
            if (old_indicators != null)
            {
                this.removeChild(old_indicators);
            }
            pIndicators = new PIndicators();
            pIndicators.name = "indicators";
            pIndicators.initItems(itemIds);
            addChildAt(pIndicators, 0);
        }

        public function reset():void
        {

        }

        public function set session(value:ItemSession):void
        {
            this._session = value;
            if (value != null)
            {
                var item_status:ItemStatus = value.itemStatus.currentState;
                pIndicators.updateCurrentPhase(item.id, Number(item_status.progressDegree / 10) + 1);
            }
        }

        public function get session():ItemSession
        {
            return _session;
        }

        public function set item(value:Item):void
        {
            this._item = value;
            pIndicators.setSelected(_item.id);
        }

        public function get item():Item
        {
            return this._item;
        }
    }
}