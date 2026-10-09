package com.taomee.seer2.core.scene
{
   import org.taomee.utils.DomainUtil;
   
   public class SceneTypeFactory
   {
      
      public function SceneTypeFactory()
      {
         super();
      }
      
      public static function createScene(param1:int) : BaseScene
      {
         var _loc2_:Class = null;
         switch(param1 - 1)
         {
            case 0:
            case 8:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.lobby.LobbyScene");
               break;
            case 1:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.arena.ArenaScene");
               break;
            case 2:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.home.HomeScene");
               break;
            case 3:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.team.TeamScene");
               break;
            case 4:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.novice.NoviceScene");
               break;
            case 5:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.firstTeach.guide.GudieArenaScene");
               break;
            case 6:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.lobby.BigLobbyScene");
               break;
            case 7:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.plant.PlantScene");
               break;
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.firstTeach.guide.GudieArenaScene2");
               break;
            default:
               _loc2_ = BaseScene;
         }
         return new _loc2_(param1);
      }
      
      public static function createMapLoader(param1:int) : BaseMapLoader
      {
         var _loc2_:Class = null;
         switch(param1 - 7)
         {
            case 0:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.core.scene.BigMapLoader");
               break;
            default:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.core.scene.MapLoader");
         }
         return new _loc2_();
      }
      
      public static function createMessageGateWay(param1:BaseScene) : MessageGateWay
      {
         var _loc2_:Class = null;
         switch(param1.type - 1)
         {
            case 0:
            case 3:
            case 6:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.lobby.LobbyMessageGateWay");
               break;
            case 1:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.arena.ArenaMessageGateWay");
               break;
            case 2:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.home.HomeMessageGateWay");
               break;
            case 4:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.novice.NoviceMessageGateWay");
               break;
            case 7:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.home.HomeMessageGateWay");
               break;
            case 8:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.copy.CopyMessageGateWay");
               break;
            default:
               _loc2_ = MessageGateWay;
         }
         return new _loc2_(param1);
      }
      
      public static function createSceneHandlerGateWay(param1:BaseScene) : SceneHandlerGateWay
      {
         var _loc2_:Class = null;
         switch(param1.type - 1)
         {
            case 0:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.lobby.LobbySceneHandlerGateWay");
               break;
            case 2:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.home.HomeSceneHandlerGateWay");
               break;
            default:
               _loc2_ = SceneHandlerGateWay;
         }
         return new _loc2_(param1);
      }
      
      public static function createSwitchPreProcessor(param1:int) : SwitchPreProcessor
      {
         var _loc2_:Class = null;
         switch(param1 - 1)
         {
            case 0:
            case 8:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.LobbyPreProcessor");
               break;
            case 1:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.ArenaPreProcessor");
               break;
            case 2:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.HomePreProcessor");
               break;
            case 3:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.TeamPreProcessor");
               break;
            case 5:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.GudieArenaPreProcessor");
               break;
            case 6:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.LobbyPreProcessor");
               break;
            case 7:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.PlantPreProcessor");
               break;
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
               _loc2_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.scene.preProcessor.GudieNewArenaPreProcessor");
               break;
            default:
               _loc2_ = SwitchPreProcessor;
         }
         return new _loc2_();
      }
   }
}

