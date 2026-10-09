package com.taomee.seer2.app.arena.util
{
   import com.taomee.seer2.app.arena.ui.ButtonPanelData;
   import com.taomee.seer2.core.config.ClientConfig;
   import org.taomee.ds.HashMap;
   
   public class ControlPanelUtil
   {
      
      private static var _settingDatas:HashMap;
      
      private static var _btnSetting:Class = ControlPanelUtil__btnSetting;
      
      public function ControlPanelUtil()
      {
         super();
      }
      
      public static function getSettingData(param1:uint) : ButtonPanelData
      {
         if(_settingDatas == null)
         {
            _settingDatas = new HashMap();
            setup();
         }
         var _loc2_:ButtonPanelData = _settingDatas.getValue(param1);
         if(_loc2_ == null)
         {
            if(ClientConfig.isDebug)
            {
               throw new Error("没有配置\'arenaControlPanelConfig.xml\'!fightMode:[" + param1 + "]");
            }
            _loc2_ = new ButtonPanelData();
         }
         return _loc2_;
      }
      
      private static function setup() : void
      {
         var _loc2_:XML = null;
         var _loc1_:ButtonPanelData = null;
         var _loc4_:XML = XML(new _btnSetting());
         var _loc3_:XMLList = _loc4_.child("mode");
         var _loc6_:uint = uint(_loc3_.length());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc6_)
         {
            _loc2_ = _loc3_[_loc5_];
            _loc1_ = new ButtonPanelData();
            _loc1_.fightEnabled = uint(_loc2_.@fightEnabled) == 1 ? true : false;
            _loc1_.catchEnabled = uint(_loc2_.@catchEnabled) == 1 ? true : false;
            _loc1_.itemEnabled = uint(_loc2_.@itemEnabled) == 1 ? true : false;
            _loc1_.petEnabled = uint(_loc2_.@petEnabled) == 1 ? true : false;
            _loc1_.escapeEnabled = uint(_loc2_.@escapeEnabled) == 1 ? true : false;
            _settingDatas.add(int(_loc2_.@id),_loc1_);
            _loc5_++;
         }
      }
   }
}

