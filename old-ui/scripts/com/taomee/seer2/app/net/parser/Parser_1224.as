package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.MatchingConfig;
   import com.taomee.seer2.app.config.item.EquipItemDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import flash.utils.IDataInput;
   
   public class Parser_1224
   {
      
      public var itemId:uint;
      
      public var itemCount:uint;
      
      public var outMi:uint;
      
      public var currMi:uint;
      
      public var twoOutMi:uint;
      
      public var twoCurrMi:uint;
      
      public var jifen:uint;
      
      public var prevId:uint;
      
      public function Parser_1224(param1:IDataInput, param2:uint, param3:uint, param4:uint)
      {
         var _loc6_:Array = null;
         var _loc9_:uint = 0;
         var _loc8_:Vector.<EquipItemDefinition> = null;
         var _loc13_:int = 0;
         var _loc10_:EquipItemDefinition = null;
         var _loc11_:int = 0;
         super();
         this.prevId = param4;
         this.itemId = param1.readUnsignedInt();
         this.itemCount = param1.readUnsignedInt();
         this.outMi = param1.readUnsignedInt();
         this.currMi = param1.readUnsignedInt();
         this.twoOutMi = param1.readUnsignedInt();
         this.twoCurrMi = param1.readUnsignedInt();
         this.jifen = param1.readUnsignedInt();
         var _loc7_:Array = MatchingConfig.getEntry(param2).split("|");
         var _loc5_:SpecialInfo = new SpecialInfo(0);
         var _loc12_:LittleEndianByteArray = new LittleEndianByteArray();
         if(uint(String(_loc7_[_loc13_]).split(",")[0]) > 1000)
         {
            _loc12_.writeUnsignedInt(_loc7_.length);
         }
         _loc13_ = 0;
         while(_loc13_ < _loc7_.length)
         {
            _loc6_ = String(_loc7_[_loc13_]).split(",");
            _loc9_ = 1;
            if(_loc6_.length > 1)
            {
               _loc9_ = uint(_loc6_[1]);
            }
            if(uint(_loc6_[0]) < 1000)
            {
               _loc8_ = ItemConfig.getSuitEquipList(uint(_loc6_[0]));
               _loc12_.writeUnsignedInt(_loc8_.length);
               for each(_loc10_ in _loc8_)
               {
                  ItemManager.addItem(_loc10_.id,1,0);
                  _loc12_.writeUnsignedInt(_loc10_.id);
               }
            }
            else
            {
               _loc12_.writeUnsignedInt(uint(_loc6_[0]));
               _loc11_ = 0;
               while(_loc11_ < param3)
               {
                  ItemManager.addItem(uint(_loc6_[0]),_loc9_,0);
                  if(ItemConfig.getItemCategory(uint(_loc6_[0])) == 8)
                  {
                     AlertManager.showGetPetSpiritAlert(uint(_loc6_[0]),_loc9_);
                  }
                  _loc11_++;
               }
               if(param3 > 0)
               {
                  ServerMessager.addMessage("购买成功");
               }
            }
            _loc13_++;
         }
         _loc5_.data = _loc12_;
      }
   }
}

