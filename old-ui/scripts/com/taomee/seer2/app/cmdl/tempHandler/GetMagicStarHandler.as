package com.taomee.seer2.app.cmdl.tempHandler
{
   import com.taomee.seer2.app.net.parser.Parser_1548;
   
   public class GetMagicStarHandler implements IHandler
   {
      
      public function GetMagicStarHandler()
      {
         super();
      }
      
      public function handle(param1:Parser_1548) : void
      {
         var _loc2_:uint = 0;
         if(param1 && param1.eventDataVec && param1.eventDataVec.length > 0)
         {
            _loc2_ = param1.eventDataVec[0];
         }
      }
   }
}

