package  
{
	
		
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author djoker
	 */
	public class Entity extends MovieClip 
	{
		
		
		
		
			static protected const _pZero:Point = new Point();
			
		public var active:Boolean;
		public var alive:Boolean;
		public var onFloor:Boolean;
		
		public var state:GameState;
    	public var immovable:Boolean;
		public var velocity:Point;
		public var mass:Number;
		public var elasticity:Number;
		public var acceleration:Point;
		public var drag:Point;
		public var maxVelocity:Point;
		public var angle:Number;
		public var angularVelocity:Number;
		public var angularAcceleration:Number;
		public var angularDrag:Number;
		public var maxAngular:Number;
		public var moves:Boolean;	
		public var colOffsets:Array;
		public var allowCollisions:uint;
		public var last:Point;
		public var Bound:Rectangle;
		public var type:String;
		public var layer:int;
		
		

		
		public function Entity(X:Number, Y:Number) 
		{
			super();
			this.x = X; this.y = Y;
			
			last = new Point(X,Y);
			
			mass = 1.0;
			elasticity = 0.0;

			immovable = false;
			moves = true;
			
			allowCollisions = Utils.ANY;
			
			velocity = new Point();
			acceleration = new Point();
			drag = new Point();
			maxVelocity = new Point(10000, 10000);
			
		
			active = true;
			visible = true;
			alive = true;
			
			angle = 0;
			angularVelocity = 0;
			angularAcceleration = 0;
			angularDrag = 0;
			maxAngular = 10000;
		    colOffsets = new Array(new Point());
			
			Bound = new Rectangle(x, y, this.width, this.height);
			
			type=getQualifiedClassName(this);

	
		}
		
		public function CreateCircle(r:Number, color:int):void
		{
		   
		      graphics.beginFill(color, 1);
  	          graphics.drawCircle(-r/2,-r/2,r);
              graphics.endFill(  );	
			  this.width  = -r / 2;
			  this.height = -r / 2;
			  Bound.width = this.width;
			  Bound.height= this.height;
			
		}

		
		public function createRect(w:int,h:int, color:int):void
		{
		      graphics.beginFill(color, 1);
  	          graphics.drawRect(0, 0, w , h );
              graphics.endFill(  );		
			  this.width  = w;
			  this.height = h;		
			  Bound.width = this.width;
			  Bound.height= this.height;
		}

		public function removed():void { }
		public function added():void { }
	
	
		
		public function update(elapsed:Number)
		{
			last.x = x;
			last.y = y;
			
			onFloor = false;
			
		    var delta:Number;
			var velocityDelta:Number;

			velocityDelta = (Utils.computeVelocity(elapsed,angularVelocity,angularAcceleration,angularDrag,maxAngular) - angularVelocity)/2;
			angularVelocity += velocityDelta; 
			angle += angularVelocity*elapsed;
			angularVelocity += velocityDelta;
			
			velocityDelta = (Utils.computeVelocity(elapsed,velocity.x,acceleration.x,drag.x,maxVelocity.x) - velocity.x)/2;
			velocity.x += velocityDelta;
			delta = velocity.x*elapsed;
			velocity.x += velocityDelta;
			x += delta;
			
			velocityDelta = (Utils.computeVelocity(elapsed,velocity.y,acceleration.y,drag.y,maxVelocity.y) - velocity.y)/2;
			velocity.y += velocityDelta;
			delta = velocity.y*elapsed;
			velocity.y += velocityDelta;
			y += delta;
			Bound.x = x;
			Bound.y = y;
		
		}
		
		public function ColideWith(type:String):Entity
		{
		
			
			
			var allEnitiesOfType:Vector.<Entity> = state.getType(type);
			if (!allEnitiesOfType) return null;
			var numEnities:int = allEnitiesOfType.length;
			if (!numEnities) return null;
			
			for (var i:int = 0; i < numEnities; i++) 
			{
				var currentEntity:Entity = allEnitiesOfType[i];
				if ((currentEntity!=null) || currentEntity.active || currentEntity.alive)
				{
				   if (Colide(currentEntity))
				  {return currentEntity }
				}
				
			}
			return null;
		}
		
		public function Kill():void
		{
		active = false;
		alive = false;
		state.remove(this);
		}
		
		
		public function Colide(obj:Entity):Boolean
		{
			    if (Bound.intersects(obj.Bound))
			    {
				return Utils.separate(this, obj);
				
				} else return false;
			
		}
		
		public function hitTop(v:Number):void
		{
			//if(!immovable)
			//	velocity.y = v;
		}
		

		public function hitBottom(v:Number):void
		{
			onFloor = true;
		//	if(!immovable)
			///	velocity.y = v;
		}
		public function hitLeft(Velocity:Number):void
		{
			//if(!immovable)
			//	velocity.x = Velocity;
		}
		

		public function hitRight(Velocity:Number):void
		{
		//	hitLeft(Velocity);
		}
		
		public function getsolid():Boolean
		
		{
			return (allowCollisions & Utils.ANY) > Utils.NONE;
		}
	
		public function setsolid(Solid:Boolean):void
		{
			if(Solid)
				allowCollisions = Utils.ANY;
			else
				allowCollisions = Utils.NONE;
		}
		
	}

}