package org.taomee.manager
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class PopUpManager
   {
      
      public static const BOTTOM_RIGHT:int = 3;
      
      public static const TOP_LEFT:int = 0;
      
      public static const TOP_RIGHT:int = 1;
      
      public static const BOTTOM_LEFT:int = 2;
      
      public static var container:DisplayObjectContainer = TaomeeManager.stage;
      
      public function PopUpManager()
      {
         super();
      }
      
      public static function showForDisplayObject(param1:DisplayObject, param2:DisplayObject, param3:int = 0, param4:Boolean = true, param5:Point = null) : void
      {
         var p:Point = null;
         var obj:DisplayObject = param1;
         var forObj:DisplayObject = param2;
         var align:int = param3;
         var isForObjRange:Boolean = param4;
         var offset:Point = param5;
         if(offset)
         {
            p = forObj.localToGlobal(offset);
         }
         else
         {
            p = forObj.localToGlobal(new Point());
         }
         switch(align)
         {
            case 0:
               obj.x = p.x - obj.width;
               obj.y = p.y - obj.height;
               break;
            case 1:
               if(isForObjRange)
               {
                  obj.x = p.x + forObj.width;
               }
               else
               {
                  obj.x = p.x;
               }
               obj.y = p.y - obj.height;
               break;
            case 2:
               obj.x = p.x - obj.width;
               if(isForObjRange)
               {
                  obj.y = p.y + forObj.height;
               }
               else
               {
                  obj.y = p.y;
               }
               break;
            case 3:
               if(isForObjRange)
               {
                  obj.x = p.x + forObj.width;
               }
               else
               {
                  obj.x = p.x;
               }
               if(isForObjRange)
               {
                  obj.y = p.y + forObj.height;
               }
               else
               {
                  obj.y = p.y;
               }
         }
         container.addChild(obj);
         TaomeeManager.stage.addEventListener("mouseDown",function(param1:MouseEvent):void
         {
            if(!obj.hitTestPoint(param1.stageX,param1.stageY) && !forObj.hitTestPoint(param1.stageX,param1.stageY))
            {
               TaomeeManager.stage.removeEventListener("mouseDown",arguments.callee);
               DisplayUtil.removeForParent(obj,false);
            }
         });
      }
      
      public static function showForMouse(param1:DisplayObject, param2:int = 0, param3:int = 0, param4:int = 0) : void
      {
         var obj:DisplayObject = param1;
         var align:int = param2;
         var offx:int = param3;
         var offy:int = param4;
         var p:Point = new Point(TaomeeManager.stage.mouseX + offx,TaomeeManager.stage.mouseY + offy);
         switch(align)
         {
            case 0:
               if(p.x > obj.width)
               {
                  obj.x = p.x - obj.width;
               }
               else
               {
                  obj.x = p.x;
               }
               if(p.y > obj.height)
               {
                  obj.y = p.y - obj.height;
               }
               else
               {
                  obj.y = p.y;
               }
               break;
            case 1:
               if(p.x + obj.width > TaomeeManager.stageWidth)
               {
                  obj.x = p.x - obj.width;
               }
               else
               {
                  obj.x = p.x;
               }
               if(p.y > obj.height)
               {
                  obj.y = p.y - obj.height;
               }
               else
               {
                  obj.y = p.y;
               }
               break;
            case 2:
               if(p.x > obj.width)
               {
                  obj.x = p.x - obj.width;
               }
               else
               {
                  obj.x = p.x;
               }
               if(p.y + obj.height > TaomeeManager.stageHeight)
               {
                  obj.y = p.y - obj.height;
               }
               else
               {
                  obj.y = p.y;
               }
               break;
            case 3:
               if(p.x + obj.width > TaomeeManager.stageWidth)
               {
                  obj.x = p.x - obj.width;
               }
               else
               {
                  obj.x = p.x;
               }
               if(p.y + obj.height > TaomeeManager.stageHeight)
               {
                  obj.y = p.y - obj.height;
               }
               else
               {
                  obj.y = p.y;
               }
         }
         container.addChild(obj);
         TaomeeManager.stage.addEventListener("mouseDown",function(param1:MouseEvent):void
         {
            if(!obj.hitTestPoint(param1.stageX,param1.stageY))
            {
               TaomeeManager.stage.removeEventListener("mouseDown",arguments.callee);
               DisplayUtil.removeForParent(obj,false);
            }
         });
      }
   }
}

