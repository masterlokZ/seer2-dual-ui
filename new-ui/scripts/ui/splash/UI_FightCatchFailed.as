package ui.splash
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol303")]
   public dynamic class UI_FightCatchFailed extends MovieClip
   {
      
      public function UI_FightCatchFailed()
      {
         super();
         addFrameScript(160,this.frame161);
      }
      
      internal function frame161() : *
      {
         stop();
         dispatchEvent(new Event("end",true));
      }
   }
}

