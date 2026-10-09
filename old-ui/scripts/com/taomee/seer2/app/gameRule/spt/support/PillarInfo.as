package com.taomee.seer2.app.gameRule.spt.support
{
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import flash.display.MovieClip;
   
   public class PillarInfo
   {
      
      public var type:uint;
      
      public var pillarMC:MovieClip;
      
      public var effectMC:MovieClip;
      
      public var count:uint = 0;
      
      public function PillarInfo(param1:uint, param2:MovieClip, param3:MovieClip)
      {
         super();
         this.type = param1;
         this.effectMC = param3;
         param3.gotoAndPlay("status1");
         param3.mouseChildren = false;
         param3.mouseEnabled = false;
         this.pillarMC = param2;
         param2.buttonMode = true;
         param2.useHandCursor = true;
         this.setTip();
      }
      
      private function setTip() : void
      {
         var _loc1_:String = "";
         switch(int(this.type))
         {
            case 0:
               _loc1_ = "物攻";
               break;
            case 1:
               _loc1_ = "物防";
               break;
            case 2:
               _loc1_ = "特攻";
               break;
            case 3:
               _loc1_ = "特防";
               break;
            case 4:
               _loc1_ = "速度";
         }
         TooltipManager.addCommonTip(this.pillarMC,_loc1_);
      }
   }
}

