package com.taomee.seer2.app.announcement.horn
{
   import com.taomee.seer2.app.config.HornConfig;
   import com.taomee.seer2.core.manager.GlobalsManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DateUtil;
   
   public class HornControl
   {
      
      public static var _isShowHorn:Boolean;
      
      private static var _isYesInfo:Boolean;
      
      private static var _hornVec:Vector.<HornInfo>;
      
      private static var _hornInfo:HornInfo;
      
      private static var _horn:AbstractHorn;
      
      private static const MILLISECONDS_PER_SECOND:uint = 1000;
      
      private static var _curHour:uint;
      
      public function HornControl()
      {
         super();
      }
      
      public static function checkTime() : void
      {
         var _loc2_:HornInfo = null;
         var _loc1_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         if(_isShowHorn)
         {
            return;
         }
         if(SceneManager.currentSceneType == 2)
         {
            return;
         }
         if(GlobalsManager.isPlayingGame)
         {
            return;
         }
         _hornVec = HornConfig.getHornInfoVec();
         _hornInfo = null;
         for each(_loc2_ in _hornVec)
         {
            _loc1_ = _loc2_.week;
            _loc4_ = _loc2_.time;
            _loc3_ = _loc2_.minute;
            if(DateUtil.inInDateScope(_loc1_,_loc4_,_loc3_,_loc4_,_loc3_ + 3))
            {
               _hornInfo = _loc2_;
               createHorn(1);
               break;
            }
         }
      }
      
      private static function createHorn(param1:uint) : void
      {
         _isShowHorn = true;
         if(param1 == 1)
         {
            _horn = new Horn(_hornInfo);
         }
         else if(param1 == 2)
         {
            _horn = new VipHorn(null);
         }
      }
   }
}

