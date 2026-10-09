package com.taomee.seer2.app.actor.data
{
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import flash.net.SharedObject;
   
   public class CookieUserInfo
   {
      
      private static const USERACCOUT:String = "userAccount";
      
      public var loginAccount:String;
      
      public var id:uint;
      
      public var nick:String;
      
      public var color:uint;
      
      public var equipReferenceIdArr:Array;
      
      public function CookieUserInfo(param1:String, param2:uint, param3:String, param4:uint, param5:Array)
      {
         super();
         this.loginAccount = param1;
         this.id = param2;
         this.nick = param3;
         this.color = param4;
         this.equipReferenceIdArr = param5;
      }
      
      public static function deserialize(param1:uint) : CookieUserInfo
      {
         var _loc2_:Object = getCookieObj(param1,getCookieInfoVec());
         if(_loc2_ != null)
         {
            return new CookieUserInfo(_loc2_.loginAccount,_loc2_.account,_loc2_.nick,_loc2_.color,_loc2_.equipReferenceIdArr);
         }
         return null;
      }
      
      public static function serialize(param1:UserInfo) : void
      {
         var _loc6_:EquipItem = null;
         var _loc5_:SharedObject = null;
         var _loc3_:Array = null;
         var _loc2_:Object = null;
         var _loc4_:Array = [];
         for each(_loc6_ in param1.equipVec)
         {
            _loc4_.push(_loc6_.referenceId);
         }
         _loc5_ = SharedObjectManager.getCommonSharedObject("login");
         _loc3_ = getCookieInfoVec();
         _loc2_ = getCookieObj(param1.id,_loc3_);
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.account = param1.id;
         _loc2_.nick = param1.nick;
         _loc2_.color = param1.color;
         _loc2_.equipReferenceIdArr = _loc4_;
         _loc5_.data["userAccount"] = _loc3_;
         SharedObjectManager.flush(_loc5_);
      }
      
      private static function getCookieInfoVec() : Array
      {
         var _loc1_:SharedObject = SharedObjectManager.getCommonSharedObject("login");
         return _loc1_.data["userAccount"];
      }
      
      private static function getCookieObj(param1:uint, param2:Array) : Object
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param2)
         {
            if(_loc3_.uid == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

