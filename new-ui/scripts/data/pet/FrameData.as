package data.pet
{
   public class FrameData
   {
      
      public static const SMOOTH_TRUE:int = 1;
      
      public static const SMOOTH_FALSE:int = 2;
      
      public var data:ArenaData;
      
      public var move:MoveData;
      
      public var change:ChangeData;
      
      public var event:EventData;
      
      public var start:StartData;
      
      public var end:EndData;
      
      public var sleep:int;
      
      public var smooth:int;
      
      public var logs:Vector.<String>;
      
      public function FrameData()
      {
         super();
      }
      
      public static function from(param1:Object) : FrameData
      {
         var _loc2_:FrameData = new FrameData();
         _loc2_.data = ArenaData.from(param1.data);
         _loc2_.move = MoveData.from(param1.move);
         _loc2_.change = ChangeData.from(param1.change);
         _loc2_.event = EventData.from(param1.event);
         _loc2_.start = StartData.from(param1.start);
         _loc2_.end = EndData.from(param1.end);
         _loc2_.sleep = param1.sleep;
         _loc2_.smooth = param1.smooth;
         _loc2_.logs = transString(param1.logs);
         return _loc2_;
      }
      
      public static function clone(param1:FrameData) : FrameData
      {
         var _loc2_:FrameData = new FrameData();
         _loc2_.data = ArenaData.clone(param1.data);
         _loc2_.move = MoveData.clone(param1.move);
         _loc2_.change = ChangeData.clone(param1.change);
         _loc2_.event = EventData.clone(param1.event);
         _loc2_.start = StartData.clone(param1.start);
         _loc2_.end = EndData.clone(param1.end);
         _loc2_.sleep = param1.sleep;
         _loc2_.smooth = param1.smooth;
         _loc2_.logs = cloneString(param1.logs);
         return _loc2_;
      }
      
      private static function transString(param1:Array) : Vector.<String>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<String> = new Vector.<String>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function cloneString(param1:Vector.<String>) : Vector.<String>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<String> = new Vector.<String>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

