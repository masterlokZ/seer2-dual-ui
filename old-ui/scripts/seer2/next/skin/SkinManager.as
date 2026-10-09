package seer2.next.skin
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import org.taomee.ds.HashMap;
   
   public class SkinManager
   {
      
      private static const SKILL_MAP_ROOT:uint = 10000;
      
      private static const MAGIC_NUMBER_SKILL_MAP:uint = 34715;
      
      public static var SKIN_MAP:HashMap = new HashMap();
      
      public function SkinManager()
      {
         super();
      }
      
      public static function save() : void
      {
         var monsters:Array;
         var start:*;
         var end:*;
         var data:LittleEndianByteArray;
         var i:*;
         var monster:*;
         var ty:uint = 10000;
         var skinMap:HashMap = new HashMap();
         SKIN_MAP.forEach(function(monster:uint, skin:uint):void
         {
            if(monster == 0 || skin == 0 || monster == skin)
            {
               return;
            }
            skinMap.add(monster,skin);
         });
         monsters = skinMap.getKeys();
         start = 0;
         for(end = 12; start < monsters.length; )
         {
            data = new LittleEndianByteArray();
            data.writeShort(34715);
            for(i = start; i < 12; )
            {
               monster = monsters[i];
               if(monster)
               {
                  data.writeShort(monster);
                  data.writeShort(skinMap.getValue(monster));
               }
               else
               {
                  data.writeShort(0);
                  data.writeShort(0);
               }
               i = Number(i) + 1;
            }
            Connection.send(CommandSet.CLIENT_SET_BUFFER_INFO_1063,ty,data);
            start = end;
            end += 12;
         }
      }
      
      public static function load(cb:Function) : void
      {
         var skillMap:HashMap = new HashMap();
         var next:Function = function(ty:uint):void
         {
            getBuffer(ty,function(data:LittleEndianByteArray):void
            {
               var j:int = 0;
               var monster:* = 0;
               var skin:* = 0;
               data.readUnsignedShort();
               for(j = 0; j < 12; )
               {
                  monster = data.readUnsignedShort();
                  skin = data.readUnsignedShort();
                  if(monster == 0 || skin == 0 || monster == skin)
                  {
                     SKIN_MAP = skillMap;
                     cb(skillMap);
                     return;
                  }
                  skillMap.add(monster,skin);
                  j++;
               }
               next(ty + 1);
            });
         };
         next(10000);
      }
      
      public static function getBuffer(ty:uint, cb:Function) : void
      {
         var getServerBuffer:Function = function(param1:MessageEvent):void
         {
            var data:LittleEndianByteArray = param1.message.getRawData().clone();
            if(ty == data.readUnsignedInt())
            {
               Connection.removeCommandListener(CommandSet.CLIENT_GET_BUFFER_INFO_1062,getServerBuffer);
               cb(data);
            }
         };
         Connection.addCommandListener(CommandSet.CLIENT_GET_BUFFER_INFO_1062,getServerBuffer);
         Connection.send(CommandSet.CLIENT_GET_BUFFER_INFO_1062,ty);
      }
   }
}

