package com.taomee.seer2.app.copySystem
{
   import com.taomee.seer2.app.config.info.CopyItemInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1238;
   import com.taomee.seer2.app.processor.copy.CopyProcessor;
   import com.taomee.seer2.core.map.grids.HashMap;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   import flash.utils.IDataInput;
   
   public class CopyManager
   {
      
      private static var _self:CopyManager;
      
      private const MAP_ID_MIN:int = 80000;
      
      private const MAP_ID_MAX:int = 90000;
      
      private const CLASS_BASE_PATH:String = "com.taomee.seer2.app.processor.copy.handler.CopyProcessor_";
      
      private var _isSeverSyn:Boolean;
      
      private var _callBack:Function;
      
      private var _dispatcher:EventDispatcher;
      
      private var _xmlClass:Class = CopyManager__xmlClass;
      
      private var _itemMap:HashMap;
      
      private var _curItem:CopyItemInfo;
      
      private var _curProcessor:CopyProcessor;
      
      private var _completeItem:CopyItemInfo;
      
      public function CopyManager()
      {
         super();
         this.configXML();
         this._dispatcher = new EventDispatcher();
         SceneManager.addEventListener("switchComplete",this.onMapComplete);
      }
      
      public static function instance() : CopyManager
      {
         if(null == _self)
         {
            _self = new CopyManager();
         }
         return _self;
      }
      
      private function onMapComplete(param1:SceneEvent) : void
      {
         var cls:Class = null;
         var evt:SceneEvent = param1;
         if(SceneManager.prevMapID >= 80000 && SceneManager.prevMapID <= 90000 && SceneManager.active.type != 2)
         {
            if(Boolean(this._curProcessor) && Boolean(this._curItem))
            {
               this._curProcessor.dispose();
               this._curProcessor = null;
               this._curItem = null;
            }
         }
         if(SceneManager.active.type == 9 && (this._curItem && this._curItem.mapId == SceneManager.active.mapID))
         {
            if(this._curProcessor == null)
            {
               try
               {
                  cls = ApplicationDomain.currentDomain.getDefinition("com.taomee.seer2.app.processor.copy.handler.CopyProcessor_" + this._curItem.mapId) as Class;
               }
               catch(e:Error)
               {
               }
               if(cls)
               {
                  this._curProcessor = new cls(this._curItem);
               }
            }
         }
      }
      
      private function onSendLeaveOK(param1:MessageEvent) : void
      {
      }
      
      private function onSendLeaveError(param1:MessageEvent) : void
      {
      }
      
      public function synSeverData(param1:Function) : void
      {
         this._callBack = param1;
         if(this._isSeverSyn == false)
         {
            Connection.send(CommandSet.CLI_GET_WIN_COPY_1238);
            Connection.addCommandListener(CommandSet.CLI_GET_WIN_COPY_1238,this.onGetSynData);
            Connection.addErrorHandler(CommandSet.CLI_GET_WIN_COPY_1238,this.onGetSynError);
            this._isSeverSyn = true;
         }
         else
         {
            this._callBack();
         }
      }
      
      private function onGetSynData(param1:MessageEvent) : void
      {
         var _loc4_:CopyItemInfo = null;
         var _loc3_:int = 0;
         Connection.removeCommandListener(CommandSet.CLI_GET_WIN_COPY_1238,this.onGetSynData);
         Connection.removeErrorHandler(CommandSet.CLI_GET_WIN_COPY_1238,this.onGetSynError);
         var _loc2_:Parser_1238 = new Parser_1238(param1.message.getRawData());
         for each(_loc3_ in _loc2_.copyInfo)
         {
            if(this._itemMap.containsKey(_loc3_.toString()))
            {
               _loc4_ = this._itemMap.getValue(_loc3_.toString()) as CopyItemInfo;
               _loc4_.isComplete = 1;
               if(_loc4_.hLinkId != 0)
               {
                  if(this._itemMap.containsKey(_loc4_.hLinkId.toString()))
                  {
                     (this._itemMap.getValue(_loc4_.hLinkId.toString()) as CopyItemInfo).isOpen = 1;
                  }
               }
               if(_loc4_.vLinkId != 0)
               {
                  if(this._itemMap.containsKey(_loc4_.vLinkId.toString()))
                  {
                     (this._itemMap.getValue(_loc4_.vLinkId.toString()) as CopyItemInfo).isOpen = 1;
                  }
               }
            }
         }
         this._callBack();
      }
      
      public function startCurCopyItem(param1:int) : void
      {
         if(this._itemMap.containsKey(param1.toString()))
         {
            this._curItem = this._itemMap.getValue(param1.toString()) as CopyItemInfo;
         }
      }
      
      public function getCopyItemListByMode(param1:int, param2:int) : Vector.<CopyItemInfo>
      {
         var _loc3_:CopyItemInfo = null;
         var _loc5_:Vector.<CopyItemInfo> = new Vector.<CopyItemInfo>();
         var _loc4_:Array = this._itemMap.values();
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.parentId == param1 && _loc3_.mode == param2)
            {
               _loc5_.push(_loc3_);
            }
         }
         return _loc5_;
      }
      
      private function onGetSynError(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.CLI_GET_WIN_COPY_1238,this.onGetSynData);
         Connection.removeErrorHandler(CommandSet.CLI_GET_WIN_COPY_1238,this.onGetSynError);
      }
      
      public function completeCopyItem(param1:int) : void
      {
         if(this._itemMap.containsKey(param1.toString()))
         {
            this._completeItem = this._itemMap.getValue(param1.toString()) as CopyItemInfo;
            if(this._completeItem.mapId == 80001 || this._completeItem.mapId == 80002)
            {
               Connection.send(CommandSet.CLI_SET_WIN_COPY_1237,uint(this._completeItem.mapId));
            }
            this.onComplete();
         }
      }
      
      public function getCopyItemById(param1:int) : CopyItemInfo
      {
         if(this._itemMap.containsKey(param1.toString()))
         {
            return this._itemMap.getValue(param1.toString()) as CopyItemInfo;
         }
         return null;
      }
      
      private function onComplete() : void
      {
         if(this._completeItem)
         {
            this._completeItem.isComplete = 1;
            if(this._completeItem.hLinkId != 0)
            {
               if(this._itemMap.containsKey(this._completeItem.hLinkId.toString()))
               {
                  (this._itemMap.getValue(this._completeItem.hLinkId.toString()) as CopyItemInfo).isOpen = 1;
               }
            }
            if(this._completeItem.vLinkId != 0)
            {
               if(this._itemMap.containsKey(this._completeItem.vLinkId.toString()))
               {
                  (this._itemMap.getValue(this._completeItem.vLinkId.toString()) as CopyItemInfo).isOpen = 1;
               }
            }
            if(this._completeItem.mapId == 80001 || this._completeItem.mapId == 80002)
            {
               this._dispatcher.dispatchEvent(new CopyEvent("complete",this._completeItem.mapId));
            }
            this._completeItem = null;
         }
      }
      
      private function onGetComplete(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.CLI_SET_WIN_COPY_1237,this.onGetComplete);
         Connection.removeErrorHandler(CommandSet.CLI_SET_WIN_COPY_1237,this.onGetError);
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc3_:int = _loc2_.readByte();
         if(this._completeItem.mapId == _loc4_)
         {
            this._completeItem.isComplete = 1;
            if(this._completeItem.hLinkId != 0)
            {
               if(this._itemMap.containsKey(this._completeItem.hLinkId.toString()))
               {
                  (this._itemMap.getValue(this._completeItem.hLinkId.toString()) as CopyItemInfo).isOpen = 1;
               }
            }
            if(this._completeItem.vLinkId != 0)
            {
               if(this._itemMap.containsKey(this._completeItem.vLinkId.toString()))
               {
                  (this._itemMap.getValue(this._completeItem.vLinkId.toString()) as CopyItemInfo).isOpen = 1;
               }
            }
            this._dispatcher.dispatchEvent(new CopyEvent("complete",this._completeItem.mapId));
            this._completeItem = null;
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._dispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function onGetError(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.CLI_SET_WIN_COPY_1237,this.onGetComplete);
         Connection.removeErrorHandler(CommandSet.CLI_SET_WIN_COPY_1237,this.onGetError);
      }
      
      private function configXML() : void
      {
         var _loc7_:XML = null;
         var _loc6_:Array = null;
         var _loc2_:XML = null;
         var _loc1_:CopyItemInfo = null;
         var _loc3_:String = null;
         this._itemMap = new HashMap();
         var _loc5_:XML = XML(new this._xmlClass());
         var _loc4_:XMLList = _loc5_.elements();
         for each(_loc7_ in _loc4_)
         {
            for each(_loc2_ in _loc7_.elements())
            {
               _loc1_ = new CopyItemInfo(int(_loc2_.@mapId),int(_loc2_.@mode),int(_loc2_.@isOpen),int(_loc2_.@hLinkId),int(_loc2_.@vLinkId),String(_loc2_.@tipOpen),String(_loc2_.@tipClose),String(_loc2_.@animationStr),uint(_loc2_.@passMiId),String(_loc2_.@miFull));
               _loc1_.parentId = int(_loc7_.@id);
               _loc3_ = String(_loc2_.@mapId);
               this._itemMap.put(_loc3_,_loc1_);
            }
         }
         _loc6_ = this._itemMap.values();
      }
   }
}

