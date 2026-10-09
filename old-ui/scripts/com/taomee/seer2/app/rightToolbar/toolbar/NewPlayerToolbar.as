package com.taomee.seer2.app.rightToolbar.toolbar
{
   import com.taomee.seer2.app.dream.DreamManager;
   import com.taomee.seer2.app.newPlayerGuideVerOne.NewPlayerGuideTimeManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.rightToolbar.RightToolbar;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class NewPlayerToolbar extends RightToolbar
   {
      
      private var _effect:MovieClip;
      
      public function NewPlayerToolbar()
      {
         super();
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         if(NewPlayerGuideTimeManager.timeCheckNewGuide())
         {
            SceneManager.changeScene(9,80491);
         }
         else
         {
            SceneManager.changeScene(9,80351);
         }
      }
      
      override public function update() : void
      {
         if(this.isFightHomeIng() == false)
         {
            return;
         }
         if(_btn)
         {
            this.show();
         }
         else
         {
            QueueLoader.load(URLUtil.getRes("loaderLibrary/rightToolbar/" + _info.sort + ".swf"),"swf",onResLoaded);
         }
      }
      
      override protected function show() : void
      {
         super.show();
         if(!NewPlayerGuideTimeManager.timeCheckNewGuide())
         {
            DisplayObjectUtil.removeFromParent(this._effect);
         }
         else if(!QuestManager.isComplete(99))
         {
            if(SceneManager.active && SceneManager.currentSceneType != 2 && SceneManager.active.mapID != 80491)
            {
               this.setEffectVisible(true);
            }
            else
            {
               this.setEffectVisible(false);
            }
         }
      }
      
      private function setEffectVisible(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._effect == null)
            {
               this._effect = UIManager.getMovieClip("RightToorEffect");
               this._effect.mouseEnabled = this._effect.mouseChildren = false;
            }
            this._effect.x = -10;
            this._effect.y = 20;
            addChild(this._effect);
         }
         else if(this._effect)
         {
            DisplayObjectUtil.removeFromParent(this._effect);
         }
      }
      
      private function isFightHomeIng() : Boolean
      {
         if(SceneManager.active == null)
         {
            return false;
         }
         if(SceneManager.active.type == 2 || SceneManager.active.type == 4 || SceneManager.active.type == 6 || SceneManager.active.type == 10 || SceneManager.active.type == 11 || SceneManager.active.type == 12 || SceneManager.active.type == 13 || SceneManager.active.type == 14 || SceneManager.active.type == 15 || SceneManager.active.type == 16)
         {
            return false;
         }
         if(Boolean(SceneManager.active) && DreamManager.isDreamMap())
         {
            return false;
         }
         if(SceneManager.active.type == 3)
         {
            return false;
         }
         return true;
      }
      
      override public function remove() : void
      {
         super.remove();
         this.setEffectVisible(false);
      }
   }
}

