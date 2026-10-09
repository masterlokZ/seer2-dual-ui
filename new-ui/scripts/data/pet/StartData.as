package data.pet
{
   public class StartData
   {
      
      public var urls:Vector.<String>;
      
      public var tips:Vector.<String>;
      
      public function StartData()
      {
         super();
      }
      
      public static function from(param1:Object) : StartData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:StartData = new StartData();
         _loc2_.urls = transString(param1.urls);
         _loc2_.tips = transString(param1.tips);
         return _loc2_;
      }
      
      public static function clone(param1:StartData) : StartData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:StartData = new StartData();
         _loc2_.urls = cloneString(param1.urls);
         _loc2_.tips = cloneString(param1.tips);
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

