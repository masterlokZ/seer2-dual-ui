package com.taomee.seer2.core.sound
{
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.net.URLRequest;
   import org.taomee.ds.HashMap;
   
   public class NpcSoundManager
   {
      
      private static var _soundSettingData:XML;
      
      private static var _bgPlayer:SceneSoundPlayer;
      
      private static var _soundPlayerMap:HashMap;
      
      private static var _npcId:uint;
      
      private static var _sound:Sound;
      
      private static var _soundChannel:SoundChannel;
      
      initialize();
      
      public function NpcSoundManager()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _bgPlayer = new SceneSoundPlayer();
         _soundPlayerMap = new HashMap();
      }
      
      public static function playNpcSound(param1:uint) : void
      {
         _npcId = param1;
         if(_soundSettingData == null)
         {
            QueueLoader.load(URLUtil.getNpcSoundSetting(),"text",onSettingDataLoaded);
         }
         else
         {
            playSound();
         }
      }
      
      private static function playSound() : void
      {
         var _loc2_:Vector.<String> = getNpcSoundVec();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc1_:int = int(uint(Math.random() * _loc2_.length));
         if(_soundChannel)
         {
            _soundChannel.stop();
         }
         if(_sound)
         {
            _sound.removeEventListener("complete",getOutTime);
         }
         _sound = new Sound();
         _sound.addEventListener("complete",getOutTime);
         _sound.load(new URLRequest(URLUtil.getNpcSound(_loc2_[_loc1_])));
      }
      
      private static function getOutTime(param1:Event) : void
      {
         _sound.removeEventListener("complete",getOutTime);
         _soundChannel = _sound.play();
      }
      
      private static function onSettingDataLoaded(param1:ContentInfo) : void
      {
         var _loc4_:Vector.<String> = null;
         var _loc3_:XML = null;
         _soundSettingData = XML(param1.content);
         var _loc2_:XMLList = _soundSettingData.elements("npc");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = Vector.<String>(String(_loc3_.attribute("soundList")).split(","));
            _soundPlayerMap.add(uint(_loc3_.attribute("id")),_loc4_);
         }
         playSound();
      }
      
      private static function getNpcSoundVec() : Vector.<String>
      {
         if(_soundSettingData)
         {
            return _soundPlayerMap.getValue(_npcId);
         }
         return null;
      }
   }
}

