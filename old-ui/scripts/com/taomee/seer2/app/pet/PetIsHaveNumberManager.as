package com.taomee.seer2.app.pet
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   
   public class PetIsHaveNumberManager
   {
      
      private static var _successCallBack:Function;
      
      private static var _errorCallBack:Function;
      
      private static var _isRequesting:Boolean = false;
      
      private static var _petIdList:Vector.<uint>;
      
      private static var _waitList:Array = [];
      
      private static var _petMap:HashMap = new HashMap();
      
      public function PetIsHaveNumberManager()
      {
         super();
      }
      
      public static function requestIsHavePet(param1:Vector.<uint>, param2:Function) : void
      {
         _waitList.push({
            "list":param1,
            "success":param2
         });
         processNextRequest();
      }
      
      private static function processNextRequest() : void
      {
         var _loc2_:Object = null;
         var _loc1_:LittleEndianByteArray = null;
         var _loc3_:uint = 0;
         if(Boolean(_waitList.length) && _isRequesting == false)
         {
            _isRequesting = true;
            _loc2_ = _waitList.shift();
            _petIdList = _loc2_.list;
            _loc1_ = new LittleEndianByteArray();
            _loc1_.writeInt(_petIdList.length);
            for each(_loc3_ in _petIdList)
            {
               _loc1_.writeInt(_loc3_);
            }
            _successCallBack = _loc2_.success;
            Connection.addCommandListener(CommandSet.GET_PET_NUMBERID_HAVE_1535,onGetRewardSuccess);
            Connection.send(CommandSet.GET_PET_NUMBERID_HAVE_1535,_loc1_);
         }
      }
      
      private static function onGetRewardSuccess(param1:MessageEvent) : void
      {
         var _loc4_:uint = 0;
         Connection.removeCommandListener(CommandSet.GET_PET_NUMBERID_HAVE_1535,onGetRewardSuccess);
         var _loc3_:IDataInput = param1.message.getRawData();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = _loc3_.readUnsignedInt();
            _petMap.add(_petIdList[_loc2_],_loc4_);
            _loc2_++;
         }
         _successCallBack();
         _successCallBack = null;
         _isRequesting = false;
         processNextRequest();
      }
      
      public static function petIsHave(param1:uint) : Boolean
      {
         if(_petMap.containsKey(param1))
         {
            return _petMap.getValue(param1) == 1 ? true : false;
         }
         return false;
      }
   }
}

