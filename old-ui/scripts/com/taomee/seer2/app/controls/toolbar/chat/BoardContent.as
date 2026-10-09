package com.taomee.seer2.app.controls.toolbar.chat
{
   import com.taomee.seer2.app.chat.data.ChatReceivedMessage;
   import com.taomee.seer2.app.component.TextScroller;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class BoardContent extends Sprite
   {
      
      private const MAX_SAVED_NUM:uint = 20;
      
      private const PAGE_SIZE:uint = 10;
      
      private var _chatTxt:TextField;
      
      private var _msgContent:String;
      
      private var _scroller:TextScroller;
      
      private var _receivedMessageVec:Vector.<ChatReceivedMessage>;
      
      private var _emotionRegExp:RegExp;
      
      public function BoardContent(param1:TextField)
      {
         super();
         this._chatTxt = param1;
         addChild(this._chatTxt);
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._receivedMessageVec = new Vector.<ChatReceivedMessage>();
         this._emotionRegExp = /^\[e_\d{1,2}\]$/;
         this.createScoller();
         this.initEventListener();
      }
      
      private function createScoller() : void
      {
         this._scroller = new TextScroller(UIManager.getMovieClip("UI_Toolbar_ScrollerHolder"));
         this._scroller.pageSize = 10;
         this._scroller.x = 200;
         this._scroller.y = 23;
         this._scroller.wheelObject = this;
         this._scroller.setTextField(this._chatTxt);
         addChild(this._scroller);
      }
      
      private function initEventListener() : void
      {
         this._chatTxt.addEventListener("link",this.onTextLink);
      }
      
      public function appendMessage(param1:ChatReceivedMessage) : void
      {
         if(this.isEmotionToken(param1.message))
         {
            return;
         }
         if(this._receivedMessageVec.length == 20)
         {
            this._receivedMessageVec.shift();
         }
         this._receivedMessageVec.push(param1);
         this.updateText();
      }
      
      private function isEmotionToken(param1:String) : Boolean
      {
         return this._emotionRegExp.test(param1);
      }
      
      private function updateText() : void
      {
         var _loc2_:ChatReceivedMessage = null;
         var _loc1_:String = null;
         this.clear();
         for each(_loc2_ in this._receivedMessageVec)
         {
            _loc1_ = this.formatMessage(_loc2_);
            this.appendText(_loc1_);
         }
         this._chatTxt.htmlText = this._msgContent;
         this._chatTxt.scrollV = this._chatTxt.maxScrollV;
      }
      
      private function onTextLink(param1:TextEvent) : void
      {
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      private function formatMessage(param1:ChatReceivedMessage) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = param1.senderNick;
         var _loc4_:String = param1.message;
         _loc3_ = this.convertNameToLink(_loc2_);
         return _loc3_ + _loc4_;
      }
      
      private function convertNameToLink(param1:String) : String
      {
         return "<a href = \'event:" + param1 + "#\'><font color=\'#FFFF00\'>" + param1 + "</font></a>: ";
      }
      
      private function clear() : void
      {
         this._msgContent = "";
      }
      
      private function appendText(param1:String) : void
      {
         if(this._msgContent == "")
         {
            this._msgContent += param1;
         }
         else
         {
            this._msgContent = this._msgContent + "\n" + param1;
         }
      }
   }
}

