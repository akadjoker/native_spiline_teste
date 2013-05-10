package  
{
	
	  import flash.display.Sprite;
	  import flash.utils.Dictionary;
	  import flash.events.*;
	  import flash.events.TimerEvent;
			
	/**
	 * ...
	 * @author djoker
	 */
	public class GameState extends Sprite
	{
		protected var _lookup:Object;
		protected var _map:Array;
		protected const _t:uint = 256;
		
		public  const DEG:Number = -180 / Math.PI;
		public  const RAD:Number = Math.PI / -180;
		private var _allEntities:Dictionary;

	    private var _active:Boolean;
		private var _disposeEntities:Boolean;
		
		public function GameState()
		{
			_allEntities = new Dictionary();
			_disposeEntities = true;
			_active = true;	
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//BASIC STORAGE & TRACKING			
			var i:uint = 0;
			_lookup = new Object();
			_map = new Array(_t);
			
			//LETTERS
			for(i = 65; i <= 90; i++)
				addKey(String.fromCharCode(i),i);
			
			//NUMBERS
			i = 48;
			addKey("ZERO",i++);
			addKey("ONE",i++);
			addKey("TWO",i++);
			addKey("THREE",i++);
			addKey("FOUR",i++);
			addKey("FIVE",i++);
			addKey("SIX",i++);
			addKey("SEVEN",i++);
			addKey("EIGHT",i++);
			addKey("NINE",i++);
			
			//FUNCTION KEYS
			for(i = 1; i <= 12; i++)
				addKey("F"+i,111+i);
			
			//SPECIAL KEYS + PUNCTUATION
			addKey("ESCAPE",27);
			addKey("MINUS",189);
			addKey("PLUS",187);
			addKey("DELETE",46);
			addKey("BACKSPACE",8);
			addKey("LBRACKET",219);
			addKey("RBRACKET",221);
			addKey("BACKSLASH",220);
			addKey("CAPSLOCK",20);
			addKey("SEMICOLON",186);
			addKey("QUOTE",222);
			addKey("ENTER",13);
			addKey("SHIFT",16);
			addKey("COMMA",188);
			addKey("PERIOD",190);
			addKey("SLASH",191);
			addKey("CONTROL",17);
			addKey("ALT",18);
			addKey("SPACE",32);
			addKey("UP",38);
			addKey("DOWN",40);
			addKey("LEFT",37);
			addKey("RIGHT", 39);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
	        stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		
		public function show():void
		{
			
		
		}
		public function hide():void
		{
		_allEntities = null;
		this.removeAll(true);
		removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		
		public function update(dt:Number):void
		{}
		
		///**********************************************
		
		public function add(sprt:Entity):void
		{
			//if (!_active) return;
			sprt.state = this;
			sprt.added();
			addChildAt(sprt, sprt.layer);
			addEntityToLookUp(sprt);
		}
		

		


		
		public function remove(entity:Entity):void
		{
           if (!_active) return;
		    entity.removed();
			removeFromObjectLookup(entity);
			removeChild(entity);
			entity.state = null;
		}
		
		public function removeAll(dispose:Boolean = true):void
		{
		//	if (!_active) return;
			_disposeEntities = dispose;
			var entity:Entity;
			for each (var entities:Vector.<Entity> in _allEntities) 
			{
				var numEntities:int = entities.length;
				for (var i:int = 0; i < numEntities; i++) 
				{
					entity = entities[i];
					remove(entity);
				}
			}
		}
		
		public function getType(type:String):Vector.<Entity>
		{
			return _allEntities[type];
		}
		
		
		public function Colide():void
		{
			
			var numEntities:int = this.numChildren;
			for (var i:int = 0; i < numEntities; i++) 
				{
					for (var j:int = i+1; j < numEntities; j++) 
					{
					var a:Entity = Entity(this.getChildAt(i));
					var b:Entity = Entity(this.getChildAt(j));
		
					if (a != b )
					{
						if (a.Bound.intersects(b.Bound))
						{
					       Utils.separate(a, b);
						   Utils.separate(b, a);
						}
					}	
					}
				}
			
		}
		
		private function updateEntities(dt:Number):void 
		{
			
			var numEntities:int = this.numChildren;
			for (var i:int = 0; i < numEntities; i++) 
				{
					var entity:Entity= Entity(this.getChildAt(i));
					if (entity.active && entity.alive)
					entity.update(dt);
					if (entity.alive == false)
					{
					remove(entity);
					
					}
				}
			
		
		}
		
		
		private function addEntityToLookUp(entity:Entity):void
		{
			//if (!_active) return;
			var entityTypeArray:Vector.<Entity> = getType(entity.type);
			if (entityTypeArray == null || entityTypeArray.length == 0) 
			{
				entityTypeArray = new Vector.<Entity>();
			}
			entityTypeArray.push(entity);
			_allEntities[entity.type] = entityTypeArray;
		}
		
		private function removeFromObjectLookup(entity:Entity):void
		{
		//	if (!_active) return;
			var entityTypeArray:Vector.<Entity> = this.getType(entity.type);
			var index:int = entityTypeArray.indexOf(entity);
			entityTypeArray.splice(index, 1);
			if (entityTypeArray.length == 0) 
			{
				entityTypeArray = null;
			}
		}

		
		
		
		 public function Update(dt:Number):void
		{
			    updatekeyboard();
		        update(dt);
				updateEntities(dt);
			
		}
		
         public function updatekeyboard():void
		{
			for(var i:uint = 0; i < _t; i++)
			{
				if(_map[i] == null) continue;
				var o:Object = _map[i];
				if((o.last == -1) && (o.current == -1)) o.current = 0;
				else if((o.last == 2) && (o.current == 2)) o.current = 1;
				o.last = o.current;
			}
		}
		
		/**
		 * Resets all the keys.
		 */
		public function resetkeyboard():void
		{
			for(var i:uint = 0; i < _t; i++)
			{
				if(_map[i] == null) continue;
				var o:Object = _map[i];
				this[o.name] = false;
				o.current = 0;
				o.last = 0;
			}
		}
		

		public function pressed(Key:String):Boolean { return this[Key]; }
		

		public function justPressed(Key:String):Boolean { return _map[_lookup[Key]].current == 2; }
		

		public function justReleased(Key:String):Boolean { return _map[_lookup[Key]].current == -1; }
		

		public function handleKeyDown(event:KeyboardEvent):void
		{
			var o:Object = _map[event.keyCode];
			if(o == null) return;
			if(o.current > 0) o.current = 1;
			else o.current = 2;
			this[o.name] = true;
		}
		
			public function handleKeyUp(event:KeyboardEvent):void
		{
			var o:Object = _map[event.keyCode];
			if(o == null) return;
			if(o.current > 0) o.current = -1;
			else o.current = 0;
			this[o.name] = false;
		}
		
			protected function addKey(KeyName:String,KeyCode:uint):void
		{
			_lookup[KeyName] = KeyCode;
			_map[KeyCode] = { name: KeyName, current: 0, last: 0 };
		}

		
		public  function rand(min:int, max:int):int {
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}
		
		public var ESCAPE:Boolean;
		public var F1:Boolean;
		public var F2:Boolean;
		public var F3:Boolean;
		public var F4:Boolean;
		public var F5:Boolean;
		public var F6:Boolean;
		public var F7:Boolean;
		public var F8:Boolean;
		public var F9:Boolean;
		public var F10:Boolean;
		public var F11:Boolean;
		public var F12:Boolean;
		public var ONE:Boolean;
		public var TWO:Boolean;
		public var THREE:Boolean;
		public var FOUR:Boolean;
		public var FIVE:Boolean;
		public var SIX:Boolean;
		public var SEVEN:Boolean;
		public var EIGHT:Boolean;
		public var NINE:Boolean;
		public var ZERO:Boolean;
		public var MINUS:Boolean;
		public var PLUS:Boolean;
		public var DELETE:Boolean;
		public var BACKSPACE:Boolean;
		public var Q:Boolean;
		public var W:Boolean;
		public var E:Boolean;
		public var R:Boolean;
		public var T:Boolean;
		public var Y:Boolean;
		public var U:Boolean;
		public var I:Boolean;
		public var O:Boolean;
		public var P:Boolean;
		public var LBRACKET:Boolean;
		public var RBRACKET:Boolean;
		public var BACKSLASH:Boolean;
		public var CAPSLOCK:Boolean;
		public var A:Boolean;
		public var S:Boolean;
		public var D:Boolean;
		public var F:Boolean;
		public var G:Boolean;
		public var H:Boolean;
		public var J:Boolean;
		public var K:Boolean;
		public var L:Boolean;
		public var SEMICOLON:Boolean;
		public var QUOTE:Boolean;
		public var ENTER:Boolean;
		public var SHIFT:Boolean;
		public var Z:Boolean;
		public var X:Boolean;
		public var C:Boolean;
		public var V:Boolean;
		public var B:Boolean;
		public var N:Boolean;
		public var M:Boolean;
		public var COMMA:Boolean;
		public var PERIOD:Boolean;
		public var SLASH:Boolean;
		public var CONTROL:Boolean;
		public var ALT:Boolean;
		public var SPACE:Boolean;
		public var UP:Boolean;
		public var DOWN:Boolean;
		public var LEFT:Boolean;
		public var RIGHT:Boolean;
		
		
	}

}