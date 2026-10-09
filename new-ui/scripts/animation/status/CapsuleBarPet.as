package animation.status
{
   import animation.common.PetIconDisplay;
   import data.pet.PetData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import ui.status.UI_FightCapsulePet;
   import ui.status.UI_FightCapsulePetTip;
   
   internal class CapsuleBarPet extends Sprite
   {
      
      private static const CAPSULE_NUM:int = 6;
      
      private static const CAPSULE_WIDTH:int = 36;
      
      public static const CAPSULE_SIDE_LEFT:int = 0;
      
      public static const CAPSULE_SIDE_RIGHT:int = 1;
      
      private var _backVec:Vector.<MovieClip>;
      
      private var _tipVec:Vector.<MovieClip>;
      
      private var _petIconVec:Vector.<PetIconDisplay>;
      
      private var _side:int = 0;
      
      public function CapsuleBarPet(param1:int = 0)
      {
         var i:int;
         var _loc5_:MovieClip;
         var _loc4_:PetIconDisplay;
         var side:int = param1;
         super();
         this._side = side;
         i = 0;
         _loc5_ = null;
         this._tipVec = new Vector.<MovieClip>();
         while(i < 6)
         {
            _loc5_ = new UI_FightCapsulePetTip();
            _loc5_.x = 36;
            _loc5_.y = i * 36;
            this._tipVec.push(_loc5_);
            _loc5_.visible = false;
            addChild(_loc5_);
            if(this._side)
            {
               _loc5_.scaleX *= -1;
               _loc5_.x += _loc5_.width;
            }
            i = i + 1;
         }
         i = 0;
         this._backVec = new Vector.<MovieClip>();
         while(i < 6)
         {
            (_loc5_ = new UI_FightCapsulePet()).y = i * 36;
            _loc5_["capsule"].gotoAndStop(1);
            _loc5_["back"].gotoAndStop(1);
            _loc5_["cover"].gotoAndStop(1);
            this._backVec.push(_loc5_);
            (function(param1:int):void
            {
               var idx:int = param1;
               _loc5_.addEventListener("mouseOver",function(param1:MouseEvent):void
               {
                  _tipVec[idx].visible = true;
               });
               _loc5_.addEventListener("mouseOut",function(param1:MouseEvent):void
               {
                  _tipVec[idx].visible = false;
               });
            })(i);
            addChild(_loc5_);
            i = i + 1;
         }
         this._petIconVec = new Vector.<PetIconDisplay>();
         _loc4_ = null;
         i = 0;
         while(i < 6)
         {
            (_loc4_ = new PetIconDisplay()).y = i * 36 + 1;
            _loc4_.x = 1;
            this._petIconVec.push(_loc4_);
            _loc4_.setSize(30);
            _loc4_.mask = this._backVec[i]["cover"];
            _loc4_.mouseEnabled = _loc4_.mouseChildren = false;
            _loc4_.visible = false;
            addChild(_loc4_);
            i = i + 1;
         }
         this.visible = false;
      }
      
      public function initData(param1:Vector.<PetData>) : void
      {
         var idx:int;
         var icon:PetIconDisplay;
         var pet:PetData;
         var mc:MovieClip;
         this.visible = true;
         idx = 0;
         while(idx < 6)
         {
            icon = this._petIconVec[idx];
            if(idx < param1.length)
            {
               pet = param1[idx];
               icon.initData(pet.petIcon);
               if(!pet.ext || pet.ext.showIcon)
               {
                  icon.visible = true;
                  mc = this._backVec[idx]["capsule"];
                  if(mc.currentFrame == 1)
                  {
                     (function(param1:MovieClip):void
                     {
                        var m:MovieClip = param1;
                        m.addFrameScript(m.totalFrames - 1,function():void
                        {
                           m.stop();
                        });
                     })(mc);
                     mc.play();
                  }
                  mc = this._backVec[idx]["back"];
                  if(mc.currentFrame == 1)
                  {
                     (function(param1:MovieClip):void
                     {
                        var m:MovieClip = param1;
                        m.addFrameScript(m.totalFrames - 1,function():void
                        {
                           m.stop();
                        });
                     })(mc);
                     mc.play();
                  }
                  mc = this._backVec[idx]["cover"];
                  if(mc.currentFrame == 1)
                  {
                     (function(param1:MovieClip):void
                     {
                        var m:MovieClip = param1;
                        m.addFrameScript(m.totalFrames - 1,function():void
                        {
                           m.stop();
                        });
                     })(mc);
                     mc.play();
                  }
                  this._tipVec[idx]["nameTxt"].text = pet.name;
                  this._tipVec[idx]["hpTxt"].text = pet.hp + "/" + pet.maxHp;
               }
               else
               {
                  icon.visible = false;
                  this._tipVec[idx]["nameTxt"].text = "???";
                  this._tipVec[idx]["hpTxt"].text = "???/???";
               }
               if(pet.alive > 0)
               {
                  setColor(icon,true);
               }
               else
               {
                  setColor(icon,false);
               }
            }
            else
            {
               this._backVec[idx].visible = false;
               icon.visible = false;
            }
            idx = idx + 1;
         }
      }
      
      private function setColor(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc3_:ColorTransform = new ColorTransform();
         if(!param2)
         {
            _loc3_.redMultiplier = 0.33;
            _loc3_.greenMultiplier = 0.33;
            _loc3_.blueMultiplier = 0.33;
         }
         else
         {
            _loc3_.redMultiplier = 1;
            _loc3_.greenMultiplier = 1;
            _loc3_.blueMultiplier = 1;
         }
         param1.transform.colorTransform = _loc3_;
      }
   }
}

