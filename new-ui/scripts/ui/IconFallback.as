package ui
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol63")]
   public dynamic class IconFallback extends MovieClip
   {
      
      public function IconFallback()
      {
         super();
         addEventListener("addedToStage",onStageAdded);
      }
      
      private function onStageAdded(param1:Event) : void
      {
         removeEventListener("addedToStage",onStageAdded);
         checkAndCorrect();
      }
      
      private function checkAndCorrect() : void
      {
         try
         {
            if(transform.concatenatedMatrix.a < 0)
            {
               this.scaleX *= -1;
               this.x += this.width;
            }
         }
         catch(e:*)
         {
         }
      }
   }
}

