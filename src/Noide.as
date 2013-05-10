package  
{
	/**
	 * ...
	 * @author djoker
	 */
	public class Noide extends GameState
	{
		
		


		public var ball:Entity;
		public var bat:Entity;
		public var walls1:Entity;
		public var walls2:Entity;
		public var walls3:Entity;
		public var walls4:Entity;
		
		

		

		
		public var briks:Array = new Array();
		
		

		
		
		public function createbrisks(countx:int, county:int):void
		{
			for (var y:int = 0; y < county; y++)
			{
			for (var x:int = 0; x < countx; x++)
			{
			  var brik:Entity = new Entity(50+x*40,20+ y*20);
			  brik.immovable = true;
			  brik.createRect(35, 15, 0xFF00ff);
			  brik.type = "Brick";
			  add(brik);
			}
		   }
		}
		

		
		
		override public function show():void
		{
		   walls1 = new Entity(0, 0);
		   walls1.createRect(640, 10,0xaaaaaa);
		   walls1.immovable = true;
		   add(walls1);
		   
		   walls2 = new Entity(0, 390);
		   walls2.createRect(640, 10,0xaaaaaa);
		   walls2.immovable = true;
		   add(walls2);
		   
		   walls3 = new Entity(0, 0);
		   walls3.createRect(10, 400,0xaaaaaa);
		   walls3.immovable = true;
		   add(walls3);
		  
		   walls4 = new Entity(630, 0);
		   walls4.createRect(10, 400,0xaaaaaa);
		   walls4.immovable = true;
		   add(walls4);
		  
		   
		   createbrisks(14, 6);
		  ball = new Entity(220, 200);
		  ball.CreateCircle(6, 0xFFFF00);
		  ball.elasticity = 1;
		  ball.maxVelocity.x = 200;
		  ball.maxVelocity.y = 200;
		  ball.velocity.x = 20;
		  ball.velocity.y = 200;

		  add(ball);
		
		  
		  bat = new Entity(200, 300);
		  bat.createRect(40, 10, 0xffffff);
		  bat.immovable = true;	
		  add(bat);		

		 
		  
			
		}
		
		override public function update(dt:Number):void
		{
		
	
				bat.velocity.x = 0;
		
			if (KeyDown(LEFT) && bat.x>0 )
			{
				bat.velocity.x = -300;
				
			} else	if (KeyDown(RIGHT) && bat.x < 640-40)
			{
				bat.velocity.x = 300;
			}
			
			if (ball.Colide(bat))
			{	
             var batmid:int = bat.x +20;
             var ballmid:int = ball.x +3;
             var diff:int;
             if (ballmid < batmid)
              {
               diff = batmid - ballmid;
               ball.velocity.x = ( -10 * diff);
             }
             else if (ballmid > batmid)
             {
             diff = ballmid-batmid ;
             ball.velocity.x = ( 10 * diff);
	         }
            else
            {
             ball.velocity.x = 2 + int(Math.random() * 8);	
            }	
			}
			
			
			ball.Colide(walls1);
			ball.Colide(walls2);
			ball.Colide(walls3);
			ball.Colide(walls4);
			
			var spr:Entity = ball.ColideWith("Brick");
			if (spr)
			{
			spr.Kill();
			}
			
			
		}
				
			
		
	}

}