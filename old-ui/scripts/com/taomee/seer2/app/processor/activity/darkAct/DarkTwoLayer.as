package com.taomee.seer2.app.processor.activity.darkAct
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.dialog.functionality.BaseUnit;
   import com.taomee.seer2.app.dialog.functionality.CustomUnit;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.utils.IDataInput;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.DomainUtil;
   
   public class DarkTwoLayer
   {
      
      private const TIME_SWP:int = 1167;
      
      private const NEXT_SWP:int = 1169;
      
      private const NPC_ID:int = 130;
      
      private const ITEM_ID:Vector.<int> = Vector.<int>([400080,400077]);
      
      private const POS:Vector.<int> = Vector.<int>([700,390]);
      
      private const FUNC_STR:Vector.<String> = Vector.<String>(["嗜血阵挑战开始"," 黑魔阵挑战开始","审判阵挑战开始"]);
      
      private var _mapModel:MapModel;
      
      private var _resLib:ApplicationDomain;
      
      private var _curHandle:DarkTwoHandle;
      
      private var _npc:Mobile;
      
      private var _self:DarkTwoLayer;
      
      private var _type:int;
      
      public function DarkTwoLayer(param1:MapModel)
      {
         super();
         this._mapModel = param1;
         this._self = this;
         this.init();
      }
      
      public function set resLib(param1:ApplicationDomain) : void
      {
         this._resLib = param1;
      }
      
      private function init() : void
      {
         DarkTwoManager.inistance().addObj(this);
      }
      
      public function initSet(param1:Array) : void
      {
         this._type = param1[0];
         this._curHandle = new DarkTwoHandle(param1[0]);
         this._curHandle.initSet([this._resLib,this._mapModel,this._self,param1[1],param1[2]]);
      }
      
      public function initEvent() : void
      {
         DialogPanel.addEventListener("dialogShow",this.onDialogShow);
      }
      
      private function onDialogShow(param1:Event) : void
      {
         DialogPanel.showForSimple(130,"审判官",[[0,"年轻人，死神的审判官在此等候你多时，你既然来了就不要想轻易的出去了。来接受暗黑的审判吧。"]],"我再准备下");
         this.addUinit();
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set curHandle(param1:DarkTwoHandle) : void
      {
         this._curHandle = param1;
      }
      
      public function get curHandle() : DarkTwoHandle
      {
         return this._curHandle;
      }
      
      private function addUinit() : void
      {
         var _loc5_:BaseUnit = null;
         var _loc4_:int = 0;
         var _loc1_:String = null;
         DialogPanel.addFunctionalityBox();
         var _loc3_:Vector.<String> = Vector.<String>(["暗月石购买","第二层规则","进入第三层"]);
         if(this._type <= 2)
         {
            _loc3_.push(this.FUNC_STR[this._type]);
         }
         var _loc2_:Vector.<String> = Vector.<String>(["buy","rule","80013","readyGo"]);
         for each(_loc1_ in _loc3_)
         {
            if(_loc4_ <= 1)
            {
               _loc5_ = new CustomUnit("module",_loc1_,_loc2_[_loc4_]);
            }
            else
            {
               _loc5_ = new CustomUnit("active",_loc1_,_loc2_[_loc4_]);
            }
            DialogPanel.functionalityBox.addUnit(_loc5_);
            _loc4_++;
         }
         DialogPanel.addEventListener("customUnitClick",this.onUint);
      }
      
      private function getMovie(param1:String) : MovieClip
      {
         if(this._resLib)
         {
            return DomainUtil.getMovieClip(param1,this._resLib);
         }
         return null;
      }
      
      private function onUint(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         var params:String = String(evt.content.params);
         if(params == "buy")
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("BuyPropPanel"),"",{
               "itemId":400078,
               "canBatch":true,
               "isLimitNum":false,
               "buyType":"mi",
               "itemType":"hideShop"
            });
         }
         if(params == "rule")
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("DarkDeathRule1Panel"),"打开规则...");
         }
         if(params == "80013")
         {
            AlertManager.showConfirm("你是否消耗10个暗月石进入第三层？",function():void
            {
               ItemManager.requestItemList(function():void
               {
                  var num1:int = getItemNum(ITEM_ID[0]);
                  var num2:int = getItemNum(ITEM_ID[1]);
                  if(num1 + num2 >= 10)
                  {
                     SwapManager.swapItem(1169,1,function(param1:IDataInput):void
                     {
                        var _loc2_:SwapInfo = new SwapInfo(param1);
                        SceneManager.changeScene(9,80013);
                     });
                  }
                  else
                  {
                     AlertManager.showAlert("暗月石数量不足");
                  }
               });
            });
         }
         if(params == "readyGo")
         {
            AlertManager.showConfirm("倒计时开始，你确定开始挑战吗？",function():void
            {
               hideNpc();
               SwapManager.swapItem(1167,1,function(param1:IDataInput):void
               {
                  var _loc2_:SwapInfo = new SwapInfo(param1,false);
                  if(_curHandle == null)
                  {
                     initSet([DarkTwoManager.inistance().type,0,0]);
                     curHandle.initHandle();
                  }
                  _curHandle.start();
               });
            });
         }
      }
      
      private function getItemNum(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:Item = ItemManager.getItemByReferenceId(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.quantity;
         }
         else
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function showNpc() : void
      {
         this.hideNpc();
         this._npc = new Mobile();
         this._npc.resourceUrl = URLUtil.getNpcSwf(130);
         this._npc.scaleX = -1;
         this._npc.x = this.POS[0];
         this._npc.y = this.POS[1];
         this._npc.buttonMode = true;
         MobileManager.addMobile(this._npc,"npc");
         this._mapModel.content.addChild(this._npc);
         this._npc.addEventListener("click",this.onDialogShow);
      }
      
      public function hideNpc() : void
      {
         if(Boolean(this._npc) && Boolean(this._npc.parent))
         {
            this._npc.removeEventListener("click",this.onDialogShow);
            DisplayUtil.removeForParent(this._npc);
            this._npc = null;
         }
      }
      
      public function removeUnit() : void
      {
         var _loc1_:BaseUnit = null;
         var _loc3_:String = null;
         var _loc2_:Vector.<String> = Vector.<String>(["暗月石购买","第二层规则","进入第三层","嗜血阵挑战开始"," 黑魔阵挑战开始","审判阵挑战开始"]);
         for each(_loc3_ in _loc2_)
         {
            _loc1_ = DialogPanel.functionalityBox.getUnit(_loc3_);
            if(_loc1_)
            {
               DialogPanel.functionalityBox.removeUnit(_loc1_);
            }
         }
      }
      
      public function dispose() : void
      {
         this._mapModel = null;
         this._resLib = null;
         if(this._curHandle)
         {
            this._curHandle.dispose();
            this._curHandle = null;
         }
         DialogPanel.functionalityBox.clear();
         DisplayUtil.removeForParent(this._npc);
         this._npc = null;
         this._self = null;
         DialogPanel.removeEventListener("dialogShow",this.onDialogShow);
         DialogPanel.removeEventListener("customUnitClick",this.onUint);
      }
   }
}

