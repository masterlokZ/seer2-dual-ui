package animation.event
{
   import flash.events.Event;
   
   public class Events
   {
      
      public static const ALERT_END:String = "alertEnd";
      
      public static const ANIMATION_END:String = "animationEnd";
      
      public static const BTN_MORPH_CLICK:String = "btnMorphClick";
      
      public static const BTN_AUTO_CLICK:String = "btnAutoClick";
      
      public static const BTN_SETTING_CLICK:String = "btnSettingClick";
      
      public static const FRAME_PLAY_END:String = "framePlayEnd";
      
      public static const FRAME_MOVE_HIT:String = "frameMoveHit";
      
      public function Events()
      {
         super();
      }
      
      public static function alertEnd() : Event
      {
         return new Event("alertEnd");
      }
      
      public static function animationEnd() : Event
      {
         return new Event("animationEnd");
      }
      
      public static function btnMorphClick() : Event
      {
         return new Event("btnMorphClick",true);
      }
      
      public static function btnAutoClick() : Event
      {
         return new Event("btnAutoClick",true);
      }
      
      public static function btnSettingClick() : Event
      {
         return new Event("btnSettingClick",true);
      }
      
      public static function framePlayEnd() : Event
      {
         return new Event("framePlayEnd");
      }
      
      public static function frameMoveHit() : Event
      {
         return new Event("frameMoveHit");
      }
   }
}

