package 
{
     import flash.display.Sprite;
	 import flash.events.*;

	
	/**
	 * ...
	 * @author djoker
	 */
	public class Main extends Sprite 
	{
		
		 private var engine:Engine;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			engine = new Engine();
			engine.setGameState(new Plataforma());
			addChild(engine);
		  
		}		
     
		
	}
	
}