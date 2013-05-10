package  
{
	/**
	 * ...
	 * @author djoker
	 */
	public class Plataforma extends GameState
	{
		
		public var walls1:Entity;
		public var walls2:Entity;
		public var walls3:Entity;
		public var walls4:Entity;
		public var player:Entity;
		public var Elevator:Entity;
		public var Pucher:Entity;
		public var _y:int;
		public var _height:int;
		protected var _x:int;
		protected var _width:int;
		
		
		public function createbrisks(count:int):void
		{
			for (var y:int = 0; y < count; y++)
			{
			  var brik:Entity = new Entity(rand(50,600),rand(60,340));
			  brik.immovable = false;
			  brik.createRect(15, 15, 0xFF00ff);
			  brik.acceleration.y = 400;
			  brik.drag.x = 200;
			  brik.type = "Brick";
			  add(brik);
			}
		   
		}
		
		override public function show():void
		{
		
		   walls1 = new Entity(0, 0);
		   walls1.createRect(640, 10,0xaaaaaa);
		   walls1.immovable = true;
		   walls1.type = "solid";
		   add(walls1);
		   
		   walls2 = new Entity(0, 390);
		   walls2.createRect(640, 10,0xaaaaaa);
		   walls2.immovable = true;
		   walls2.type = "solid";
		   add(walls2);
		   
		   walls3 = new Entity(0, 0);
		   walls3.createRect(10, 400,0xaaaaaa);
		   walls3.immovable = true;
		   walls3.type = "solid";
		   add(walls3);
		  
		   walls4 = new Entity(630, 0);
		   walls4.createRect(10, 400,0xaaaaaa);
		   walls4.immovable = true;
		   walls4.type = "solid";
		   add(walls4);
		   
		   Pucher = new Entity(408, 370);
		   _x = 408;
		   _width = 100;
		   Pucher.immovable = true;
		   Pucher.createRect(20, 20,0xaaFFaa);
		   Pucher.velocity.x = 40;
		   add(Pucher);
		   
		   Elevator = new Entity(408, 240);
		   _y = 240;
		   _height = 120;
		   Elevator.createRect(80, 10,0xaaaaaa);
		   Elevator.immovable = true;
		   Elevator.velocity.y = 40;
		   Elevator.type = "solid";
		   add(Elevator);
		   
		   createbrisks(20);
		   
		   
		    player = new Entity(200, 100);
			player.createRect(10, 40, 0xffaaff);
			player.maxVelocity.x = 100;			//walking speed
			player.acceleration.y = 400;			//gravity
			player.drag.x = player.maxVelocity.x * 4;		//deceleration (sliding to a stop)
			
			

			
			add(player);

			
		}
		override public function update(dt:Number):void
		{
			
			this.Colide();
			
			player.acceleration.x = 0;
			
			
			
			if(UP && player.onFloor)
				{
					player.velocity.y = -player.acceleration.y * 0.51;
					

					
				}
			if(LEFT)
				player.acceleration.x -= player.drag.x;
			if(RIGHT)
				player.acceleration.x += player.drag.x;
				
				

			if(Elevator.y > _y + _height)
			{
				Elevator.y = _y + _height;
				Elevator.velocity.y = -Elevator.velocity.y;
			}
			else if(Elevator.y < _y)
			{
				Elevator.y = _y; 
				Elevator.velocity.y = -Elevator.velocity.y;
			}


				//Turn around if necessary
			if(Pucher.x > _x + _width)
			{
				Pucher.x = _x + _width;
				Pucher.velocity.x = -Pucher.velocity.x;
			}
			else if(Pucher.x < _x)
			{
				Pucher.x = _x;
				Pucher.velocity.x = -Pucher.velocity.x;
			}

				
			
			
			
			if (player.onFloor) trace("onfloor"); else trace("onair");
			
			//	if (player.onFloor )
		//	trace("on floor") else trace(" air");
		
			
			
		}
		
		
	}

}