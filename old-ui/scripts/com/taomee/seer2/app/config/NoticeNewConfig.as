package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.info.ItemInfo;
   import com.taomee.seer2.app.config.info.NoticeInfo;
   import com.taomee.seer2.app.config.info.NoticeLimitInfo;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.utils.URLUtil;
   import org.taomee.ds.HashMap;
   
   public class NoticeNewConfig
   {
      
      private static var _instance:NoticeNewConfig;
      
      private var _isLoaded:Boolean = false;
      
      private var _isLoading:Boolean = false;
      
      private var _allXml:XMLList;
      
      private var _allAct:Vector.<NoticeInfo>;
      
      private var _hotAct:Vector.<NoticeInfo>;
      
      private var _closeAct:Vector.<NoticeInfo>;
      
      private var _petAct:Vector.<NoticeInfo>;
      
      private var _evlAct:Vector.<NoticeInfo>;
      
      private var _fdbAct:Vector.<NoticeInfo>;
      
      private var _dressAct:Vector.<NoticeInfo>;
      
      private var _vipAct:Vector.<NoticeInfo>;
      
      private var _recommendAct:Vector.<NoticeInfo>;
      
      private var callback:Function;
      
      public function NoticeNewConfig()
      {
         super();
      }
      
      public static function get Instance() : NoticeNewConfig
      {
         if(!_instance)
         {
            _instance = new NoticeNewConfig();
         }
         return _instance;
      }
      
      public function get vipAct() : Vector.<NoticeInfo>
      {
         return this._vipAct;
      }
      
      public function get dressAct() : Vector.<NoticeInfo>
      {
         return this._dressAct;
      }
      
      public function get evlAct() : Vector.<NoticeInfo>
      {
         return this._evlAct;
      }
      
      public function get petAct() : Vector.<NoticeInfo>
      {
         return this._petAct;
      }
      
      public function get closeAct() : Vector.<NoticeInfo>
      {
         return this._closeAct;
      }
      
      public function get hotAct() : Vector.<NoticeInfo>
      {
         return this._hotAct;
      }
      
      public function get fdbAct() : Vector.<NoticeInfo>
      {
         return this._fdbAct;
      }
      
      public function get recommendAct() : Vector.<NoticeInfo>
      {
         var _loc1_:NoticeInfo = null;
         this._recommendAct = new Vector.<NoticeInfo>();
         for each(_loc1_ in this._allAct)
         {
            if(ActorManager.actorInfo.trainerLevel < 7 && _loc1_.trainerLev < 7)
            {
               this._recommendAct.push(_loc1_);
            }
            else if(ActorManager.actorInfo.trainerLevel > 6 && ActorManager.actorInfo.trainerLevel < 13 && _loc1_.trainerLev < 13)
            {
               this._recommendAct.push(_loc1_);
            }
            else if(ActorManager.actorInfo.trainerLevel > 12)
            {
               this._recommendAct.push(_loc1_);
            }
         }
         return this._recommendAct;
      }
      
      public function get allAct() : Vector.<NoticeInfo>
      {
         return this._allAct;
      }
      
      public function getNoticeInfo(param1:Function) : void
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
            QueueLoader.load(URLUtil.getActivityXML("activity_notice_new"),"text",this.onComplete);
         }
      }
      
      private function onComplete(param1:ContentInfo) : void
      {
         this._allXml = XML(param1.content).descendants("act");
         this.parserXml();
      }
      
      private function parserXml() : void
      {
         var _loc7_:XML = null;
         var _loc6_:NoticeInfo = null;
         var _loc9_:XMLList = null;
         var _loc8_:XML = null;
         var _loc3_:XMLList = null;
         var _loc2_:XML = null;
         var _loc5_:XMLList = null;
         var _loc4_:XML = null;
         var _loc1_:XMLList = null;
         var _loc12_:XML = null;
         var _loc13_:String = null;
         var _loc10_:Array = null;
         var _loc11_:NoticeLimitInfo = null;
         var _loc14_:ItemInfo = null;
         this._allAct = new Vector.<NoticeInfo>();
         this._hotAct = new Vector.<NoticeInfo>();
         this._closeAct = new Vector.<NoticeInfo>();
         this._petAct = new Vector.<NoticeInfo>();
         this._evlAct = new Vector.<NoticeInfo>();
         this._fdbAct = new Vector.<NoticeInfo>();
         this._dressAct = new Vector.<NoticeInfo>();
         this._vipAct = new Vector.<NoticeInfo>();
         for each(_loc7_ in this._allXml)
         {
            _loc6_ = new NoticeInfo();
            _loc6_.resId = String(_loc7_.@resId);
            _loc6_.difficulty = int(_loc7_.@difficulty);
            _loc6_.trainerLev = int(_loc7_.@trainer);
            _loc6_.go = String(_loc7_.@go).split(",");
            _loc6_.isMapID = int(_loc7_.@isMapID);
            _loc6_.strategyId = uint(_loc7_.@strategyId);
            _loc6_.time = String(_loc7_.detail.@time);
            _loc6_.detailDes = String(_loc7_.detail.@des);
            _loc6_.des = String(_loc7_.@des);
            _loc6_.isAll = int(_loc7_.time.@isAll) == 0 ? false : true;
            _loc6_.startTime = String(_loc7_.time.@start);
            _loc6_.endTime = String(_loc7_.time.@end);
            _loc9_ = _loc7_.descendants("limit");
            _loc6_.timeLimit = new HashMap();
            for each(_loc8_ in _loc9_)
            {
               _loc13_ = String(_loc8_.@day);
               if(!_loc6_.timeLimit.getValue(_loc13_))
               {
                  _loc6_.timeLimit.add(_loc13_,[]);
               }
               _loc10_ = _loc6_.timeLimit.getValue(_loc13_) as Array;
               _loc11_ = new NoticeLimitInfo();
               _loc11_.startTime = String(_loc8_.@start);
               _loc11_.endTime = String(_loc8_.@end);
               _loc10_.push(_loc11_);
            }
            _loc3_ = _loc7_.descendants("item");
            _loc6_.itemReward = new Vector.<ItemInfo>();
            for each(_loc2_ in _loc3_)
            {
               _loc14_ = new ItemInfo(_loc2_);
               _loc6_.itemReward.push(_loc14_);
            }
            _loc5_ = _loc7_.descendants("pet");
            _loc6_.petReward = [];
            for each(_loc4_ in _loc5_)
            {
               _loc6_.petReward.push(_loc4_.attribute("id"));
            }
            _loc6_.types = new Vector.<String>();
            _loc1_ = _loc7_.descendants("type");
            for each(_loc12_ in _loc1_)
            {
               _loc6_.types.push(_loc12_.@name);
               if(_loc12_.@name == "hot")
               {
                  this._hotAct.push(_loc6_);
               }
               else if(_loc12_.@name == "close")
               {
                  this._closeAct.push(_loc6_);
               }
               else if(_loc12_.@name == "pet")
               {
                  this._petAct.push(_loc6_);
               }
               else if(_loc12_.@name == "evl")
               {
                  this._evlAct.push(_loc6_);
               }
               else if(_loc12_.@name == "fdb")
               {
                  this._fdbAct.push(_loc6_);
               }
               else if(_loc12_.@name == "dress")
               {
                  this._dressAct.push(_loc6_);
               }
               else if(_loc12_.@name == "vip")
               {
                  this._vipAct.push(_loc6_);
               }
            }
            this._allAct.push(_loc6_);
         }
         this._isLoaded = true;
         this._isLoading = false;
         this.callback();
      }
   }
}

