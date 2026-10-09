package com.taomee.seer2.app.actor.util
{
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import org.taomee.ds.HashMap;
   
   public class ActorEquipAssembler
   {
      
      public static const DEFAULT_BODY_REFERENCE_ID:uint = 100002;
      
      public static const DEFAULT_BOOY_RESOURCE_ID:uint = 100004;
      
      private static const COLOR_BLUE:uint = 0;
      
      private static const COLOR_GREEN:uint = 1;
      
      private static const COLOR_PURPLE:uint = 2;
      
      private static const COLOR_YELLOW:uint = 3;
      
      private static const COLOR_VIOLOET:uint = 4;
      
      private static const COLOR_ORANGE:uint = 5;
      
      private static const COLOR_RED:uint = 6;
      
      private static const COLOR_PINK:uint = 7;
      
      private static const COLOR_WHITE:uint = 8;
      
      private static const COLOR_BLACK:uint = 9;
      
      private static const COLOR_DEEPBLUE:uint = 10;
      
      private static const COLOR_BROWN:uint = 11;
      
      private static var _equipMap:HashMap;
      
      initialize();
      
      public function ActorEquipAssembler()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _equipMap = new HashMap();
         _equipMap.add(0,[100001,100003,100004,100005,100006]);
         _equipMap.add(1,[100001,100003,100007,100008,100009]);
         _equipMap.add(2,[100001,100003,100010,100011,100012]);
         _equipMap.add(3,[100001,100003,100013,100014,100015]);
         _equipMap.add(4,[100001,100003,100016,100017,100018]);
         _equipMap.add(5,[100001,100003,100019,100020,100021]);
         _equipMap.add(6,[100001,100003,100022,100023,100024]);
         _equipMap.add(7,[100001,100003,100025,100026,100027]);
         _equipMap.add(8,[100001,100003,100028,100029,100030]);
         _equipMap.add(9,[100001,100003,100031,100032,100033]);
         _equipMap.add(10,[100001,100003,100143,100144,100145]);
         _equipMap.add(11,[100001,100003,100146,100147,100148]);
      }
      
      public static function removeDefaultEquip(param1:uint, param2:Vector.<EquipItem>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = _equipMap.getValue(param1);
         _loc4_ = int(param2.length);
         var _loc3_:int = _loc4_ - 1;
         while(_loc3_ >= 0)
         {
            if(_loc5_.indexOf(param2[_loc3_].referenceId) != -1)
            {
               param2.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
      
      public static function mergeDefaultEquip(param1:uint, param2:Vector.<EquipItem>) : void
      {
         var _loc4_:EquipItem = null;
         var _loc7_:uint = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc9_:Array = _equipMap.getValue(param1);
         var _loc8_:int = int(_loc9_.length);
         var _loc5_:int = int(param2.length);
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc7_ = uint(_loc9_[_loc6_]);
            _loc3_ = 0;
            while(true)
            {
               if(_loc3_ >= _loc5_)
               {
                  param2.push(new EquipItem(_loc7_));
                  break;
               }
               _loc4_ = param2[_loc3_];
               if(_loc4_.slotIndex == EquipItem.getSlotIndexByReference(_loc7_))
               {
                  break;
               }
               _loc3_++;
            }
            _loc6_++;
         }
      }
      
      public static function isDefaultEquip(param1:int, param2:EquipItem) : Boolean
      {
         var _loc3_:uint = getSlotDefaultEquipReferenceId(param1,param2.slotIndex);
         if(_loc3_ == param2.referenceId)
         {
            return true;
         }
         return false;
      }
      
      public static function getSlotDefaultEquipReferenceId(param1:uint, param2:uint) : uint
      {
         var _loc3_:Array = _equipMap.getValue(param1);
         switch(int(param2) - 1)
         {
            case 0:
               return _loc3_[0];
            case 1:
               return _loc3_[2];
            case 3:
               return _loc3_[3];
            case 5:
               return _loc3_[4];
            case 7:
               return _loc3_[1];
            default:
               return 4294967295;
         }
      }
   }
}

