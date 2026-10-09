package com.taomee.seer2.app.actor.attach
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import org.taomee.utils.Tick;
   
   public class PetKingTeamAttach implements IActorAttach
   {
      
      public static const RED_TEAM:uint = 1;
      
      public static const BLUE_TEAM:uint = 2;
      
      public static const GREEN_TEAM:uint = 3;
      
      private static var _info:ContentInfo;
      
      private var _whichTeam:int = -1;
      
      private var _teamMc:MovieClip;
      
      private var _actor:Actor;
      
      private var _isMyself:Boolean = false;
      
      public function PetKingTeamAttach()
      {
         super();
      }
      
      public static function get myTeamIndex() : int
      {
         var _loc1_:int = 0;
         switch(int(ActorManager.actorInfo.activityData[1]) - 500508)
         {
            case 0:
               _loc1_ = 1;
               break;
            case 1:
               _loc1_ = 2;
               break;
            case 2:
               _loc1_ = 3;
         }
         return _loc1_;
      }
      
      public static function getMcCopy(param1:String) : MovieClip
      {
         var _loc2_:Class = _info.domain.getDefinition(param1) as Class;
         return new _loc2_() as MovieClip;
      }
      
      private function requestItemSuccess(param1:ItemEvent) : void
      {
         var _loc2_:Vector.<uint> = null;
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.requestItemSuccess);
         if(this._actor.getInfo().id == ActorManager.actorInfo.id)
         {
            this._isMyself = true;
         }
         if(!this._isMyself)
         {
            _loc2_ = this._actor.getInfo().activityData;
            if(_loc2_ != null && _loc2_.length > 1 && _loc2_[1] != 0)
            {
               switch(int(this._actor.getInfo().activityData[1]) - 500508)
               {
                  case 0:
                     this._whichTeam = 1;
                     break;
                  case 1:
                     this._whichTeam = 2;
                     break;
                  case 2:
                     this._whichTeam = 3;
               }
            }
            else
            {
               this._whichTeam = 0;
            }
         }
         else
         {
            this._whichTeam = this.joinWhichTeam();
         }
         if(_info == null)
         {
            this.loadRes();
         }
         else
         {
            this.onResLoaded();
         }
      }
      
      private function requestItem() : void
      {
         ItemManager.addEventListener1("requestSpecialItemSuccess",this.requestItemSuccess);
         ItemManager.requestSpecialItemList();
      }
      
      private function loadRes() : void
      {
         QueueLoader.load(URLUtil.getActivityAnimation("petKingTeamIcon"),"swf",this.onResLoaded);
      }
      
      private function onResLoaded(param1:ContentInfo = null) : void
      {
         if(_info == null)
         {
            _info = param1;
         }
         if(this._whichTeam != 0)
         {
            this._teamMc = getMcCopy("head" + this._whichTeam) as MovieClip;
            this.excute(null);
            Tick.instance.addRender(this.uodatePosition,1000);
         }
      }
      
      private function joinWhichTeam() : int
      {
         if(ItemManager.getSpecialItem(500508) != null)
         {
            return 1;
         }
         if(ItemManager.getSpecialItem(500509) != null)
         {
            return 2;
         }
         if(ItemManager.getSpecialItem(500510) != null)
         {
            return 3;
         }
         return 0;
      }
      
      public function attach(param1:Actor) : void
      {
         this._actor = param1;
         this.requestItem();
      }
      
      public function detach() : void
      {
         DisplayObjectUtil.removeFromParent(this._teamMc);
         this._actor = null;
      }
      
      public function excute(param1:*) : void
      {
         if(this._actor != null && this._teamMc != null)
         {
            this._teamMc.y = -100;
            this._teamMc.x = -15;
            this._actor.addChild(this._teamMc);
         }
      }
      
      public function uodatePosition(param1:* = null) : void
      {
         if(this._actor != null && this._teamMc != null)
         {
            if(this._actor.isDogz == true)
            {
               this._teamMc.y = -150;
            }
            else
            {
               this._teamMc.y = -100;
            }
         }
      }
      
      public function get type() : String
      {
         return null;
      }
   }
}

