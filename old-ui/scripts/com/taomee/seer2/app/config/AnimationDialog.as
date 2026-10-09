package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.AnimationBaseInfo;
   import com.taomee.seer2.app.config.info.AnimationInfo;
   import org.taomee.ds.HashMap;
   
   public class AnimationDialog
   {
      
      private static var _xmlClass:Class = AnimationDialog__xmlClass;
      
      private static var _list:HashMap = new HashMap();
      
      initlize();
      
      public function AnimationDialog()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc7_:AnimationInfo = null;
         var _loc6_:XML = null;
         var _loc2_:XMLList = null;
         var _loc1_:AnimationBaseInfo = null;
         var _loc3_:XML = null;
         var _loc5_:XML = XML(new _xmlClass());
         var _loc4_:XMLList = _loc5_.child("dialog");
         for each(_loc6_ in _loc4_)
         {
            _loc7_ = new AnimationInfo();
            _loc7_.id = uint(_loc6_.@id);
            _loc7_.list = Vector.<AnimationBaseInfo>([]);
            _loc2_ = _loc6_.descendants("item");
            for each(_loc3_ in _loc2_)
            {
               _loc1_ = new AnimationBaseInfo();
               _loc1_.content = String(_loc3_.@content);
               _loc1_.select1 = String(_loc3_.@select1);
               _loc1_.select2 = String(_loc3_.@select2);
               _loc1_.yesIndex = int(_loc3_.@yesIndex);
               _loc7_.list.push(_loc1_);
            }
            _list.add(_loc7_.id,_loc7_);
         }
      }
      
      public static function getInfo(param1:uint) : AnimationInfo
      {
         if(_list.containsKey(param1))
         {
            return _list.getValue(param1);
         }
         return null;
      }
      
      public static function getList() : Vector.<AnimationInfo>
      {
         return Vector.<AnimationInfo>(_list.getValues());
      }
   }
}

