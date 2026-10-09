package com.taomee.seer2.app.arena
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.ByteArray;
   import seer2.next.fight.auto.FindDifferentRewrite;
   
   public class FightVerifyManager
   {
      
      private static const DELAY_TIME:uint = 0;
      
      private static var _forbiddenTime:int;
      
      public function FightVerifyManager()
      {
         super();
      }
      
      public static function validateFightStart() : Boolean
      {
         if(TimeManager.getAvailableTime() <= 0)
         {
            AlertManager.showAlert("电池已耗完不能进行对战");
            return false;
         }
         var _loc1_:PetInfo = PetInfoManager.getFirstPetInfo();
         if(_loc1_ != null)
         {
            if(_loc1_.hp == 0)
            {
               AlertManager.showAlert("首发精灵血量耗尽");
               return false;
            }
            return true;
         }
         AlertManager.showAlert("没有设置首发精灵");
         return false;
      }
      
      public static function checkVerifyStatus() : Boolean
      {
         return true;
      }
      
      public static function startForbiddenTimer() : void
      {
      }
      
      public static function onStartFightVerify(param1:MessageEvent, param2:Function, param3:Function) : void
      {
         var fakeHash:String;
         var verifyStartFightSuccess:Function = null;
         var verifyStartFightError:Function = null;
         var event:MessageEvent = param1;
         var onSuccess:Function = param2;
         var onFail:Function = param3;
         verifyStartFightSuccess = function():void
         {
            if(onSuccess != null)
            {
               onSuccess();
            }
         };
         verifyStartFightError = function():void
         {
            if(onFail != null)
            {
               onFail();
            }
         };
         var data:ByteArray = event.message.getRawData();
         var picData:ByteArray = new ByteArray();
         var len:int = int(data.length);
         picData.endian = "littleEndian";
         picData.writeBytes(data,8,len - 8);
         fakeHash = uint((len - 5008) / 6) + "" + picData[1000] + picData[3000];
         FindDifferentRewrite.getInstance().sendAnswer(fakeHash,verifyStartFightSuccess,verifyStartFightError);
      }
   }
}

