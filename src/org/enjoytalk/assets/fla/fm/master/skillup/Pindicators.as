package fm.master.skillup{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Pindicators extends MovieClip {
		
		private var count:Number = 0;
		
		public function Pindicators():void{
			super();
		}
		
		public function  initItems(count:Number):void{
			this.count = count;
			for(var k:Number=0 ; k < count ; k++){
				var cellGroup:CellGroup = new CellGroup() ;
				cellGroup.x = k*21;
				addChild(cellGroup);
			}
		}
		
	}
}