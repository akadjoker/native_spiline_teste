package  
{
	
		import flash.geom.Point;
	    import flash.geom.Rectangle;

	
	/**
	 * ...
	 * @author djoker
	 */
	public class Utils 
	{
		
		static internal var roundingError:Number = 0.0000001;
        static public const LEFT:uint	= 0x0001;
		static public const RIGHT:uint	= 0x0010;
		static public const UP:uint		= 0x0100;
		static public const DOWN:uint	= 0x1000;
		static public const NONE:uint	= 0;
		static public const CEILING:uint= UP;
		static public const FLOOR:uint	= DOWN;
		static public const WALL:uint	= LEFT | RIGHT;
		static public const ANY:uint	= LEFT | RIGHT | UP | DOWN;
		static public const OVERLAP_BIAS:Number = 4;	
		
		
		
		static public function separateX(Object1:Entity, Object2:Entity):Boolean
		{
			//can't separate two immovable objects
			var obj1immovable:Boolean = Object1.immovable;
			var obj2immovable:Boolean = Object2.immovable;
			if(obj1immovable && obj2immovable)		return false;
			
			
			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = Object1.x - Object1.last.x;
			var obj2delta:Number = Object2.x - Object2.last.x;
		
			if(obj1delta != obj2delta)
			{
				//Check if the X hulls actually overlap
				var obj1deltaAbs:Number = (obj1delta > 0)?obj1delta:-obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0)?obj2delta:-obj2delta;
				var obj1rect:Rectangle = new Rectangle(Object1.x-((obj1delta > 0)?obj1delta:0),Object1.last.y,Object1.width+((obj1delta > 0)?obj1delta:-obj1delta),Object1.height);
				var obj2rect:Rectangle = new Rectangle(Object2.x-((obj2delta > 0)?obj2delta:0),Object2.last.y,Object2.width+((obj2delta > 0)?obj2delta:-obj2delta),Object2.height);
				if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
				{
					var maxOverlap:Number = obj1deltaAbs + obj2deltaAbs + OVERLAP_BIAS;
					
					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta)
					{
						overlap = Object1.x + Object1.width - Object2.x;
						if((overlap > maxOverlap) || !(Object1.allowCollisions & RIGHT) || !(Object2.allowCollisions & LEFT))
							overlap = 0;
							Object1.hitRight(overlap);
							Object2.hitLeft(overlap);
						
					}
					else if(obj1delta < obj2delta)
					{
						overlap = Object1.x - Object2.width - Object2.x;
						if((-overlap > maxOverlap) || !(Object1.allowCollisions & LEFT) || !(Object2.allowCollisions & RIGHT))
							overlap = 0;
							
							Object2.hitRight(overlap);
							Object1.hitLeft(overlap);
						
					}
				}
			}
			
			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap != 0)
			{
				var obj1v:Number = Object1.velocity.x;
				var obj2v:Number = Object2.velocity.x;
				
				if(!obj1immovable && !obj2immovable)
				{
					overlap *= 0.5;
					Object1.x = Object1.x - overlap;
					Object2.x += overlap;

					var obj1velocity:Number = Math.sqrt((obj2v * obj2v * Object2.mass)/Object1.mass) * ((obj2v > 0)?1:-1);
					var obj2velocity:Number = Math.sqrt((obj1v * obj1v * Object1.mass)/Object2.mass) * ((obj1v > 0)?1:-1);
					var average:Number = (obj1velocity + obj2velocity)*0.5;
					obj1velocity -= average;
					obj2velocity -= average;
					Object1.velocity.x = average + obj1velocity * Object1.elasticity;
					Object2.velocity.x = average + obj2velocity * Object2.elasticity;
				}
				else if(!obj1immovable)
				{
					Object1.x = Object1.x - overlap;
					Object1.velocity.x = obj2v - obj1v*Object1.elasticity;
				}
				else if(!obj2immovable)
				{
					Object2.x += overlap;
					Object2.velocity.x = obj1v - obj2v*Object2.elasticity;
				}
				return true;
			}
			else
				return false;
		}
		
	
		static public function separateY(Object1:Entity, Object2:Entity):Boolean
		{
			//can't separate two immovable objects
			var obj1immovable:Boolean = Object1.immovable;
			var obj2immovable:Boolean = Object2.immovable;
			if(obj1immovable && obj2immovable)	return false;
			
			
			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = Object1.y - Object1.last.y;
			var obj2delta:Number = Object2.y - Object2.last.y;
			if(obj1delta != obj2delta)
			{
				//Check if the Y hulls actually overlap
				var obj1deltaAbs:Number = (obj1delta > 0)?obj1delta:-obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0)?obj2delta:-obj2delta;
				var obj1rect:Rectangle = new Rectangle(Object1.x,Object1.y-((obj1delta > 0)?obj1delta:0),Object1.width,Object1.height+obj1deltaAbs);
				var obj2rect:Rectangle = new Rectangle(Object2.x,Object2.y-((obj2delta > 0)?obj2delta:0),Object2.width,Object2.height+obj2deltaAbs);
				if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
				{
					var maxOverlap:Number = obj1deltaAbs + obj2deltaAbs + OVERLAP_BIAS;
					
					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta)
					{
						
						
						overlap = Object1.y + Object1.height - Object2.y;
			
						Object1.hitBottom(overlap);
						Object2.hitTop(overlap);
						
						if((overlap > maxOverlap) || !(Object1.allowCollisions & DOWN) || !(Object2.allowCollisions & UP))
							overlap = 0;
						
					}
					else if(obj1delta < obj2delta)
					{
				
						
						
						overlap = Object1.y - Object2.height - Object2.y;
						if((-overlap > maxOverlap) || !(Object1.allowCollisions & UP) || !(Object2.allowCollisions & DOWN))
						
						overlap = 0;
						
						Object2.hitBottom(overlap);
						Object1.hitTop(overlap);
		
						
					}
				}
			}
			
			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap != 0)
			{
				var obj1v:Number = Object1.velocity.y;
				var obj2v:Number = Object2.velocity.y;
				
				if(!obj1immovable && !obj2immovable)
				{
					overlap *= 0.5;
					Object1.y = Object1.y - overlap;
					Object2.y += overlap;

					var obj1velocity:Number = Math.sqrt((obj2v * obj2v * Object2.mass)/Object1.mass) * ((obj2v > 0)?1:-1);
					var obj2velocity:Number = Math.sqrt((obj1v * obj1v * Object1.mass)/Object2.mass) * ((obj1v > 0)?1:-1);
					var average:Number = (obj1velocity + obj2velocity)*0.5;
					obj1velocity -= average;
					obj2velocity -= average;
					Object1.velocity.y = average + obj1velocity * Object1.elasticity;
					Object2.velocity.y = average + obj2velocity * Object2.elasticity;
				}
				else if(!obj1immovable)
				{
					Object1.y = Object1.y - overlap;
					Object1.velocity.y = obj2v - obj1v*Object1.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object2.active && Object2.moves && (obj1delta > obj2delta))
						Object1.x += Object2.x - Object2.last.x;
				}
				else if(!obj2immovable)
				{
					Object2.y += overlap;
					Object2.velocity.y = obj1v - obj2v*Object2.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object1.active && Object1.moves && (obj1delta < obj2delta))
						Object2.x += Object1.x - Object1.last.x;
				}
				return true;
			}
			else
				return false;
		}
		 static public function separate(Object1:Entity, Object2:Entity):Boolean
		{
			var separatedX:Boolean = separateX(Object1,Object2);
			var separatedY:Boolean = separateY(Object1,Object2);
			return separatedX || separatedY;
		}
		
        static public function computeVelocity(elapsed:Number,Velocity:Number, Acceleration:Number=0, Drag:Number=0, Max:Number=10000):Number
		{
			if(Acceleration != 0)
				Velocity += Acceleration*elapsed;
			else if(Drag != 0)
			{
				var drag:Number = Drag*elapsed;
				if(Velocity - drag > 0)
					Velocity = Velocity - drag;
				else if(Velocity + drag < 0)
					Velocity += drag;
				else
					Velocity = 0;
			}
			if((Velocity != 0) && (Max != 10000))
			{
				if(Velocity > Max)
					Velocity = Max;
				else if(Velocity < -Max)
					Velocity = -Max;
			}
			return Velocity;
		}
		
		 static public function  rotatePoint(X:Number, Y:Number, PivotX:Number, PivotY:Number, Angle:Number,P:Point=null):Point
		{
			if(P == null) P = new Point();
			var radians:Number = -Angle / 180 * Math.PI;
			var dx:Number = X-PivotX;
			var dy:Number = PivotY-Y;
			P.x = PivotX + Math.cos(radians)*dx - Math.sin(radians)*dy;
			P.y = PivotY - (Math.sin(radians)*dx + Math.cos(radians)*dy);
			return P;
		}
		
		
	}

}