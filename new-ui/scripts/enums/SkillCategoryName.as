package enums
{
   public class SkillCategoryName
   {
      
      public static const PHY:String = "物理";
      
      public static const SPE:String = "特殊";
      
      public static const BUF:String = "属性";
      
      public static const POW:String = "必杀";
      
      public static const POW_INTERCOURSE:String = "合体";
      
      public function SkillCategoryName()
      {
         super();
      }
      
      public static function atkLabel(param1:String) : String
      {
         switch(param1)
         {
            case "物理":
               return "物理攻击";
            case "特殊":
               return "特殊攻击";
            case "属性":
               return "属性攻击";
            case "必杀":
               return "必杀";
            case "合体":
               return "合体攻击";
            default:
               return "物理攻击";
         }
      }
      
      public static function pow() : Array
      {
         return ["必杀","合体"];
      }
   }
}

