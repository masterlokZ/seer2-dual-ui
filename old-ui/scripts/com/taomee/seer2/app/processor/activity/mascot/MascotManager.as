package com.taomee.seer2.app.processor.activity.mascot
{
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.ui.Proclaim;
   import flash.events.TimerEvent;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   
   public class MascotManager
   {
      
      private var _thisActor:MascotActor;
      
      private var _currActor:MascotActor;
      
      private var _teamList:Vector.<uint>;
      
      private var _teamCountList:Vector.<uint>;
      
      private var _timer:Timer;
      
      private var _map:MapModel;
      
      private var _type:int;
      
      private var _mapId:int;
      
      private var _scentype:int;
      
      public function MascotManager(param1:uint, param2:uint, param3:MapModel)
      {
         super();
         Connection.addCommandListener(CommandSet.NOT_1070,this.not1070);
         this._map = param3;
         this._mapId = param1;
         this.scentype = param1;
         this._thisActor = new MascotActor();
         this._currActor = new MascotActor();
         this._currActor.info.mapId = param1;
         this._currActor.info.id = param2;
         this._currActor.setShowPet(false);
         this.setup(2);
      }
      
      private function set scentype(param1:int) : void
      {
         switch(param1)
         {
            case 40:
               this._scentype = 1;
               break;
            case 81:
               this._scentype = 3;
               break;
            case 30:
               this._scentype = 2;
         }
      }
      
      private function not1070(param1:MessageEvent) : void
      {
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc7_:IDataInput = param1.message.getRawData();
         if(0 == _loc7_.bytesAvailable)
         {
            return;
         }
         var _loc9_:uint = _loc7_.readUnsignedInt();
         var _loc8_:uint = _loc7_.readUnsignedInt();
         var _loc4_:String = _loc7_.readUTFBytes(16);
         var _loc3_:uint = _loc7_.readUnsignedInt();
         this._teamList = Vector.<uint>([]);
         this._teamCountList = Vector.<uint>([]);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc3_)
         {
            _loc10_ = _loc7_.readUnsignedInt();
            _loc11_ = _loc7_.readUnsignedInt();
            this._teamList.push(_loc10_);
            this._teamCountList.push(_loc11_);
            _loc6_++;
         }
         var _loc5_:uint = _loc7_.readUnsignedInt();
         var _loc2_:uint = _loc7_.readUnsignedInt();
         var _loc12_:uint = _loc7_.readUnsignedInt();
         var _loc13_:uint = _loc7_.readUnsignedInt();
         if(_loc9_ == 80)
         {
            this.updateBlood();
         }
         else if(_loc9_ == 78)
         {
            this.updateEnd();
         }
         else if(_loc9_ == 79)
         {
            this.checkEnd();
         }
         else if(_loc9_ == 77)
         {
            this.setup(1);
         }
      }
      
      private function checkEnd() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._teamList.length)
         {
            if(this._currActor.info.id == this._teamList[_loc1_])
            {
               _loc2_ = _loc1_;
            }
            _loc1_++;
         }
         if(this._teamCountList[_loc2_] != 0)
         {
            this.updateStart();
         }
         else
         {
            this.end();
         }
      }
      
      private function end() : void
      {
         this.dispose();
      }
      
      private function updateBlood() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._teamList.length)
         {
            if(this._currActor.info.id == this._teamList[_loc1_])
            {
               this._currActor.setBlood(this._teamCountList[_loc1_],this._map);
            }
            _loc1_++;
         }
      }
      
      private function updateStart() : void
      {
         if(this._teamList[0] == this._currActor.info.id)
         {
            this._currActor.setActor(MascotAnimation.getMC("actor" + this._currActor.info.id),this._map);
         }
      }
      
      public function updateEnd() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = null;
         switch(int(this._teamList[0]) - 1)
         {
            case 0:
               _loc2_ = "动力室";
               _loc1_ = "创世队";
               break;
            case 1:
               _loc2_ = "资料室";
               _loc1_ = "混沌队";
               break;
            case 2:
               _loc2_ = "英格瓦要塞";
               _loc1_ = "开元队";
         }
         Proclaim.addText(_loc1_ + "的吉祥物已经被对手打爆，" + _loc2_ + "出现礼包！");
         if(this._teamList[0] == this._scentype)
         {
            this._type = 1;
            this._currActor.setComplete(MascotAnimation.getMC("actorComplete"),this._map,this._type);
         }
      }
      
      private function setup(param1:int) : void
      {
         this._type = param1;
         ItemManager.addEventListener1("requestSpecialItemSuccess",this.onCount);
         ItemManager.requestSpecialItemList();
      }
      
      private function onCount(param1:ItemEvent) : void
      {
         var event:ItemEvent = param1;
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.onCount);
         MascotAnimation.startLoader(function():void
         {
            _currActor.getTeamStatus(function():void
            {
               if(_currActor.info.status == 1)
               {
                  _currActor.setActor(MascotAnimation.getMC("actor" + _scentype),_map);
               }
               else if(_currActor.info.status == 2)
               {
                  _currActor.setComplete(MascotAnimation.getMC("actorComplete"),_map,_type);
               }
            });
         });
      }
      
      private function initTime() : void
      {
         if(this._timer == null)
         {
            this._timer = new Timer(2000);
         }
         this._timer.stop();
         this._timer.removeEventListener("timer",this.onTimer);
         this._timer.addEventListener("timer",this.onTimer);
         this._timer.start();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(MascotTimeControl.timeContent() == false)
         {
            this._timer.stop();
            this._timer.removeEventListener("timer",this.onTimer);
            this._currActor.dispose();
         }
      }
      
      public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener("timer",this.onTimer);
         }
         this._currActor.dispose();
         Connection.removeCommandListener(CommandSet.NOT_1070,this.not1070);
      }
   }
}

