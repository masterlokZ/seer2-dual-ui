package com.taomee.seer2.app.starMagic
{
   import com.greensock.TweenLite;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class StarMagicIconDisplayer extends Sprite
   {
      
      public static var m_filters:GlowFilter = new GlowFilter(0,1,4,4);
      
      public var index:int;
      
      private var _id:int;
      
      private var _grade:int;
      
      private var _info:StarInfo;
      
      private var _textField:TextField;
      
      private var _levelField:TextField;
      
      private var _displayer:IconDisplayer;
      
      public var _exhibitMode:Boolean;
      
      public function StarMagicIconDisplayer(id:int = 0, Type:int = 0, exhibit:Boolean = false)
      {
         super();
         this.buttonMode = true;
         this._id = id;
         this._grade = Type;
         this._info = new StarInfo();
         this._exhibitMode = exhibit;
         var format:TextFormat = new TextFormat();
         format.align = "center";
         format.font = "_sans";
         format.size = 14;
         this._textField = new TextField();
         this._textField.x = 0;
         this._textField.y = 0;
         this._textField.width = 60;
         this._textField.height = 18;
         this._textField.filters = [m_filters];
         this._textField.setTextFormat(format);
         this._textField.defaultTextFormat = format;
         this.addChild(this._textField);
         this._levelField = new TextField();
         this._levelField.x = 0;
         this._levelField.y = 42;
         this._levelField.width = 60;
         this._levelField.height = 18;
         this._levelField.filters = [m_filters];
         this._levelField.setTextFormat(format);
         this._levelField.defaultTextFormat = format;
         this.addChild(this._levelField);
         this._displayer = new IconDisplayer();
         this.addChild(this._displayer);
         this.showIcon();
         this.mouseChildren = false;
      }
      
      public function updateDateInfo(info:StarInfo) : void
      {
         if(Boolean(info))
         {
            this._id = info.buffId;
            this._grade = info.type;
            StarInfo.updateStarInfo(info,this._info);
            this._info.nameT = info.nameT != null ? info.nameT : StarMagicConfig.getInfoById(this._id).nameT;
         }
         else
         {
            this._id = 0;
            this._grade = 0;
         }
         this.showIcon();
      }
      
      public function setmoveState(i:int) : void
      {
      }
      
      public function toPos(x:int, y:int, completeFunc:Function = null) : void
      {
         TweenLite.to(_displayer,1,{
            "x":x,
            "y":y,
            "scaleX":1,
            "scaleY":1,
            "onComplete":function():void
            {
               _displayer.x = 0;
               _displayer.y = 0;
               if(Boolean(completeFunc))
               {
                  completeFunc();
               }
            }
         });
      }
      
      private function setTextColor() : void
      {
         this._levelField.textColor = 16777215;
         if(this._id == 1 || this._id == 2)
         {
            this._textField.textColor = 16777215;
         }
         else if(this._grade == 0)
         {
            this._textField.textColor = 16777215;
         }
         else if(this._grade == 1)
         {
            this._textField.textColor = 65382;
         }
         else if(this._grade == 2)
         {
            this._textField.textColor = 52479;
         }
         else if(this._grade == 3)
         {
            this._textField.textColor = 16711935;
         }
         else if(this._grade == 4)
         {
            this._textField.textColor = 16777011;
         }
         else if(this._grade == 5)
         {
            this._textField.textColor = 16744448;
         }
         else if(this._grade == 6)
         {
            this._textField.textColor = 16711680;
         }
      }
      
      private function showIcon() : void
      {
         var resId:uint;
         this._displayer.removeIcon();
         resId = this.getStarItemId();
         if(resId != 0)
         {
            this._displayer.mouseEnabled = true;
            this._displayer.visible = true;
         }
         else
         {
            this._displayer.mouseEnabled = false;
            this._displayer.visible = false;
            resId = 202098;
         }
         if(this._exhibitMode)
         {
            this._displayer.mouseEnabled = false;
         }
         this._displayer.setIconUrl(URLUtil.getPetRelateIcon(resId),function():void
         {
            _displayer.x = _displayer.y = 0;
         });
         this.setTextColor();
         if(this._info && this._id != 0)
         {
            if(this._info.level == 0)
            {
               this._levelField.text = "LV." + this._info.maxLevel;
            }
            this.setChildIndex(this._levelField,this.numChildren - 1);
            this.setChildIndex(this._textField,this.numChildren - 1);
         }
         if(this._info && this._id != 0 && !this._exhibitMode)
         {
            this._textField.text = "" + this._info.nameT;
            this._levelField.text = "LV." + this._info.level;
            this._textField.visible = true;
            this._levelField.visible = true;
         }
         else
         {
            this._textField.text = "";
            this._levelField.text = "";
            this._textField.visible = false;
            this._levelField.visible = false;
         }
         DisplayObjectUtil.removeFromParent(this._textField);
         DisplayObjectUtil.removeFromParent(this._levelField);
         this.addChild(this._textField);
         this.addChild(this._levelField);
      }
      
      public function get info() : StarInfo
      {
         return this._info;
      }
      
      public function get grade() : int
      {
         return this._grade;
      }
      
      public function get indexId() : int
      {
         return this._id;
      }
      
      public function get icon() : DisplayObject
      {
         return this._displayer.icon;
      }
      
      public function getStarItemId() : uint
      {
         if(!this._info || this._id == 0)
         {
            return 0;
         }
         var info:StarInfo = StarMagicConfig.getInfoById(this._id);
         return this._info.itemIcon != 0 ? this._info.itemIcon : info.itemIcon;
      }
   }
}

