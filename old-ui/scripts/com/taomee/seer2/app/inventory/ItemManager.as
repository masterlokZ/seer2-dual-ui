package com.taomee.seer2.app.inventory
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.config.EquipElementConfig;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.inventory.constant.ItemIdRange;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.inventory.item.CollectionItem;
   import com.taomee.seer2.app.inventory.item.EmblemItem;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.inventory.item.MedalItem;
   import com.taomee.seer2.app.inventory.item.PetItem;
   import com.taomee.seer2.app.inventory.item.PetSpirtTrainItem;
   import com.taomee.seer2.app.inventory.item.SpecialItem;
   import com.taomee.seer2.app.inventory.utils.ItemCategoryUtil;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1051;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.debugTools.MapPanelProtocolPanel;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.log.Logger;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.IDataInput;
   import org.taomee.bean.BaseBean;
   import org.taomee.ds.HashMap;
   
   public class ItemManager extends BaseBean
   {
      
      private static var _logger:Logger;
      
      private static var _hasGetEquip:Boolean;
      
      private static var _hasGetItem:Boolean;
      
      private static var _hasGetSpecialItem:Boolean;
      
      private static var _requestItemCallBack:Function;
      
      private static var _requestEquipCallBack:Function;
      
      private static var _isLoadingData:Boolean;
      
      private static var _evtRemoter:EventDispatcher;
      
      private static var _inventory:SeerIIInventory;
      
      private static var _specialItemMap:HashMap;
      
      private static var _success:Function;
      
      public static var _getCoinsMessageSwitch:Boolean = true;
      
      private static const HOLD_CMD_FOR_ITEM_GIVEN_ARR:Array = [1123,1162,1055,1140];
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public function ItemManager()
      {
         super();
      }
      
      public static function setup() : void
      {
      }
      
      public static function canAddItem(param1:Item) : Boolean
      {
         return _inventory.canAddItem(param1);
      }
      
      public static function removeItemByReferenceId(param1:int) : void
      {
         _inventory.removeItemByReferenceId(param1);
      }
      
      public static function reduceItemQuantity(param1:int, param2:int) : void
      {
         if(ItemCategoryUtil.findItemCategoryByReferenceId(param1) == 101)
         {
            reduceSpecialItem(param1,param2);
         }
         else
         {
            _inventory.reduceItemQuantity(param1,param2);
         }
      }
      
      public static function contains(param1:Item) : Boolean
      {
         return _inventory.contains(param1);
      }
      
      public static function containsReferenceId(param1:int) : Boolean
      {
         return _inventory.containsUniqueId(param1);
      }
      
      public static function getItemByReferenceId(param1:int) : Item
      {
         return _inventory.getItemByUniqueId(param1);
      }
      
      public static function getItemQuantityByReferenceId(param1:int) : int
      {
         return _inventory.getItemQuantityByUniqueId(param1);
      }
      
      public static function getContent() : Vector.<Item>
      {
         return _inventory.getContent();
      }
      
      public static function getItemArr() : Array
      {
         return _inventory.getItemArr();
      }
      
      public static function addEquipItem(param1:EquipItem) : void
      {
         _inventory.addEquipItem(param1);
      }
      
      public static function removeEquipItem(param1:EquipItem) : void
      {
         _inventory.removeEquip(param1);
      }
      
      public static function getEquipVec() : Vector.<EquipItem>
      {
         return _inventory.getEquipVec();
      }
      
      public static function getEquipItem(param1:int) : EquipItem
      {
         return _inventory.getEquipItem(param1);
      }
      
      public static function addPetItem(param1:PetItem) : void
      {
         _inventory.addPetItem(param1);
      }
      
      public static function removePetItem(param1:PetItem) : void
      {
         _inventory.removePetItem(param1);
      }
      
      public static function getPetRelateVec() : Vector.<PetItem>
      {
         return _inventory.getPetRelateVec();
      }
      
      public static function getPetRelateitem(param1:int) : PetItem
      {
         return _inventory.getPetRelateItem(param1);
      }
      
      public static function addEmblemItem(param1:EmblemItem) : void
      {
         _inventory.addEmblemItem(param1);
      }
      
      public static function removeEmblemItem(param1:EmblemItem) : void
      {
         _inventory.removeEmblemItem(param1);
      }
      
      public static function getEmblemVec() : Vector.<EmblemItem>
      {
         return _inventory.getEmblemVec();
      }
      
      public static function addCollectionItem(param1:CollectionItem) : void
      {
         _inventory.addCollectionItem(param1);
      }
      
      public static function removeCollectionItem(param1:CollectionItem) : void
      {
         _inventory.removeCollectionItem(param1);
      }
      
      public static function addPetSpirtTrainItem(param1:PetSpirtTrainItem) : void
      {
         _inventory.addPetSpirtTrainItem(param1);
      }
      
      public static function removePetSpirtTrainItem(param1:PetSpirtTrainItem) : void
      {
         _inventory.removePetSpirtTrainItem(param1);
      }
      
      public static function getCollectionVec() : Vector.<CollectionItem>
      {
         return _inventory.getCollectionVec();
      }
      
      public static function getCollection(param1:uint) : CollectionItem
      {
         return _inventory.getCollection(param1);
      }
      
      public static function getPetSpirtTrainVec() : Vector.<PetSpirtTrainItem>
      {
         return _inventory.getPetSpirtTrainVec();
      }
      
      public static function getPetSpirtTrain(param1:uint) : PetSpirtTrainItem
      {
         return _inventory.getPetSpirtTrain(param1);
      }
      
      public static function addMedalItem(param1:MedalItem) : void
      {
         _inventory.addMedalItem(param1);
      }
      
      public static function removeMedalItem(param1:MedalItem) : void
      {
         _inventory.removeMedalItem(param1);
      }
      
      public static function getMedalVec() : Vector.<MedalItem>
      {
         return _inventory.getMedalVec();
      }
      
      public static function addSpecialItem(param1:SpecialItem) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:SpecialItem = null;
         if(getSpecialItem(param1.referenceId) == null)
         {
            _specialItemMap.add(param1.referenceId,param1);
         }
         else
         {
            _loc2_ = getSpecialItem(param1.referenceId).quantity;
            _loc4_ = _loc2_ + param1.quantity;
            _loc3_ = param1;
            _specialItemMap.remove(param1.referenceId);
            _loc3_.quantity = _loc4_;
            _specialItemMap.add(_loc3_.referenceId,_loc3_);
         }
      }
      
      public static function reduceSpecialItem(param1:uint, param2:uint) : void
      {
         if(_specialItemMap.containsKey(param1) && _specialItemMap.getValue(param1).quantity > param2)
         {
            _specialItemMap.getValue(param1).quantity = _specialItemMap.getValue(param1).quantity - param2;
         }
         else if(_specialItemMap.containsKey(param1))
         {
            _specialItemMap.remove(param1);
         }
      }
      
      public static function removeSpecialItem(param1:uint) : void
      {
         _specialItemMap.remove(param1);
      }
      
      public static function getSpecialItem(param1:uint) : SpecialItem
      {
         return _specialItemMap.getValue(param1);
      }
      
      public static function getSpecialItemVec() : Vector.<SpecialItem>
      {
         return Vector.<SpecialItem>(_specialItemMap.getValues());
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         _evtRemoter.addEventListener(param1,param2);
         _inventory.addEventListener(param1,onInventoryEvent);
      }
      
      private static function onInventoryEvent(param1:Event) : void
      {
         if(_isLoadingData == false)
         {
            _evtRemoter.dispatchEvent(param1.clone());
         }
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         _evtRemoter.removeEventListener(param1,param2);
         _inventory.removeEventListener(param1,onInventoryEvent);
      }
      
      public static function requestSpecialItemList(param1:Boolean = false) : void
      {
         if(!param1)
         {
            if(_hasGetSpecialItem == true)
            {
               ItemManager.dispatchEvent("requestSpecialItemSuccess",null);
            }
            else
            {
               _isLoadingData = true;
               Connection.addCommandListener(CommandSet.ITEM_GET_LIST_1005,onGetSpecialItemList);
               Connection.send(CommandSet.ITEM_GET_LIST_1005,ItemIdRange.SPECIAL_ITEM[0],ItemIdRange.SPECIAL_ITEM[1]);
            }
         }
         else
         {
            _isLoadingData = true;
            Connection.addCommandListener(CommandSet.ITEM_GET_LIST_1005,onGetSpecialItemList);
            Connection.send(CommandSet.ITEM_GET_LIST_1005,ItemIdRange.SPECIAL_ITEM[0],ItemIdRange.SPECIAL_ITEM[1]);
         }
      }
      
      private static function onGetSpecialItemList(param1:MessageEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         Connection.removeCommandListener(CommandSet.ITEM_GET_LIST_1005,onGetSpecialItemList);
         var _loc5_:IDataInput = param1.message.getRawData();
         var _loc7_:int = int(_loc5_.readUnsignedInt());
         var _loc6_:int = 0;
         while(_loc6_ < _loc7_)
         {
            _loc3_ = int(_loc5_.readUnsignedInt());
            _loc2_ = int(_loc5_.readUnsignedShort());
            _loc4_ = _loc5_.readUnsignedInt();
            addSpecial(new SpecialItem(_loc3_,_loc2_,_loc4_));
            _loc6_++;
         }
         _isLoadingData = false;
         _hasGetSpecialItem = true;
         ItemManager.dispatchEvent("requestSpecialItemSuccess",null);
      }
      
      private static function addSpecial(param1:SpecialItem) : void
      {
         if(getSpecialItem(param1.referenceId) == null)
         {
            _specialItemMap.add(param1.referenceId,param1);
         }
         else
         {
            _specialItemMap.remove(param1.referenceId);
            _specialItemMap.add(param1.referenceId,param1);
         }
      }
      
      public static function requestItemList(param1:Function, param2:Boolean = false) : void
      {
         _requestItemCallBack = param1;
         if(_hasGetItem == true && !param2)
         {
            if(_requestItemCallBack != null)
            {
               _requestItemCallBack();
               _requestItemCallBack = null;
            }
            ItemManager.dispatchEvent("requestItemSuccess",null);
         }
         else
         {
            _isLoadingData = true;
            Connection.addCommandListener(CommandSet.ITEM_GET_LIST_1005,onGetItemList);
            Connection.send(CommandSet.ITEM_GET_LIST_1005,ItemIdRange.PET_RELATE[0],ItemIdRange.MEDAL[1]);
         }
      }
      
      private static function onGetItemList(param1:MessageEvent) : void
      {
         var data:IDataInput;
         var count:int;
         var i:int;
         var referenceId:int = 0;
         var quantity:int = 0;
         var expiryTime:uint = 0;
         var event:MessageEvent = param1;
         Connection.removeCommandListener(CommandSet.ITEM_GET_LIST_1005,onGetItemList);
         _inventory.clearItem();
         data = event.message.getRawData();
         count = int(data.readUnsignedInt());
         for(i = 0; i < count; )
         {
            referenceId = int(data.readUnsignedInt());
            quantity = int(data.readUnsignedShort());
            expiryTime = data.readUnsignedInt();
            addItem(referenceId,quantity,expiryTime);
            i++;
         }
         Connection.addCommandListener(CommandSet.ITEM_GET_LIST_1005,(function():*
         {
            var getPetSpirtTrain:Function;
            return getPetSpirtTrain = function(param1:MessageEvent):void
            {
               var _loc3_:int = 0;
               var _loc2_:int = 0;
               var _loc4_:uint = 0;
               Connection.removeCommandListener(CommandSet.ITEM_GET_LIST_1005,getPetSpirtTrain);
               var _loc5_:IDataInput = param1.message.getRawData();
               var _loc7_:int = int(_loc5_.readUnsignedInt());
               var _loc6_:int = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc3_ = int(_loc5_.readUnsignedInt());
                  _loc2_ = int(_loc5_.readUnsignedShort());
                  _loc4_ = _loc5_.readUnsignedInt();
                  addItem(_loc3_,_loc2_,_loc4_);
                  _loc6_++;
               }
               _isLoadingData = false;
               _hasGetItem = true;
               if(_requestItemCallBack != null)
               {
                  _requestItemCallBack();
                  _requestItemCallBack = null;
               }
               ItemManager.dispatchEvent("requestItemSuccess",null);
            };
         })());
         Connection.send(CommandSet.ITEM_GET_LIST_1005,ItemIdRange.PET_SPIRT_TRAIN[0],ItemIdRange.PET_SPIRT_TRAIN[1]);
      }
      
      public static function requestAddItem(param1:int, param2:int) : void
      {
         Connection.addCommandListener(CommandSet.ITEM_ADD_1006,onRequestAddItemSuccess);
         Connection.addErrorHandler(CommandSet.ITEM_ADD_1006,onRequestAddItemFail);
         Connection.send(CommandSet.ITEM_ADD_1006,param1,LittleEndianByteArray.writeIntergerAsUnsignedShort(param2));
         MapPanelProtocolPanel.instance().buyID = param1;
         MapPanelProtocolPanel.instance().addLog(6,"购买协议： " + CommandSet.ITEM_ADD_1006.toString() + " buyID=" + param1);
      }
      
      private static function onRequestAddItemFail(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_ADD_1006,onRequestAddItemSuccess);
         Connection.removeErrorHandler(CommandSet.ITEM_ADD_1006,onRequestAddItemFail);
         switch(int(param1.message.statusCode) - 66)
         {
            case 0:
               AlertManager.showAlert("达到每天的上限");
               break;
            default:
               AlertManager.showAlert("购买失败");
         }
         dispatchEvent("requestAddItemFail",null);
         MapPanelProtocolPanel.instance().addLog(6,"购买协议： buyID=" + MapPanelProtocolPanel.instance().buyID + " 购买失败");
      }
      
      private static function onRequestAddItemSuccess(param1:MessageEvent) : void
      {
         var _loc4_:UserInfo = null;
         Connection.removeCommandListener(CommandSet.ITEM_ADD_1006,onRequestAddItemSuccess);
         Connection.removeErrorHandler(CommandSet.ITEM_ADD_1006,onRequestAddItemFail);
         var _loc5_:IDataInput = param1.message.getRawData();
         var _loc7_:int = int(_loc5_.readUnsignedInt());
         var _loc6_:int = int(_loc5_.readUnsignedShort());
         var _loc3_:uint = _loc5_.readUnsignedInt();
         AlertManager.showItemGainedAlert(_loc7_,_loc6_);
         addItem(_loc7_,_loc6_,_loc3_);
         var _loc2_:uint = _loc5_.readUnsignedInt();
         _loc4_ = ActorManager.actorInfo;
         _loc4_.coins = _loc2_;
         dispatchEvent("requestAddItemSuccess",_loc7_);
         MapPanelProtocolPanel.instance().addLog(6,"购买协议： buyID=" + MapPanelProtocolPanel.instance().buyID + " 购买成功");
      }
      
      public static function addItemList(param1:Vector.<ItemDescription>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            addItem(param1[_loc2_].referenceId,param1[_loc2_].quantity,param1[_loc2_].time);
            _loc2_++;
         }
      }
      
      public static function addItem(param1:uint, param2:int, param3:uint, param4:uint = 0) : void
      {
         var _loc5_:int;
         switch(_loc5_ = ItemCategoryUtil.findItemCategoryByReferenceId(param1))
         {
            case 1:
               addEquipItem(new EquipItem(param1,false,param3,param4));
               break;
            case 2:
               addPetItem(new PetItem(param1,param2,param3,param4));
               break;
            case 3:
               addEmblemItem(new EmblemItem(param1,param2,param3,param4));
               break;
            case 4:
               addCollectionItem(new CollectionItem(param1,param2,param3,param4));
               break;
            case 5:
               addMedalItem(new MedalItem(param1,param2,param3,param4));
               break;
            case 101:
               addSpecialItem(new SpecialItem(param1,param2,param3,param4));
               break;
            case 8:
               addPetSpirtTrainItem(new PetSpirtTrainItem(param1,param2,param3,param4));
         }
      }
      
      public static function requestReduceItemQuantity(param1:int, param2:int) : void
      {
         Connection.addCommandListener(CommandSet.ITEM_REMOVE_1009,onReduceItemQuantity);
         Connection.send(CommandSet.ITEM_REMOVE_1009,param1,LittleEndianByteArray.writeIntergerAsUnsignedShort(param2));
      }
      
      private static function onReduceItemQuantity(param1:MessageEvent) : void
      {
         var _loc2_:UserInfo = null;
         Connection.removeCommandListener(CommandSet.ITEM_REMOVE_1009,onReduceItemQuantity);
         var _loc4_:IDataInput = param1.message.getRawData();
         var _loc6_:int = int(_loc4_.readUnsignedInt());
         var _loc5_:int = int(_loc4_.readUnsignedShort());
         reduceItemQuantity(_loc6_,_loc5_);
         var _loc3_:uint = _loc4_.readUnsignedInt();
         _loc2_ = ActorManager.actorInfo;
         _loc2_.coins = _loc3_;
         dispatchEvent("itemSellout",_loc6_);
      }
      
      public static function requestEquipList(param1:Function, param2:Boolean = false) : void
      {
         _requestEquipCallBack = param1;
         if(_hasGetEquip && param2 == false)
         {
            handlerEquipCallBack();
         }
         else
         {
            _isLoadingData = true;
            Connection.addCommandListener(CommandSet.EQUIP_GET_LIST_1007,onGetEquipList);
            Connection.send(CommandSet.EQUIP_GET_LIST_1007,ItemIdRange.EQUIP[0],ItemIdRange.EQUIP[1]);
         }
      }
      
      private static function onGetEquipList(param1:MessageEvent) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:EquipItem = null;
         Connection.removeCommandListener(CommandSet.EQUIP_GET_LIST_1007,onGetEquipList);
         _inventory.clearEquip();
         var _loc7_:IDataInput = param1.message.getRawData();
         var _loc9_:int = int(_loc7_.readUnsignedInt());
         var _loc8_:int = 0;
         while(_loc8_ < _loc9_)
         {
            _loc4_ = int(_loc7_.readUnsignedInt());
            _loc3_ = _loc7_.readUnsignedByte() == 1;
            _loc6_ = _loc7_.readUnsignedInt();
            _loc5_ = _loc7_.readUnsignedInt();
            _loc2_ = new EquipItem(_loc4_,_loc3_,_loc6_);
            _loc2_.strengLevel = _loc5_;
            _loc2_.elementInfo = EquipElementConfig.getInfo(_loc4_);
            addEquipItem(_loc2_);
            _loc8_++;
         }
         _isLoadingData = false;
         _hasGetEquip = true;
         handlerEquipCallBack();
      }
      
      private static function handlerEquipCallBack() : void
      {
         if(_requestEquipCallBack != null)
         {
            _requestEquipCallBack();
            _requestEquipCallBack = null;
         }
         ItemManager.dispatchEvent("requestEquipSuccess",null);
      }
      
      public static function get hasGetItem() : Boolean
      {
         return _hasGetItem;
      }
      
      public static function get hasGetEquip() : Boolean
      {
         return _hasGetEquip;
      }
      
      private static function onGetConis(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_getCoinsMessageSwitch)
         {
            ServerMessager.addMessage("获得了" + _loc3_ + "赛尔豆");
         }
         ActorManager.actorInfo.coins += _loc3_;
      }
      
      private static function onItemServerGiven(param1:MessageEvent) : void
      {
         var _loc4_:Vector.<ItemDescription> = null;
         var _loc3_:ItemDescription = null;
         var _loc2_:Parser_1051 = new Parser_1051(param1.message.getRawDataCopy());
         if(HOLD_CMD_FOR_ITEM_GIVEN_ARR.indexOf(_loc2_.cmdId) != -1)
         {
            ItemUtil.updateLocal(_loc2_.itemDes);
            dispatchEvent("serverItemGiven",_loc2_);
            _loc4_ = _loc2_.itemDes;
            for each(_loc3_ in _loc4_)
            {
               if(!_loc3_.isPet && _loc3_.isAdd)
               {
                  if(ItemCategoryUtil.isMedal(_loc3_.referenceId))
                  {
                     AlertManager.showMedalGainedAlert(_loc3_.referenceId);
                     if(ItemConfig.getMedalDefinition(_loc3_.referenceId).title != "")
                     {
                        ServerMessager.addMessage("恭喜你获得了[" + ItemConfig.getMedalDefinition(_loc3_.referenceId).title + "称号]");
                     }
                  }
                  else if(ItemCategoryUtil.isEmblem(_loc3_.referenceId))
                  {
                     ServerMessager.addMessage("恭喜你获得了[" + ItemConfig.getItemName(_loc3_.referenceId) + "]");
                  }
                  else if(_loc3_.referenceId >= 500546 && _loc3_.referenceId <= 500548)
                  {
                     ServerMessager.addMessage("次数增加1");
                  }
                  else if(_loc3_.referenceId > 603000 && _loc3_.referenceId <= 610000 || _loc3_.referenceId >= 400266 && _loc3_.referenceId <= 400268 || _loc3_.referenceId == 401067)
                  {
                     ServerMessager.addMessage("恭喜你获得了" + _loc3_.quantity + "个[" + ItemConfig.getItemName(_loc3_.referenceId) + "]");
                  }
                  else if(_loc3_.referenceId == 400188)
                  {
                     ServerMessager.addMessage("恭喜你获得了" + _loc3_.quantity + "个争霸赛奖牌");
                  }
                  else if(_loc3_.referenceId == 400111)
                  {
                     AlertManager.showSpiecalItemGainedAlert(_loc3_.referenceId,_loc3_.quantity);
                  }
                  else
                  {
                     AlertManager.showItemGainedAlert(_loc3_.referenceId,_loc3_.quantity);
                  }
               }
               else if(_loc3_.isPet)
               {
                  ServerMessager.addMessage("获得了" + PetConfig.getPetDefinition(_loc3_.referenceId).name);
               }
            }
         }
         else
         {
            ItemUtil.upateServerGiven(_loc2_.itemDes);
         }
         if(_success != null)
         {
            _success();
         }
      }
      
      private static function onItemServerGiverError(param1:MessageEvent) : void
      {
         if(param1.message.statusCode == 27)
         {
            AlertManager.showAlert("精灵仓库已满");
         }
      }
      
      public static function addListener1051(param1:Function) : void
      {
         _success = param1;
      }
      
      public static function removeListener1051() : void
      {
         _success = null;
      }
      
      public static function changeEquipValidity() : void
      {
         ItemManager.requestEquipList(function():void
         {
            var _loc1_:EquipItem = null;
            var _loc2_:Vector.<EquipItem> = ItemManager.getEquipVec();
            for each(_loc1_ in _loc2_)
            {
               _loc1_.expiryTime = 0;
            }
         });
      }
      
      public static function addEventListener1(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener1(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public static function dispatchEvent(param1:String, param2:*) : void
      {
         if(_dispatcher.hasEventListener(param1))
         {
            _dispatcher.dispatchEvent(new ItemEvent(param1,param2));
         }
      }
      
      public static function hasEventListener(param1:String) : Boolean
      {
         return _dispatcher.hasEventListener(param1);
      }
      
      override public function start() : void
      {
         _logger = Logger.getLogger("ItemManager");
         _specialItemMap = new HashMap();
         _inventory = new SeerIIInventory();
         _inventory.capacity = 2147483647;
         _isLoadingData = false;
         _evtRemoter = new EventDispatcher();
         Connection.addCommandListener(CommandSet.GET_CONIS_1547,onGetConis);
         Connection.addErrorHandler(CommandSet.ITEM_SERVER_GIVE_1051,onItemServerGiverError);
         Connection.addCommandListener(CommandSet.ITEM_SERVER_GIVE_1051,onItemServerGiven);
         finish();
      }
   }
}

