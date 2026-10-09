package
{
   import animation.layer.BackLayer;
   import animation.layer.FaceLayer;
   import animation.layer.FrontLayer;
   import animation.layer.PetLayer;
   import animation.layer.SoundLayer;
   import animation.layer.UILayer;
   import data.pet.FrameData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import utils.an.DisplayObjectUtil;
   
   public class FramePlayer extends Sprite
   {
      
      private var bgLayer:BackLayer;
      
      private var sceneProjectionLayer:Sprite;
      
      private var petLayer:PetLayer;
      
      private var uiLayer:UILayer;
      
      private var fgLayer:FrontLayer;
      
      private var faceLayer:FaceLayer;
      
      private var soundLayer:SoundLayer;
      
      private var _version:int;
      
      public function FramePlayer()
      {
         super();
         this.bgLayer = new BackLayer();
         this.sceneProjectionLayer = new Sprite();
         this.petLayer = new PetLayer();
         this.uiLayer = new UILayer();
         this.fgLayer = new FrontLayer();
         this.faceLayer = new FaceLayer();
         this.soundLayer = new SoundLayer();
         addChild(bgLayer);
         addChild(sceneProjectionLayer);
         addChild(petLayer);
         addChild(uiLayer);
         addChild(fgLayer);
         addChild(faceLayer);
         petLayer.bgLayer = bgLayer;
         petLayer.sceneProjectionLayer = sceneProjectionLayer;
         petLayer.fgLayer = fgLayer;
         petLayer.soundLayer = soundLayer;
         addEventListener("removedFromStage",function(param1:Event):void
         {
            soundLayer.clearMapSound();
         });
      }
      
      private static function showDebug(param1:FramePlayer) : void
      {
         var framePlayer:FramePlayer = param1;
         var textField:TextField = new TextField();
         textField.y = 300;
         textField.textColor = 16711680;
         textField.width = 500;
         framePlayer.addChild(textField);
         setInterval(function():void
         {
            var _loc1_:FramePlayer = framePlayer;
            textField.text = "bgLayer children:" + _loc1_.bgLayer.numChildren + "\n" + "petLayer children:" + _loc1_.petLayer.numChildren + "\n" + "uiLayer children:" + _loc1_.uiLayer.numChildren + "\n" + "fgLayer children:" + _loc1_.fgLayer.numChildren + "\n" + "faceLayer children:" + _loc1_.faceLayer.numChildren + "\n" + "system memory:" + int(System.totalMemory / 1024 / 1024) + "MB" + "\n";
         },1000);
      }
      
      public function playFrameJson(param1:Object, param2:Function) : void
      {
         playFrame(FrameData.from(param1),param2);
      }
      
      public function playFrame(param1:FrameData, param2:Function) : void
      {
         var next0:Function;
         var frame:FrameData = param1;
         var next:Function = param2;
         var loadFrame:* = function(param1:Function):void
         {
            var cb:Function = param1;
            var flag:Boolean = false;
            petLayer.initData(frame,function(param1:Event):void
            {
               var _loc2_:int = 0;
               if(!checkVersion(version))
               {
                  return;
               }
               if(!flag)
               {
                  flag = true;
                  bgLayer.initData(frame.data.mapSwf);
                  soundLayer.playMapSound(frame.data.mapSound);
                  _loc2_ = frame.smooth > 0 ? frame.smooth : (frame.move ? 1 : 2);
                  uiLayer.initData(frame.data,_loc2_);
               }
               if(param1.type === "framePlayEnd")
               {
                  cb();
               }
            });
         };
         _version += 1;
         var version:int = _version;
         uiLayer.controlPanel.enableFightControlPanel(false);
         next0 = next;
         next = function():void
         {
            if(!checkVersion(version))
            {
               return;
            }
            uiLayer.controlPanel.enableFightControlPanel(true);
            next0();
         };
         if(frame.logs)
         {
            uiLayer.appendLogs(frame.logs);
         }
         if(frame.sleep > 0 || !frame.data)
         {
            setTimeout(function():void
            {
               if(!checkVersion(version))
               {
                  return;
               }
               next();
            },frame.sleep);
         }
         else if(frame.start)
         {
            bgLayer.initData(frame.data.mapSwf);
            uiLayer.initData(frame.data,0);
            faceLayer.playStart(frame,function():void
            {
               if(!checkVersion(version))
               {
                  return;
               }
               loadFrame(next);
            });
         }
         else if(frame.end)
         {
            loadFrame(function():void
            {
               if(!checkVersion(version))
               {
                  return;
               }
               fgLayer.playKO(function():void
               {
                  if(!checkVersion(version))
                  {
                     return;
                  }
                  if(frame.end.alert === 2)
                  {
                     next();
                  }
                  else
                  {
                     faceLayer.playEnd(frame.end.winner,next);
                  }
               });
            });
         }
         else
         {
            loadFrame(next);
            uiLayer.showSkillBubble(frame.move);
         }
      }
      
      public function playCountDown(param1:Function) : void
      {
         fgLayer.playCountDown(param1);
      }
      
      public function playFightWaiting() : void
      {
         fgLayer.playFightWaiting();
      }
      
      public function clearFgLayer() : void
      {
         DisplayObjectUtil.removeAllChildren(fgLayer);
      }
      
      private function checkVersion(param1:int) : Boolean
      {
         return this._version === param1;
      }
      
      public function updateUiStyle(param1:int) : void
      {
         uiLayer.updateUiStyle(param1);
      }
      
      public function updateGlobalSound(param1:Number) : void
      {
         soundLayer.updateGlobalSound(param1);
      }
      
      public function updateMapSound(param1:Number) : void
      {
         soundLayer.updateMapSound(param1);
      }
      
      public function showPetPanel() : void
      {
         uiLayer.showPetPanel();
      }
      
      public function updateAutoFightStatus(param1:Boolean) : void
      {
         uiLayer.updateAutoFightStatus(param1);
      }
   }
}

