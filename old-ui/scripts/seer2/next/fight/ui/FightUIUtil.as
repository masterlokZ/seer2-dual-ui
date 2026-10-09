package seer2.next.fight.ui
{
   import com.taomee.seer2.app.arena.data.AnimiationHitInfo;
   import com.taomee.seer2.app.arena.util.HitInfoConfig;
   import com.taomee.seer2.app.config.PetSkinConfig;
   import seer2.next.entry.DynSwitch;
   
   public class FightUIUtil
   {
      
      public function FightUIUtil()
      {
         super();
      }
      
      public static function skinnedMonster(side:int, monster:int) : int
      {
         var skinId:* = 0;
         if(side === 1)
         {
            skinId = PetSkinConfig.getSkinId(monster);
            if(skinId > 0)
            {
               return skinId;
            }
         }
         return monster;
      }
      
      public static function hitArray(side:int, monster:int, category:String) : Array
      {
         var hitInfo:AnimiationHitInfo = HitInfoConfig.getHitData(FightUIUtil.skinnedMonster(side,monster));
         if(DynSwitch.hitDmgMode)
         {
            return hitInfo.getHitArray(playLabel(category));
         }
         return [hitInfo.getHitValue(playLabel(category))];
      }
      
      public static function playLabel(category:String) : String
      {
         switch(category)
         {
            case "物理":
               return "物理攻击";
            case "必杀":
               return "必杀";
            case "合体":
               return "合体攻击";
            case "属性":
               return "属性攻击";
            case "特殊":
               return "特殊攻击";
            default:
               return "物理攻击";
         }
      }
   }
}

