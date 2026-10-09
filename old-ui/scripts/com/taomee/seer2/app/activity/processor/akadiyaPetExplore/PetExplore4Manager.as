package com.taomee.seer2.app.activity.processor.akadiyaPetExplore
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.manager.EventListenerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   import org.taomee.utils.DisplayUtil;
   
   public class PetExplore4Manager
   {
      
      private static const MAP_ID:int = 80586;
      
      private static var _eventListenerMgr:EventListenerManager;
      
      private static var _fightId:int;
      
      private static const ITEM_IDS:Array = [202019,202020,202021,202022];
      
      public function PetExplore4Manager()
      {
         super();
      }
      
      public static function start() : void
      {
         if(SceneManager.active.mapID == 80586)
         {
            initMap();
         }
         else
         {
            SceneManager.changeScene(9,80586);
         }
         SceneManager.addEventListener("switchComplete",onMapSwitch);
      }
      
      private static function onMapSwitch(param1:SceneEvent) : void
      {
         var _loc2_:int = 0;
         if(SceneManager.active.type != 2)
         {
            _loc2_ = SceneManager.active.mapID;
            if(80586 == _loc2_)
            {
               initMap();
            }
            else if(_eventListenerMgr != null)
            {
               _eventListenerMgr.clear();
               _eventListenerMgr = null;
               SceneManager.removeEventListener("switchComplete",onMapSwitch);
            }
         }
      }
      
      private static function initMap() : void
      {
         if(_eventListenerMgr == null)
         {
            _eventListenerMgr = new EventListenerManager();
         }
         _eventListenerMgr.addEventListener(SceneManager.active.mapModel.content,"click",onMapClick);
      }
      
      private static function onMapClick(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.target.name);
         var _loc3_:int = parseInt(_loc2_.split("_")[1]);
         switch(_loc2_)
         {
            case "npc":
               onNpcClick();
               break;
            case "item":
               onItemClick(param1.target as DisplayObject);
               break;
            case "leaveBtn":
               SceneManager.changeScene(1,70);
         }
      }
      
      private static function onItemClick(param1:DisplayObject) : void
      {
         var icon:DisplayObject = param1;
         DisplayUtil.removeForParent(icon);
         SwapManager.swapItem(4635,1,function(param1:IDataInput):void
         {
            new SwapInfo(param1);
         });
      }
      
      private static function onNpcClick() : void
      {
         NpcDialog.showDialogs(Dialog_0,fight,buyFightChance);
      }
      
      private static function fight() : void
      {
         var dialog:Array = null;
         if(isItemEngough)
         {
            fightBoss(1868);
         }
         else
         {
            dialog = [[3129,"源晶蛋",[[0,"唔，窝移动不怎么方便QAQ尼可以每天都来这里收集点石头放在窝旁边……此外，【阿卡迪亚星各处的｛矿脉｝都有机会挖掘出窝喜欢的这种石头！】尼可以去试试吖！~~"]],["行吧，我这就去帮你找更多的石头！"]]];
            NpcDialog.showDialogs(dialog,function():void
            {
            });
         }
      }
      
      private static function fightBoss(param1:int) : void
      {
         _fightId = param1;
         SceneManager.addEventListener("switchComplete",onFightOver);
         FightManager.startFightWithWild(_fightId);
      }
      
      private static function onFightOver(param1:* = null) : void
      {
         if(SceneManager.prevSceneType == 2)
         {
            if(_fightId == FightManager.currentFightRecord.initData.positionIndex)
            {
               SceneManager.removeEventListener("switchComplete",onFightOver);
               SceneManager.changeScene(1,70);
            }
         }
      }
      
      private static function buyFightChance() : void
      {
         var dialog:Array = null;
         dialog = [[3129,"源晶蛋",[[0,"……虽然有一股奇怪的铜臭味不过嚼劲还是不错的，啊呜啊呜……好吧窝就勉为其难地给你个机会吧~"]],["卧槽，它它它嚼得动星钻！！（震惊 )"]]];
         ShopManager.buyItemForId(607090,function():void
         {
            NpcDialog.showDialogs(dialog,function():void
            {
               fightBoss(1869);
            });
         });
      }
      
      private static function get isItemEngough() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < ITEM_IDS.length)
         {
            _loc1_ = int(ITEM_IDS[_loc2_]);
            if(ItemManager.getItemQuantityByReferenceId(_loc1_) < 20)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      private static function getItemStr() : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "尼现在有 ";
         var _loc1_:int = 0;
         while(_loc1_ < ITEM_IDS.length)
         {
            _loc3_ = int(ITEM_IDS[_loc1_]);
            _loc2_ += "<font color=\'#ff0000\'>" + ItemManager.getItemQuantityByReferenceId(_loc3_) + "</font>" + " 块【" + ItemConfig.getItemName(_loc3_) + "】 ";
            _loc1_++;
         }
         return _loc2_;
      }
      
      private static function get Dialog_0() : Array
      {
         return [[3129,"源晶蛋",[[0,"啊呜……尼发现窝辣。"]],[" 你…………是什么玩意= =？"]],[3129,"源晶蛋",[[0,"窝？窝是石头辣。……啊不对，窝是蛋辣。啊不对不对！窝到底是什么吖……"]],["……你是精灵吧！我要捕捉你！ "]],[3129,"源晶蛋",[[0,"唔……窝喜欢吃那种石头。这里有好多那种石头！（嘴馋OAQ）。"]],[" 你要多少？= =（居然吃石头？！）"]],[3129,"源晶蛋",[[0,"每种都给窝20个，窝就和尼打一架！！哇吖吖(ŐдŐ)b" + getItemStr()]],[" 那就来吧！！ ","我这有种叫星钻的石头你看行吗……"]]];
      }
   }
}

