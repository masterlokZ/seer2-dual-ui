package com.taomee.seer2.app.actor.equip
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.core.animation.FramePlayer;
   import com.taomee.seer2.core.animation.frame.FrameSequence;
   import com.taomee.seer2.core.animation.frame.FrameSequenceManager;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.utils.ByteArray;
   
   public class EquipPlayer extends FramePlayer
   {
      
      private var _equipItem:EquipItem;
      
      private var _newFrameSequence:FrameSequence;
      
      private var _actorInfo:UserInfo;
      
      public function EquipPlayer(param1:EquipItem, param2:UserInfo)
      {
         this._actorInfo = param2;
         this._equipItem = param1;
         super(param1.swfUrl);
      }
      
      override protected function initFrameSequence() : void
      {
         var _loc2_:ByteArray = null;
         var _loc1_:FrameSequence = null;
         switch(int(this._equipItem.slotIndex) - 1)
         {
            case 0:
               _loc2_ = UIManager.getByteArray("UI_DEFAULT_HEAD");
               break;
            case 1:
               _loc2_ = UIManager.getByteArray(this._actorInfo.sex == 0 ? "UI_BLUE_RGIHT_HAND" : "UI_RED_RGIHT_HAND");
               break;
            case 3:
               _loc2_ = UIManager.getByteArray(this._actorInfo.sex == 0 ? "UI_BLUE_BODY" : "UI_RED_BODY");
               break;
            case 5:
               _loc2_ = UIManager.getByteArray(this._actorInfo.sex == 0 ? "UI_BLUE_RGIHT_FOOT" : "UI_RED_RGIHT_FOOT");
               break;
            case 7:
               _loc2_ = UIManager.getByteArray("UI_DEFAULT_EYE");
               break;
            case 8:
               _loc2_ = UIManager.getByteArray(this._actorInfo.sex == 0 ? "UI_BLUE_LEFT_FOOT" : "UI_RED_LEFT_FOOT");
               break;
            case 9:
               _loc2_ = UIManager.getByteArray(this._actorInfo.sex == 0 ? "UI_BLUE_LEFT_HAND" : "UI_RED_LEFT_HAND");
         }
         if(_loc2_)
         {
            _loc1_ = new FrameSequence();
            _loc1_.isFromPool = false;
            _loc1_.setData(_loc2_);
            this.frameSequence = _loc1_;
            this._newFrameSequence = FrameSequenceManager.getFrameSequence(this.resourceUrl,"equip");
         }
         else
         {
            this.frameSequence = FrameSequenceManager.getFrameSequence(this._equipItem.swfUrl,"equip");
         }
      }
      
      public function updateEquip(param1:EquipItem) : void
      {
         this._equipItem = param1;
         this._newFrameSequence = FrameSequenceManager.getFrameSequence(this._equipItem.swfUrl,"equip");
      }
      
      override public function update() : void
      {
         super.update();
         if(Boolean(this._newFrameSequence) && this._newFrameSequence.isReady)
         {
            this.applyNewFrameSequence();
         }
      }
      
      private function applyNewFrameSequence() : void
      {
         releaseFrameSequence();
         this.frameSequence = this._newFrameSequence;
         this._newFrameSequence = null;
      }
      
      public function get slotIndex() : uint
      {
         return this._equipItem.slotIndex;
      }
      
      public function clear() : void
      {
         releaseFrameSequence();
      }
   }
}

