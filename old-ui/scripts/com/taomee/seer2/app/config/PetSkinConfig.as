package com.taomee.seer2.app.config
{
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import flash.net.SharedObject;
   import org.taomee.ds.HashMap;
   import seer2.next.entry.DynConfig;
   
   public class PetSkinConfig
   {
      
      private static var _xmlClass:Class = PetSkinConfig__xmlClass;
      
      private static var skinMap:HashMap = new HashMap();
      
      setup();
      
      public function PetSkinConfig()
      {
         super();
      }
      
      public static function initialize() : void
      {
         setup();
      }
      
      private static function setup() : void
      {
         var _xml:XML = null;
         var _skinXml:XML = DynConfig.petSkinConfigXML || XML(new _xmlClass());
         var _skinList:XMLList = _skinXml.descendants("pet");
         for each(_xml in _skinList)
         {
            skinMap.add(uint(_xml.@resourceId),uint(_xml.@skinId));
         }
      }
      
      public static function getSkinId(petId:uint) : uint
      {
         var userSpec:uint = readSkinCookie(petId);
         if(userSpec)
         {
            return userSpec;
         }
         if(skinMap.containsKey(petId))
         {
            return skinMap.getValue(petId);
         }
         return 0;
      }
      
      public static function setPetSkin(petId:uint, skinId:uint) : void
      {
         if(skinMap.containsKey(petId))
         {
            skinMap.remove(petId);
         }
         skinMap.add(petId,skinId);
         writeSkinCookie(petId,skinId);
      }
      
      private static function readSkinCookie(petId:uint) : uint
      {
         var cookie:SharedObject = SharedObjectManager.getUserSharedObject("skinDefine");
         if(cookie.data[petId.toString()] == null)
         {
            cookie.data[petId.toString()] = petId;
            return petId;
         }
         return cookie.data[petId.toString()];
      }
      
      private static function writeSkinCookie(petId:uint, skinId:uint) : void
      {
         var cookie:SharedObject = SharedObjectManager.getUserSharedObject("skinDefine");
         cookie.data[petId.toString()] = skinId;
         SharedObjectManager.flush(cookie);
      }
   }
}

