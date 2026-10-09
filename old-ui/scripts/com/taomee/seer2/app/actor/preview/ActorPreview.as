package com.taomee.seer2.app.actor.preview
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Expo;
   import com.taomee.seer2.app.actor.constant.EquipSlotDepth;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.util.ActorEquipAssembler;
   import com.taomee.seer2.app.component.EquipPreviewDisplayer;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.EquipItemDefinition;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class ActorPreview extends Sprite
   {
      
      private static var _currIndex:int;
      
      private static var _list:Vector.<EquipItemDefinition>;
      
      private static var _currIcon:IconDisplayer;
      
      private static var _playMC:MovieClip;
      
      private var _defaultColor:int;
      
      private var _previewVec:Vector.<EquipPreviewDisplayer>;
      
      public function ActorPreview()
      {
         super();
         this.initPreviewDisplayer();
      }
      
      public function setData(param1:UserInfo, param2:Boolean = true) : void
      {
         var _loc3_:EquipItem = null;
         this._defaultColor = param1.color;
         this.updatePreviewDisplayer(param1,param2);
         var _loc4_:Vector.<EquipItem> = param1.equipVec;
         for each(_loc3_ in param1.equipVec)
         {
            this.addEquip(_loc3_.referenceId);
         }
      }
      
      public function addEquip(param1:uint) : void
      {
         var _loc2_:EquipItem = new EquipItem(param1);
         this.addEquipInternal(_loc2_);
         if(_loc2_.hasAccessory)
         {
            this.addEquipInternal(_loc2_.getAccessory());
         }
      }
      
      public function addSuit(param1:uint, param2:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc4_:EquipPreviewDisplayer = null;
         var _loc3_:EquipItemDefinition = null;
         _list = ItemConfig.getSuitEquipList(param1);
         if(param2)
         {
            this.removeMove();
            _currIndex = 0;
            _loc5_ = 1;
            while(_loc5_ < 8)
            {
               _loc4_ = this.getDisplayer(_loc5_);
               if(_loc4_ != null && _loc4_.slotIndex != 3 && _loc4_.slotIndex != 4)
               {
                  _loc4_.visible = false;
               }
               _loc5_++;
            }
            if(_playMC == null)
            {
               _playMC = UIManager.getMovieClip("PREVIEW_PLAY");
            }
            _playMC.gotoAndStop(1);
            addChildAt(_playMC,numChildren - 1);
            this.move();
         }
         else
         {
            for each(_loc3_ in _list)
            {
               this.addEquip(_loc3_.id);
            }
         }
      }
      
      private function removeMove() : void
      {
         DisplayUtil.removeForParent(_playMC);
         if(_currIcon)
         {
            _currIcon.dispose();
            DisplayUtil.removeForParent(_currIcon);
            _currIcon = null;
         }
      }
      
      private function move() : void
      {
         if(_currIndex < _list.length)
         {
            _currIcon = new IconDisplayer();
            _currIcon.setIconUrl(ItemConfig.getItemIconUrl(_list[_currIndex].id),this.onComplete);
            if(_list[_currIndex].slotIndex == 7)
            {
               addChildAt(_currIcon,0);
            }
            else
            {
               addChild(_currIcon);
            }
         }
         else
         {
            this.removeMove();
         }
      }
      
      private function onComplete() : void
      {
         this.addEquip(_list[_currIndex].id);
         var _loc1_:EquipPreviewDisplayer = this.getDisplayer(_list[_currIndex].slotIndex);
         _loc1_.visible = false;
         switch(_list[_currIndex].slotIndex - 1)
         {
            case 0:
               _currIcon.x = -25;
               _currIcon.y = -300;
               TweenLite.to(_currIcon,0.3,{
                  "y":-180,
                  "ease":Expo.easeOut,
                  "onComplete":this.tweenComplete
               });
               break;
            case 1:
               _currIcon.x = 25;
               _currIcon.y = -110;
               TweenLite.to(_currIcon,0.3,{
                  "x":-100,
                  "ease":Expo.easeOut,
                  "onComplete":this.tweenComplete
               });
               break;
            case 2:
               _currIcon.y = 25;
               TweenLite.to(_currIcon,0.3,{
                  "y":-100,
                  "ease":Expo.easeOut,
                  "onComplete":this.tweenComplete
               });
               break;
            case 3:
               _currIcon.y = 25;
               TweenLite.to(_currIcon,0.3,{
                  "y":-100,
                  "ease":Expo.easeOut,
                  "onComplete":this.tweenComplete
               });
               break;
            case 4:
               _currIcon.x = 110;
               _currIcon.y = -100;
               TweenLite.to(_currIcon,0.3,{
                  "x":0,
                  "ease":Expo.easeOut,
                  "onComplete":this.tweenComplete
               });
               break;
            case 5:
               _currIcon.y = 300;
               TweenLite.to(_currIcon,0.3,{
                  "y":-60,
                  "ease":Expo.easeOut,
                  "onComplete":this.tweenComplete
               });
               break;
            case 6:
               _currIcon.x = -20;
               _currIcon.y = 25;
               TweenLite.to(_currIcon,0.3,{
                  "y":-110,
                  "ease":Expo.easeOut,
                  "onComplete":this.tweenComplete
               });
         }
      }
      
      private function tweenComplete() : void
      {
         var _loc1_:EquipPreviewDisplayer = this.getDisplayer(_list[_currIndex].slotIndex);
         _loc1_.visible = true;
         DisplayUtil.removeForParent(_currIcon);
         _playMC.gotoAndPlay(2);
         ++_currIndex;
         this.move();
      }
      
      public function removeEquip(param1:uint) : void
      {
         var _loc2_:EquipItem = new EquipItem(param1);
         var _loc3_:uint = ActorEquipAssembler.getSlotDefaultEquipReferenceId(this._defaultColor,_loc2_.slotIndex);
         if(param1 != _loc3_ && _loc3_ != 4294967295)
         {
            this.addEquip(_loc3_);
         }
         else
         {
            this.removeEquipInternal(_loc2_);
            if(_loc2_.hasAccessory)
            {
               this.removeEquipInternal(_loc2_.getAccessory());
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:EquipPreviewDisplayer = null;
         for each(_loc1_ in this._previewVec)
         {
            _loc1_.dispose();
         }
         this._previewVec = null;
      }
      
      private function addEquipInternal(param1:EquipItem) : void
      {
         if(param1.slotIndex == 9 && param1.suitId == 0)
         {
            return;
         }
         this.getPreviewDisplayer(param1.slotIndex).setEquipPreviewUrl(param1);
      }
      
      private function removeEquipInternal(param1:EquipItem) : void
      {
         this.getPreviewDisplayer(param1.slotIndex).setEquipPreviewUrl(null);
      }
      
      private function initPreviewDisplayer() : void
      {
         this._previewVec = new Vector.<EquipPreviewDisplayer>();
         for(var _loc1_:int = 1; _loc1_ <= 11; )
         {
            this._previewVec.push(new EquipPreviewDisplayer(_loc1_));
            _loc1_++;
         }
         this.addPreviewVec();
      }
      
      private function updatePreviewDisplayer(param1:UserInfo, param2:Boolean) : void
      {
         var _loc4_:int = int(this._previewVec.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            this._previewVec[_loc3_].updateUserInfo(param1,param2);
            _loc3_++;
         }
      }
      
      private function addPreviewVec() : void
      {
         this._previewVec.sort(this.sortBySlotDepth);
         var _loc2_:int = int(this._previewVec.length);
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            addChildAt(this._previewVec[_loc1_],_loc1_);
            _loc1_++;
         }
      }
      
      private function sortBySlotDepth(param1:EquipPreviewDisplayer, param2:EquipPreviewDisplayer) : int
      {
         var _loc4_:uint = uint(EquipSlotDepth.getDepthByDirection(param1.slotIndex,1));
         var _loc3_:uint = uint(EquipSlotDepth.getDepthByDirection(param2.slotIndex,1));
         if(_loc4_ < _loc3_)
         {
            return -1;
         }
         if(_loc4_ > _loc3_)
         {
            return 1;
         }
         return 0;
      }
      
      private function getPreviewDisplayer(param1:int) : EquipPreviewDisplayer
      {
         var _loc2_:EquipPreviewDisplayer = null;
         var _loc3_:EquipPreviewDisplayer = null;
         for each(_loc3_ in this._previewVec)
         {
            if(_loc3_.slotIndex == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getDisplayer(param1:int) : EquipPreviewDisplayer
      {
         var _loc2_:EquipPreviewDisplayer = null;
         var _loc3_:EquipPreviewDisplayer = null;
         for each(_loc3_ in this._previewVec)
         {
            if(_loc3_.slotIndex == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
   }
}

