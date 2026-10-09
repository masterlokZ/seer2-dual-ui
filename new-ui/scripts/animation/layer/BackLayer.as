package animation.layer
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import utils.CacheUtils;
   import utils.an.ArenaUtil;
   import utils.an.DisplayObjectUtil;
   
   public class BackLayer extends Sprite
   {
      
      private var _url:String;
      
      private var _sprite:DisplayObject;
      
      private var _front:Sprite;
      
      private var _ground:Sprite;
      
      public function BackLayer()
      {
         super();
      }
      
      public function initData(param1:String) : void
      {
         var url:String = param1;
         if(url === _url)
         {
            return;
         }
         if(!url)
         {
            DisplayObjectUtil.removeFromParent(_sprite);
            _url = url;
            _sprite = null;
            return;
         }
         _url = url;
         CacheUtils.loadMapContent(url,function(param1:DisplayObject):void
         {
            if(_url === url)
            {
               DisplayObjectUtil.removeFromParent(_sprite);
               _sprite = param1;
               try
               {
                  _front = _sprite["front_mc"];
                  _ground = _sprite["ground_mc"];
               }
               catch(e:*)
               {
               }
               addChild(_sprite);
            }
         });
      }
      
      public function drift(param1:int) : void
      {
         if(!_ground)
         {
            return;
         }
         if(param1 == 1)
         {
            ArenaUtil.startDrift(-1,_ground);
         }
         else
         {
            ArenaUtil.startDrift(1,_ground);
         }
      }
      
      public function vibrate() : void
      {
         if(!_ground || !_front)
         {
            return;
         }
         ArenaUtil.startVibrate(_ground);
         ArenaUtil.startVibrate(_front);
      }
   }
}

