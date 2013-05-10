package  
{
	
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author djoker
	 */
	public class Path 
	{
		
		private var _original:Number;
    	private var _distance:Number;
        private var _current:Number;
        private var _totalTimePassed:Number = 0;
        private var _totalDuration:Number = 5;
        private var _finished:Boolean = false;
		
		private var  _spline:Spline = new Spline();
		private var position:Point;
		
		
		public function Path(travelTime:Number, start:Number = 0, end:Number = 1 ) 
		{
		    _distance = end - start;
            _original = start;
            _current = start;
            _totalDuration = travelTime;
			position = new Point();
		}
		
		public function AddPoint(x:Number,y:Number):void
		{
		var point:Point = new Point(x, y);
		_spline.AddPoint(point);
		}
		
		 public function UpdatePosition(elapsedTime:Number, sprite :Sprite):void
        {
           Update(elapsedTime);
           position = _spline.GetPositionOnLine(_current);
		   sprite.x = position.x;
		   sprite.y = position.y;
        }
		


        public function IsFinished():Boolean
        {
            return _finished;
        }
		
		private function Update( elapsedTime:Number):void
        {
            _totalTimePassed += elapsedTime;
            _current = Linear(_totalTimePassed, _original, _distance, _totalDuration);

            if (_totalTimePassed > _totalDuration)
            {
                _current = _original + _distance;
                _finished = true;
            }
        }
		
		private function Linear( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
            return distance * timePassed / duration + start;
        }
		private function  EaseOutExpo( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
            if (timePassed == duration)
            {
                return start + distance;
            }
            return distance * (-Math.pow(2, -10 * timePassed / duration) + 1) + start;
        }
	    private function  EaseInExpo( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
            if (timePassed == duration)
            {
                return start + distance;
            }
          return distance * Math.pow(2, 10 * (timePassed / duration - 1)) + start;
        }

		 private function EaseOutCirc( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
            return distance * Math.sqrt(1 - (timePassed = timePassed / duration - 1) * timePassed) + start;
        }
          private function EaseInCirc( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
           return -distance * (Math.sqrt(1 - (timePassed /= duration) * timePassed) - 1) + start;
        }

		   private function BounceEaseOut( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
            if ((timePassed /= duration) < (1 / 2.75))
                return distance * (7.5625 * timePassed * timePassed) + start;
            else if (timePassed < (2 / 2.75))
                return distance * (7.5625 * (timePassed -= (1.5 / 2.75)) * timePassed + .75) + start;
            else if (timePassed < (2.5 / 2.75))
                return distance * (7.5625 * (timePassed -= (2.25 / 2.75)) * timePassed + .9375) + start;
            else
                return distance * (7.5625 * (timePassed -= (2.625 / 2.75)) * timePassed + .984375) + start;
        }

		 private function BounceEaseIn( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
            return distance - BounceEaseOut(duration - timePassed, 0, distance, duration) + start;
        }

         private function  BounceEaseInOut( timePassed:Number,  start:Number,  distance:Number,  duration:Number):Number
        {
            if (timePassed < duration / 2)
                return BounceEaseIn(timePassed * 2, 0, distance, duration) * .5 + start;
            else
                return BounceEaseOut(timePassed * 2 - duration, 0, distance, duration) * .5 + distance * .5 + start;
        }

		
	}

}