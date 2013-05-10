package  
{
	import flash.display.Sprite;
	 
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author djoker
	 */
	public class Engine extends Sprite
	{
	
	private var stepRate:Number;
    private var last:Number;
    private var now:Number;
    private var delta:Number;
	private var status:Stats;
	public var maxElapsed:Number = 0.0333;
	private var keyPressList:Array = [];
	private var state:GameState = null;
    private  var key:Vector.<Boolean> = new Vector.<Boolean>(256);

	public  var elapsedtime:Number;
	public  var elapsed:Number;
	public  var rate:Number = 1;
	
			
		public function Engine() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
	
		
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		    last = getTimer();
            now = last;
            delta = 0;
		    addChild(new Stats());	
	        addEventListener(Event.ENTER_FRAME, tick);
		}
		 private function tick(e:Event )
		{
	     now = getTimer();
         delta += now - last;
	     elapsedtime = delta;
  	     elapsed = (now - last) / 1000;
	     if (elapsed > maxElapsed) elapsed = maxElapsed;
	     elapsed *= rate;
	 	if (state != null) state.Update(elapsed);
         last = now;
		}
		
		public function setGameState (state:GameState) 
		{
		if (this.state != null) 
		{
		  this.state.hide();
		  removeChild(this.state);
		}

		this.state = state;
		addChild(this.state);
		this.state.show();
		
	    }

	}

}