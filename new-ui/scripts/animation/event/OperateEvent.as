package animation.event
{
   import data.operate.OperateData;
   import flash.events.Event;
   
   public class OperateEvent extends Event
   {
      
      public static const OPERATE_END:String = "operateEnd";
      
      public static const SUNDRIES:String = "sundries";
      
      public var data:OperateData;
      
      public function OperateEvent(param1:String)
      {
         super(param1,true,true);
         this.data = new OperateData();
      }
      
      public static function skill(param1:int) : OperateEvent
      {
         var _loc2_:OperateEvent = new OperateEvent("operateEnd");
         _loc2_.data.skill = param1;
         return _loc2_;
      }
      
      public static function pet(param1:int) : OperateEvent
      {
         var _loc2_:OperateEvent = new OperateEvent("operateEnd");
         _loc2_.data.pet = param1;
         return _loc2_;
      }
      
      public static function item(param1:int) : OperateEvent
      {
         var _loc2_:OperateEvent = new OperateEvent("operateEnd");
         _loc2_.data.item = param1;
         return _loc2_;
      }
      
      public static function capsule(param1:int) : OperateEvent
      {
         var _loc2_:OperateEvent = new OperateEvent("operateEnd");
         _loc2_.data.capsule = param1;
         return _loc2_;
      }
      
      public static function escape(param1:int) : OperateEvent
      {
         var _loc2_:OperateEvent = new OperateEvent("operateEnd");
         _loc2_.data.escape = param1;
         return _loc2_;
      }
      
      public static function changeUI() : OperateEvent
      {
         var _loc1_:OperateEvent = new OperateEvent("sundries");
         _loc1_.data.functional = 1;
         return _loc1_;
      }
      
      public static function autoFight() : OperateEvent
      {
         var _loc1_:OperateEvent = new OperateEvent("sundries");
         _loc1_.data.functional = 2;
         return _loc1_;
      }
      
      public static function setting() : OperateEvent
      {
         var _loc1_:OperateEvent = new OperateEvent("sundries");
         _loc1_.data.functional = 3;
         return _loc1_;
      }
   }
}

