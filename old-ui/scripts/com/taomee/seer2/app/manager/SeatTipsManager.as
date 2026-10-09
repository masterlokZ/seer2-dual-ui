package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.core.map.grids.HashMap;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class SeatTipsManager
   {
      
      private static var hasRuning:Boolean = false;
      
      private static var map:Sprite;
      
      private static var currentMapId:int;
      
      private static var seatMap:HashMap = new HashMap();
      
      private static var sceneTipsMap:HashMap = new HashMap();
      
      private static var uiTipsMap:HashMap = new HashMap();
      
      private static var persistList:Vector.<Point> = new Vector.<Point>();
      
      private static var allTips:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      public function SeatTipsManager()
      {
         super();
      }
      
      public static function registerSeat(param1:Point, param2:int = 0) : void
      {
         if(param2 != 0)
         {
            saveMapAndSeat(param2,param1);
         }
         else
         {
            savePersistSeat(param1);
         }
      }
      
      private static function savePersistSeat(param1:Point) : void
      {
         var _loc4_:MovieClip = null;
         var _loc3_:int = int(persistList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(persistList[_loc5_].equals(param1))
            {
               return;
            }
            _loc5_++;
         }
         persistList.push(param1);
         _loc4_ = getTips();
         _loc4_.x = param1.x;
         _loc4_.y = param1.y;
         var _loc2_:String = "ui_" + param1.x + "_" + param1.y;
         uiTipsMap.put(_loc2_,_loc4_);
         LayerManager.stage.addChild(_loc4_);
      }
      
      private static function getTips() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(allTips.length > 0)
         {
            _loc1_ = MovieClip(allTips.splice(0,1)[0]);
         }
         else
         {
            _loc1_ = UIManager.getMovieClip("SeatTipsUI");
         }
         _loc1_.mouseEnabled = _loc1_.mouseChildren = false;
         return _loc1_;
      }
      
      public static function removeSeat(param1:Point, param2:int = 0) : void
      {
         var _loc7_:String = null;
         var _loc6_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Vector.<Point> = null;
         if(param2 != 0)
         {
            _loc5_ = seatMap.getValue(param2) as Vector.<Point>;
            if(!_loc5_)
            {
               return;
            }
            _loc4_ = int(_loc5_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc5_[_loc3_].equals(param1))
               {
                  _loc5_.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            if(_loc3_ == _loc4_)
            {
               return;
            }
            _loc7_ = "scene_" + param1.x + "_" + param1.y;
            _loc6_ = sceneTipsMap.getValue(_loc7_) as MovieClip;
            if(_loc6_)
            {
               sceneTipsMap.remove(_loc7_);
               DisplayObjectUtil.removeFromParent(_loc6_);
               allTips.push(_loc6_);
            }
         }
         else
         {
            _loc4_ = int(persistList.length);
            if(_loc4_ == 0)
            {
               return;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(persistList[_loc3_].equals(param1))
               {
                  _loc7_ = "ui_" + param1.x + "_" + param1.y;
                  _loc6_ = uiTipsMap.getValue(_loc7_) as MovieClip;
                  uiTipsMap.remove(_loc7_);
                  DisplayObjectUtil.removeFromParent(_loc6_);
                  allTips.push(_loc6_);
                  persistList.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      private static function saveMapAndSeat(param1:int, param2:Point) : void
      {
         if(!seatMap.containsKey(param1))
         {
            seatMap.put(param1,new Vector.<Point>());
         }
         var _loc4_:Vector.<Point> = seatMap.getValue(param1) as Vector.<Point>;
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_.length)
         {
            if(_loc4_[_loc3_].equals(param2))
            {
               return;
            }
            _loc3_++;
         }
         _loc4_.push(param2);
         if(!hasRuning)
         {
            startRuning();
         }
         checkSeat();
      }
      
      private static function startRuning() : void
      {
         hasRuning = true;
         SceneManager.addEventListener("switchStart",removeMapTips);
         SceneManager.addEventListener("switchComplete",checkSeat);
         checkSeat();
      }
      
      private static function removeMapTips(param1:SceneEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Vector.<Point> = seatMap.getValue(currentMapId) as Vector.<Point>;
         if(!_loc3_)
         {
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = "scene_" + _loc3_[_loc5_].x + "_" + _loc3_[_loc5_].y;
            _loc2_ = sceneTipsMap.getValue(_loc4_) as MovieClip;
            if(_loc2_)
            {
               sceneTipsMap.remove(_loc4_);
               DisplayObjectUtil.removeFromParent(_loc2_);
               allTips.push(_loc2_);
            }
            _loc5_++;
         }
      }
      
      public static function hasSeat(param1:int, param2:Point) : Boolean
      {
         var _loc4_:Vector.<Point> = null;
         var _loc3_:int = 0;
         var _loc5_:Boolean = false;
         if(seatMap)
         {
            if(seatMap.containsKey(param1))
            {
               _loc4_ = seatMap.getValue(param1) as Vector.<Point>;
               _loc3_ = 0;
               while(_loc3_ < _loc4_.length)
               {
                  if(_loc4_[_loc3_].equals(param2))
                  {
                     _loc5_ = true;
                     break;
                  }
                  _loc3_++;
               }
            }
         }
         return _loc5_;
      }
      
      private static function checkSeat(param1:SceneEvent = null) : void
      {
         var _loc4_:String = null;
         var _loc2_:MovieClip = null;
         if(seatMap.size() == 0)
         {
            hasRuning = false;
            SceneManager.removeEventListener("switchComplete",checkSeat);
            SceneManager.removeEventListener("switchStart",removeMapTips);
            return;
         }
         currentMapId = SceneManager.active.mapID;
         map = SceneManager.active.mapModel.front;
         var _loc3_:Vector.<Point> = seatMap.getValue(currentMapId) as Vector.<Point>;
         if(!_loc3_)
         {
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = "scene_" + _loc3_[_loc5_].x + "_" + _loc3_[_loc5_].y;
            if(!sceneTipsMap.getValue(_loc4_))
            {
               _loc2_ = getTips();
               _loc2_.x = _loc3_[_loc5_].x;
               _loc2_.y = _loc3_[_loc5_].y;
               map.addChild(_loc2_);
               sceneTipsMap.put(_loc4_,_loc2_);
            }
            _loc5_++;
         }
      }
   }
}

