package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.inventory.ItemDescription;
   import flash.utils.IDataInput;
   
   public class Parser_1051
   {
      
      public var cmdId:int;
      
      public var itemDes:Vector.<ItemDescription>;
      
      public function Parser_1051(param1:IDataInput)
      {
         var _loc8_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:uint = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:uint = 0;
         super();
         this.itemDes = new Vector.<ItemDescription>();
         this.cmdId = param1.readUnsignedInt();
         var _loc7_:int = int(param1.readUnsignedInt());
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc8_ = int(param1.readUnsignedInt());
            _loc4_ = param1.readShort();
            _loc3_ = param1.readUnsignedInt();
            if(_loc8_ == 12)
            {
               _loc4_ -= ActorManager.actorInfo.trainerScore;
            }
            this.itemDes.push(new ItemDescription(_loc8_,_loc4_,_loc3_));
            _loc9_++;
         }
         _loc7_ = int(param1.readUnsignedInt());
         _loc9_ = 0;
         while(_loc9_ < _loc7_)
         {
            this.itemDes.push(new ItemDescription(param1.readUnsignedInt(),1,param1.readUnsignedInt(),true));
            _loc9_++;
         }
         _loc7_ = int(param1.readUnsignedInt());
         _loc9_ = 0;
         while(_loc9_ < _loc7_)
         {
            _loc6_ = int(param1.readUnsignedInt());
            _loc5_ = param1.readShort();
            _loc2_ = param1.readUnsignedInt();
            this.itemDes.push(new ItemDescription(_loc6_,_loc5_,_loc2_,false,false));
            _loc9_++;
         }
      }
   }
}

