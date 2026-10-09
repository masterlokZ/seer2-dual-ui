package com.taomee.seer2.app.gameRule.nono
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.gameRule.nono.behavior.NonoDisappear;
   import com.taomee.seer2.app.gameRule.nono.behavior.OpenPetStorage;
   import com.taomee.seer2.app.gameRule.nono.behavior.TimerPanel;
   import com.taomee.seer2.app.gameRule.nono.core.INonoBehavior;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.effect.EffectShake;
   
   public class NonoBtnCollection
   {
      
      private var _nono:Nono;
      
      private var _userInfo:UserInfo;
      
      private var _isShow:Boolean;
      
      private var _behaviors:Vector.<INonoBehavior>;
      
      private var _isClock:Boolean;
      
      public function NonoBtnCollection(param1:Nono, param2:UserInfo)
      {
         var _loc4_:NonoDisappear = null;
         var _loc3_:TimerPanel = null;
         super();
         this._nono = param1;
         this._userInfo = param2;
         this._behaviors = new Vector.<INonoBehavior>();
         var _loc5_:OpenPetStorage = new OpenPetStorage(this._nono.nonoInfo,this._userInfo);
         _loc5_.iconButton = UIManager.getButton("UI_Nono_Btn1");
         _loc4_ = new NonoDisappear(this._nono.nonoInfo);
         _loc4_.iconButton = UIManager.getButton("UI_Nono_Btn2");
         _loc3_ = new TimerPanel(this._nono.nonoInfo);
         _loc3_.iconButton = UIManager.getButton("UI_Nono_Btn3");
         this._behaviors.push(_loc4_);
         this._behaviors.push(_loc5_);
         this._behaviors.push(_loc3_);
      }
      
      public function toggleNonoMenu(param1:Boolean) : void
      {
         this._isClock = param1;
         if(this._isShow)
         {
            this.hideMenu();
         }
         else
         {
            this.showMenu();
         }
      }
      
      public function showMenu() : void
      {
         var _loc1_:INonoBehavior = null;
         for each(_loc1_ in this._behaviors)
         {
            _loc1_.iconButton.x = _loc1_.nonoX;
            _loc1_.iconButton.y = _loc1_.nonoY;
            this._nono.addChild(_loc1_.iconButton);
            if(this._isClock && _loc1_ is TimerPanel)
            {
               EffectShake.addShake(_loc1_.iconButton,5,5,99,99);
            }
         }
         this._isShow = true;
      }
      
      public function hideMenu() : void
      {
         var _loc1_:INonoBehavior = null;
         for each(_loc1_ in this._behaviors)
         {
            DisplayObjectUtil.removeFromParent(_loc1_.iconButton);
         }
         this._isShow = false;
      }
   }
}

