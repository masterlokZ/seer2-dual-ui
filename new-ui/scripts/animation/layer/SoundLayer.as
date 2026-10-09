package animation.layer
{
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import utils.CacheUtils;
   
   public class SoundLayer
   {
      
      private var currentSkillSound:SoundChannel;
      
      private var currentSkillSoundUrl:String;
      
      private var currentPetSound:SoundChannel;
      
      private var currentPetSoundUrl:String;
      
      private var currentMapSound:SoundChannel;
      
      private var currentMapSoundUrl:String;
      
      private var _globalSound:Number = 1;
      
      private var _mapSound:Number = 1;
      
      public function SoundLayer()
      {
         super();
      }
      
      public function playSkillSound(param1:String) : void
      {
         var url:String = param1;
         var clearSound:* = function():void
         {
            if(currentSkillSound)
            {
               currentSkillSound.stop();
               currentSkillSound = null;
            }
         };
         clearSound();
         currentSkillSoundUrl = url;
         if(!url)
         {
            return;
         }
         CacheUtils.loadSkillSound(url,function(param1:Sound):void
         {
            if(currentSkillSoundUrl !== url)
            {
               return;
            }
            clearSound();
            currentSkillSound = param1.play();
         });
      }
      
      public function playPetSound(param1:String) : void
      {
         var url:String = param1;
         var clearSound:* = function():void
         {
            if(currentPetSound)
            {
               currentPetSound.stop();
               currentPetSound = null;
            }
         };
         clearSound();
         currentPetSoundUrl = url;
         if(!url)
         {
            return;
         }
         CacheUtils.loadPetSound(url,function(param1:Sound):void
         {
            if(currentPetSoundUrl !== url)
            {
               return;
            }
            clearSound();
            currentPetSound = param1.play();
         });
      }
      
      public function playMapSound(param1:String) : void
      {
         var url:String = param1;
         if(currentMapSoundUrl === url)
         {
            return;
         }
         currentMapSoundUrl = url;
         if(!url)
         {
            return;
         }
         CacheUtils.loadMapSound(url,function(param1:Sound):void
         {
            if(currentMapSoundUrl !== url)
            {
               return;
            }
            clearMapSound();
            currentMapSound = param1.play(0,2147483647);
            currentMapSound.soundTransform = new SoundTransform(_mapSound);
         });
      }
      
      public function clearMapSound() : void
      {
         if(currentMapSound)
         {
            currentMapSound.stop();
            currentMapSound = null;
         }
      }
      
      public function updateGlobalSound(param1:Number) : void
      {
         param1 = Math.max(Math.min(param1,1),0);
         if(param1 === _globalSound)
         {
            return;
         }
         _globalSound = param1;
         SoundMixer.soundTransform = new SoundTransform(_globalSound);
      }
      
      public function updateMapSound(param1:Number) : void
      {
         param1 = Math.max(Math.min(param1,1),0);
         if(param1 === _mapSound)
         {
            return;
         }
         _mapSound = param1;
         if(!currentMapSound)
         {
            return;
         }
         currentMapSound.soundTransform = new SoundTransform(_mapSound);
      }
   }
}

