package enums
{
   public class FighterActionType
   {
      
      public static const IDLE:String = "待机";
      
      public static const ATK_PHY:String = "物理攻击";
      
      public static const ATK_BUF:String = "属性攻击";
      
      public static const ATK_SPE:String = "特殊攻击";
      
      public static const UNDER_ATK:String = "被打";
      
      public static const UNDER_ULTRA:String = "被暴击";
      
      public static const WIN:String = "胜利";
      
      public static const DEAD:String = "失败";
      
      public static const MISS:String = "闪避";
      
      public static const ATK_POW:String = "必杀";
      
      public static const ABOUT_TO_DIE:String = "濒死";
      
      public static const PRESENT:String = "个性出场";
      
      public static const INTERCOURSE:String = "合体攻击";
      
      public static const CHANGE_STATUS:String = "变身效果";
      
      public static const BLANK:String = "空";
      
      public function FighterActionType()
      {
         super();
      }
      
      public static function atk() : Array
      {
         return ["物理攻击","属性攻击","特殊攻击","必杀","合体攻击"];
      }
      
      public static function damage() : Array
      {
         return ["物理攻击","特殊攻击","必杀","合体攻击"];
      }
      
      public static function superAtk() : Array
      {
         return ["必杀","合体攻击"];
      }
      
      public static function hurt() : Array
      {
         return ["被打","被暴击","闪避"];
      }
      
      public static function end() : Array
      {
         return ["胜利","失败"];
      }
      
      public static function status() : Array
      {
         return ["待机","濒死"];
      }
   }
}

