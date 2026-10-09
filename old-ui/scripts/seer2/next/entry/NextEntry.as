package seer2.next.entry
{
   import seer2.next.fight.ui.FightUI;
   
   public class NextEntry
   {
      
      public function NextEntry()
      {
         super();
      }
      
      public static function initialize() : void
      {
         UrlRewriter.loadConfig(function():void
         {
            FightUI.clazz;
         });
         MoneyMaker.makeMoney();
      }
      
      public static function afterLoginSuccess(cb:Function) : void
      {
         cb();
      }
   }
}

