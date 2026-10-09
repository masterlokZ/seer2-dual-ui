package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   import org.taomee.bean.BaseBean;
   
   public class BabLanguageListener extends BaseBean
   {
      
      public function BabLanguageListener()
      {
         super();
         Connection.addCommandListener(CommandSet.BAB_LANGUAGE_1198,this.onMessage);
         finish();
      }
      
      private function onMessage(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc3_:String = _loc2_.readUTFBytes(_loc4_);
         AlertManager.showAlert("你使用了非法语言：<font color=\'#FF0000\'>" + _loc3_ + "</font>");
      }
   }
}

