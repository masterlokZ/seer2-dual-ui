package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.processor.activity.sniper.SniperInfo;
   import flash.utils.IDataInput;
   
   public class Parser_1232
   {
      
      public var itemListVec:Vector.<SniperInfo>;
      
      public var myOrder:int = 0;
      
      public function Parser_1232(param1:IDataInput)
      {
         var _loc4_:SniperInfo = null;
         super();
         var _loc3_:uint = param1.readUnsignedInt();
         var _loc5_:uint = param1.readUnsignedInt();
         this.itemListVec = new Vector.<SniperInfo>();
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = new SniperInfo();
            _loc4_.userId = param1.readUnsignedInt();
            if(_loc4_.userId == ActorManager.actorInfo.id)
            {
               this.myOrder = _loc2_ + 1;
            }
            _loc4_.nick = param1.readUTFBytes(16);
            _loc4_.hurt = param1.readUnsignedInt();
            this.itemListVec.push(_loc4_);
            _loc2_++;
         }
      }
   }
}

