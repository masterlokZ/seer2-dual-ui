package seer2.next.entry
{
   import flash.system.Capabilities;
   
   public class DynSwitch
   {
      
      public static var bloomfilterFallbackUrl:String;
      
      public static var simulateSendingProtocolHint:String;
      
      public static var changeLogModifyTime:String;
      
      public static var changeLogModifyUser:String;
      
      public static var changeLogAnnouncement:String;
      
      public static var clearMode:Boolean;
      
      public static var autobsMode:Boolean;
      
      public static var hitDmgMode:Boolean;
      
      public static var _xml:XML;
      
      public static const isAIR:Boolean = Capabilities.playerType == "Desktop";
      
      public function DynSwitch()
      {
         super();
      }
      
      public static function loadConfig(xml:XML) : void
      {
         _xml = xml;
         bloomfilterFallbackUrl = _xml.bloomfilter.@fallbackurl;
         simulateSendingProtocolHint = _xml.simulatesendingprotocolhint;
         changeLogModifyTime = _xml.changelog.@modifytime;
         changeLogModifyUser = _xml.changelog.@modifyuser;
         changeLogAnnouncement = _xml.changelog;
      }
   }
}

