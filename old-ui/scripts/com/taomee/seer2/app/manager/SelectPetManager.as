package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.app.gameRule.behavior.SOMultiBehavior;
   import com.taomee.seer2.app.gameRule.data.FighterSelectPanelVO;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class SelectPetManager
   {
      
      private static var _callBack:Function;
      
      public function SelectPetManager()
      {
         super();
      }
      
      public static function selectFixedPet(param1:int, param2:Function) : void
      {
         var _loc3_:FighterSelectPanelVO = null;
         if(PetInfoManager.getAllBagPetInfo().length < param1)
         {
            AlertManager.showAlert("出战精灵数量不足");
            return;
         }
         _callBack = param2;
         _loc3_ = new FighterSelectPanelVO();
         _loc3_.minSelectedPetCount = param1;
         _loc3_.maxSelectedPetCount = param1;
         _loc3_.pets = PetInfoManager.getAllBagPetInfo();
         _loc3_.onComplete = onComplete;
         _loc3_.isShowSelected = true;
         _loc3_.defaultPets = getDefaultPets(param1);
         ModuleManager.toggleModule(URLUtil.getAppModule("FighterSelectPanel"),"打开面板中...",_loc3_);
      }
      
      private static function onComplete(param1:Vector.<uint>) : void
      {
         var _loc2_:String = "default_selected_list";
         var _loc4_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_.push(param1[_loc3_]);
            _loc3_++;
         }
         SOMultiBehavior.writeDefaultPets(_loc2_,_loc4_);
         _callBack(param1);
      }
      
      private static function getDefaultPets(param1:int) : Vector.<PetInfo>
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = "default_selected_list";
         var _loc7_:Array = SOMultiBehavior.readDefaultPets(_loc5_);
         var _loc6_:Vector.<PetInfo> = new Vector.<PetInfo>();
         var _loc2_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         if(!_loc7_)
         {
            _loc3_ = 0;
            while(_loc3_ < param1)
            {
               _loc6_.push(_loc2_[_loc3_]);
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = _loc2_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc6_.length >= param1)
               {
                  break;
               }
               if(_loc7_.indexOf(_loc2_[_loc3_].catchTime) != -1)
               {
                  _loc6_.push(_loc2_[_loc3_]);
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc6_.length >= param1)
               {
                  break;
               }
               if(_loc7_.indexOf(_loc2_[_loc3_].catchTime) == -1)
               {
                  _loc6_.push(_loc2_[_loc3_]);
               }
               _loc3_++;
            }
         }
         return _loc6_;
      }
   }
}

