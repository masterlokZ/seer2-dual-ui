package com.taomee.seer2.app.gameRule.spt.support
{
   public class SptDialogInfo
   {
      
      public var bossId:uint;
      
      public var talks:Vector.<String>;
      
      public var content:Vector.<SptDialogContentInfo>;
      
      protected var _talk_index:uint = 0;
      
      public function SptDialogInfo()
      {
         super();
         this.talks = new Vector.<String>();
         this.content = new Vector.<SptDialogContentInfo>();
      }
      
      public function getTalkContent() : String
      {
         var _loc1_:String = this.talks[this._talk_index];
         ++this._talk_index;
         if(this._talk_index > this.talks.length - 1)
         {
            this._talk_index = 0;
         }
         return _loc1_;
      }
      
      public function getDialogContent(param1:uint, param2:Array) : String
      {
         var _loc4_:String = null;
         var _loc5_:uint = this.content.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc5_)
         {
            if(this.content[_loc3_].id == param1)
            {
               _loc4_ = this.content[_loc3_].getContent(param2);
               break;
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      public function setUpTalks(param1:XMLList) : void
      {
         var _loc2_:XMLList = param1["talk"];
         var _loc4_:uint = uint(_loc2_.length());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc4_)
         {
            this.talks.push(XML(_loc2_[_loc3_]).attribute("content"));
            _loc3_++;
         }
      }
      
      public function setUpContents(param1:XMLList) : void
      {
         var _loc2_:SptDialogContentInfo = null;
         var _loc3_:XMLList = param1["sptDialog"];
         var _loc5_:uint = uint(_loc3_.length());
         var _loc4_:uint = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = new SptDialogContentInfo();
            _loc2_.id = uint(XML(_loc3_[_loc4_]).attribute("id"));
            _loc2_.content = XML(XML(_loc3_[_loc4_])["dialog"]).toXMLString();
            this.content.push(_loc2_);
            _loc4_++;
         }
      }
   }
}

