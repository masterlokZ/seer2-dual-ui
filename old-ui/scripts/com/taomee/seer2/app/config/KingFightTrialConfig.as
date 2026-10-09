package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.KingFightTrialInfo;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class KingFightTrialConfig
   {
      
      private static var _instance:KingFightTrialConfig;
      
      private var _isLoaded:Boolean = false;
      
      private var _isLoading:Boolean = false;
      
      private var _allXml:XMLList;
      
      private var _fightInfoList:Vector.<KingFightTrialInfo>;
      
      private var _openNum:int;
      
      private var _curFightNum:int;
      
      private var callback:Function;
      
      public function KingFightTrialConfig()
      {
         super();
      }
      
      public static function getInstance() : KingFightTrialConfig
      {
         if(!_instance)
         {
            _instance = new KingFightTrialConfig();
         }
         return _instance;
      }
      
      public function get fightInfoList() : Vector.<KingFightTrialInfo>
      {
         return this._fightInfoList;
      }
      
      public function get openNum() : int
      {
         return this._openNum;
      }
      
      public function set curFightNum(param1:int) : void
      {
         this._curFightNum = param1;
      }
      
      public function get curFightNum() : int
      {
         return this._curFightNum;
      }
      
      public function getFightInfo(param1:Function) : void
      {
         if(this._isLoaded)
         {
            param1();
         }
         else
         {
            this.callback = param1;
            this.loadConfig();
         }
      }
      
      private function loadConfig() : void
      {
         if(!this._isLoaded && !this._isLoading)
         {
            this._isLoading = true;
            QueueLoader.load(URLUtil.getActivityXML("KingFightTrial"),"text",this.onComplete);
         }
      }
      
      private function onComplete(param1:ContentInfo) : void
      {
         this._openNum = int(XML(param1.content).@openNum);
         this._allXml = XML(param1.content).descendants("item");
         this.parserXml();
      }
      
      private function parserXml() : void
      {
         var _loc5_:KingFightTrialInfo = null;
         var _loc4_:int = 0;
         var _loc6_:XML = null;
         var _loc2_:Array = null;
         var _loc1_:Array = null;
         var _loc3_:Array = null;
         this._fightInfoList = new Vector.<KingFightTrialInfo>();
         var _loc7_:Array = [0,0.05,0.1,0.15,0.2,0.25];
         for each(_loc6_ in this._allXml)
         {
            _loc5_ = new KingFightTrialInfo();
            _loc5_.level = int(_loc6_.@level);
            _loc5_.fightResList = new Vector.<int>();
            _loc2_ = String(_loc6_.@fightResList).split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_.fightResList.push(_loc2_[_loc4_]);
               _loc4_++;
            }
            _loc5_.layerNum = int(_loc6_.@id);
            _loc5_.awradList.push(["exp",int(_loc5_.layerNum * 130 / 5 + _loc7_[VipManager.vipInfo.level] * _loc5_.layerNum * 130 / 5)]);
            _loc5_.awradList.push(["coin",int(200 + _loc5_.layerNum * 5)]);
            if(String(_loc6_.@award) != "")
            {
               _loc1_ = String(_loc6_.@award).split(";");
               _loc4_ = 0;
               while(_loc4_ < _loc1_.length)
               {
                  _loc3_ = String(_loc1_[_loc4_]).split(",");
                  _loc5_.awradList.push([_loc3_[0],int(_loc3_[1])]);
                  _loc4_++;
               }
            }
            this._fightInfoList.push(_loc5_);
         }
         this._isLoaded = true;
         this._isLoading = false;
         this.callback();
      }
      
      public function getTotalAwardList(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc3_:Array = [];
         if(this._allXml == null)
         {
            return _loc3_;
         }
         if(param1.length == 0)
         {
            return _loc3_;
         }
         _loc3_.push(["exp",0],["coin",0]);
         var _loc5_:Array = [0,0.05,0.1,0.15,0.2,0.25];
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            var _loc6_:int = 1;
            var _loc7_:Number = (_loc3_[0] as Array)[_loc6_] + (int(this._fightInfoList[param1[_loc2_]].layerNum * 130 / 5 + _loc5_[VipManager.vipInfo.level] * this._fightInfoList[param1[_loc2_]].layerNum * 130 / 5));
            (_loc3_[0] as Array)[_loc6_] = _loc7_;
            (_loc3_[1] as Array)[1] += int(this._fightInfoList[param1[_loc2_]].layerNum * 5 + 200);
            _loc4_ = 0;
            while(_loc4_ < this._fightInfoList[param1[_loc2_]].awradList.length)
            {
               this.propMerge(_loc3_,this._fightInfoList[param1[_loc2_]].awradList[_loc4_] as Array);
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      private function propMerge(param1:Array, param2:Array) : void
      {
         var _loc4_:Boolean = false;
         var _loc3_:int = 0;
         if(param2[0] == "exp" || param2[0] == "coin")
         {
            return;
         }
         if(param2[0] == "pet")
         {
            param1.push(param2.slice());
         }
         else
         {
            _loc4_ = false;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if((param1[_loc3_] as Array)[0] == param2[0])
               {
                  var _loc5_:int = 1;
                  var _loc6_:Number = (param1[_loc3_] as Array)[_loc5_] + param2[1];
                  (param1[_loc3_] as Array)[_loc5_] = _loc6_;
                  _loc4_ = true;
                  break;
               }
               _loc3_++;
            }
            if(!_loc4_)
            {
               param1.push(param2.slice());
            }
         }
      }
   }
}

