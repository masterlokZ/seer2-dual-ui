package com.taomee.seer2.app.arena.ui.status
{
   import com.taomee.seer2.app.arena.resource.FightUIManager;
   import com.taomee.seer2.app.component.PetTypeIcon;
   import flash.display.Sprite;
   
   public class FightInfoRelation extends Sprite
   {
      
      private static const RELATION_LIST:Array = [[4,6,7],[2,8,15],[3,9,16],[4,10,11],[4,7,14,18,17],[8,10,17],[9,16],[3,5,7,18],[4,14,15],[6,12,13],[2,9,18],[3,8,18,12,13],[5,11],[6,14,18,13],[2,5,10,18,17],[11,12,15],[6,9,12,13,15,16]];
      
      private const H_SPACE_MARK:int = 10;
      
      private const H_SPACE_ICON:int = 10;
      
      public function FightInfoRelation()
      {
         super();
      }
      
      public function showRelation(param1:int) : void
      {
         var _loc4_:Sprite = null;
         var _loc6_:PetTypeIcon = null;
         var _loc3_:int = 0;
         if(param1 >= 19)
         {
            return;
         }
         _loc4_ = FightUIManager.getMovieClip("UI_Mark");
         _loc4_.x = 475.75;
         _loc4_.y = 371.9;
         addChild(_loc4_);
         _loc6_ = new PetTypeIcon();
         _loc6_.type = param1;
         _loc6_.y = 366.45;
         _loc6_.x = _loc4_.x + _loc4_.width + 10;
         addChild(_loc6_);
         var _loc5_:Array = RELATION_LIST[param1 - 2];
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc6_ = new PetTypeIcon();
            _loc6_.type = _loc5_[_loc5_.length - _loc2_ - 1];
            if(_loc2_ == 0)
            {
               _loc6_.x = _loc4_.x - 10 - _loc6_.width;
               _loc3_ = _loc6_.x;
            }
            else
            {
               _loc6_.x = _loc3_ - 10 - _loc6_.width;
               _loc3_ = _loc6_.x;
            }
            _loc6_.y = 366.45;
            addChild(_loc6_);
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
      }
   }
}

