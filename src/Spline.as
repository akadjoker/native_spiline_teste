package  
{
	
		import flash.geom.Point;
		
	/**
	 * ...
	 * @author djoker
	 */
	public class Spline 
	{
		private var _points:Array = new Array();
		private var _segmentSize:Number = 0;
		private var returnpoint:Point;
		
		public function Spline() 
		{
			returnpoint = new Point();
		}
		
		 public function AddPoint(point:Point):void
        {
		_points.push(point);
		
        
            _segmentSize = Number(1 / _points.length);
        }
		 private function LimitPoints( point:int):int
        {
            if (point < 0)
            {
                return 0;
            }
            else if (point > _points.length - 1)
            {
                return _points.length - 1;
            }
            else
            {
                return point;
            }
        }

		    public function GetPositionOnLine( t:Number):Point
        {
            if (_points.length <= 1)
            {
                return new Point(0, 0);
            }

            // Get the segment of the line we're dealing with.
            var interval:int = (int)(t / _segmentSize);

            // Get the points around the segment
           var  p0:int = LimitPoints(interval - 1);
           var  p1:int = LimitPoints(interval);
           var  p2:int = LimitPoints(interval + 1);
           var  p3:int = LimitPoints(interval + 2);

            // Scale t to the current segement
            var scaledT:Number = (t - _segmentSize * Number(interval)) / _segmentSize;
           return CalculateCatmullRom(scaledT, _points[p0], _points[p1], _points[p2], _points[p3]);
        }


		
		private function CalculateCatmullRom(t:Number,  p0:Point,  p1:Point,  p2:Point,  p3:Point):Point
        {
            var t2:Number = t * t;
            var t3:Number = t2 * t;

			/*
            var  b1:Number= 0.5 * (-t3 + 2 * t2 - t);
            var  b2:Number= 0.5 * (3 * t3 - 5 * t2 + 2);
            var  b3:Number= 0.5 * (-3 * t3 + 4 * t2 + t);
            var  b4:Number = 0.5 * (t3 - t2);
			*/
			
			
			
			
 		returnpoint.x = 0.5 * (( 2 * p1.x ) +
 			( -p0.x + p2.x ) * t +
 			( 2 * p0.x - 5.0 * p1.x + 4 * p2.x - p3.x ) * t2 +
 			( -p0.x + 3 * p1.x - 3 * p2.x + p3.x ) * t3 );

 		returnpoint.y = 0.5 * ( ( 2 * p1.y ) +
 			( -p0.y + p2.y ) * t +
 			( 2 * p0.y - 5.0 * p1.y + 4 * p2.y - p3.y ) * t2 +
 			( -p0.y + 3 * p1.y - 3 * p2.y + p3.y ) * t3 );

			
            return returnpoint; 
         //   return (p1 * b1 + p2 * b2 + p3 * b3 + p4 * b4);
        }
		
	}

}