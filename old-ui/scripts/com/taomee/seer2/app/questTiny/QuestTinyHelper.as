package com.taomee.seer2.app.questTiny
{
   import com.taomee.seer2.app.component.tree.TreeItem;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.questTiny.items.QuestTinyItem;
   import com.taomee.seer2.core.quest.Quest;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.BitUtil;
   
   public class QuestTinyHelper
   {
      
      public static const RECOMMEND_QUEST:String = "recommendQuest";
      
      public static const MAIN_QUEST:String = "mainQuest";
      
      public static const CHAPTER_QUEST:String = "chapterQuest";
      
      public static const STORY_QUEST:String = "storyQuest";
      
      public static const PET_QUEST:String = "petQuest";
      
      public static const BRANCH_QUEST:String = "branchQuest";
      
      public static const ACTIVITY_QUEST:String = "activityQuest";
      
      public static const STAR_QUEST:String = "starQuest";
      
      private static const dayLimit:uint = 1524;
      
      private static var _xmlClass:Class = QuestTinyHelper__xmlClass;
      
      private static var stepMap:HashMap = new HashMap();
      
      private static var branchList:Array = [10050,10051,10052,10053,10054,10055,10056,10057,10069,10070,10071];
      
      initlize();
      
      public function QuestTinyHelper()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc3_:XML = null;
         var _loc2_:XML = XML(new _xmlClass());
         var _loc1_:XMLList = _loc2_.descendants("step");
         for each(_loc3_ in _loc1_)
         {
            stepMap.add(uint(_loc3_.@id),{
               "des":String(_loc3_.@des),
               "module":String(_loc3_.@module),
               "title":String(_loc3_.@title),
               "para":String(_loc3_.@para)
            });
         }
      }
      
      public static function getQuestCateogryDes(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "recommendQuest":
               _loc2_ = "这里记录了专为你量身推荐的任务哦！快行动起来吧！Let’s go！";
               break;
            case "mainQuest":
               _loc2_ = "这里记载了赛尔号Ⅱ所发生的点点滴滴，你就是它的主宰者！";
               break;
            case "chapterQuest":
               _loc2_ = "这只是我们旅程的开始，只有经历了才会了解它……";
               break;
            case "storyQuest":
               _loc2_ = "这里撰写了赛尔号Ⅱ里所发生的酸甜苦辣，我们懂得……";
               break;
            case "petQuest":
               _loc2_ = "在这里的生活中少不了精灵的相伴，你对他们足够了解了吗？";
               break;
            case "activityQuest":
               _loc2_ = "这里记录着许许多多的新鲜事，和你的朋友、精灵一起来参加吧！";
               break;
            case "branchQuest":
               _loc2_ = "这里探索未知的任务,获得更丰富的奖励！";
         }
         return _loc2_;
      }
      
      public static function updateChildren(param1:TreeItem, param2:String) : void
      {
         var treeItem:TreeItem = param1;
         var type:String = param2;
         switch(type)
         {
            case "recommendQuest":
               updateQuestVec(treeItem,getDailyRecommendQuestVec());
               break;
            case "mainQuest":
               updateQuestVec(treeItem,getMiniQuestVec());
               break;
            case "starQuest":
               DayLimitManager.getDoCount(1524,function(param1:uint):void
               {
                  var _loc3_:Object = null;
                  var _loc2_:Object = null;
                  var _loc4_:Vector.<Object> = new Vector.<Object>();
                  var _loc6_:uint = param1;
                  var _loc5_:int = 0;
                  while(_loc5_ < 10)
                  {
                     _loc3_ = {};
                     if(!BitUtil.getBit(_loc6_,_loc5_))
                     {
                        _loc2_ = stepMap.getValue(_loc5_ + 1);
                        _loc3_.id = -1;
                        _loc3_.title = _loc2_.title;
                        _loc3_.des = _loc2_.des;
                        _loc3_.module = _loc2_.module;
                        _loc3_.para = _loc2_.para;
                        _loc4_.push(_loc3_);
                     }
                     _loc5_++;
                  }
                  updateStarVec(treeItem,_loc4_);
               });
         }
      }
      
      private static function updateStarVec(param1:TreeItem, param2:Vector.<Object>) : void
      {
         param1.changeToLen(param2.length,QuestTinyItem);
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            param1.getChildItemAt(_loc3_).update(param2[_loc3_]);
            _loc3_++;
         }
      }
      
      private static function updateQuestVec(param1:TreeItem, param2:Vector.<Quest>) : void
      {
         param1.changeToLen(param2.length,QuestTinyItem);
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            param1.getChildItemAt(_loc3_).update(param2[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function getRecommendQuestVec() : Vector.<Quest>
      {
         var tmpVec:Vector.<Quest> = null;
         var questVec:Vector.<Quest> = null;
         tmpVec = new Vector.<Quest>();
         questVec = QuestManager.getQuestListByType(1).concat(QuestManager.getQuestListByType(0));
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1)
            {
               tmpVec.push(param1);
            }
         });
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(!param1.isNewOnline && param1.status == 0)
            {
               if(!isSpecialTask(param1.id))
               {
                  tmpVec.push(param1);
               }
            }
         });
         questVec = QuestManager.getQuestList();
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.isNewOnline && param1.status == 0)
            {
               if(!isSpecialTask(param1.id))
               {
                  tmpVec.push(param1);
               }
            }
         });
         return tmpVec;
      }
      
      public static function getDailyRecommendQuestVec() : Vector.<Quest>
      {
         var tmpVec:Vector.<Quest> = null;
         tmpVec = new Vector.<Quest>();
         var resultVec:Vector.<Quest> = getRecommendQuestVec().concat(randomQuestVec(getPetQuestVec().concat(getNPCQuestVec())));
         resultVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(!isSpecialTask(param1.id))
            {
               tmpVec.push(param1);
            }
         });
         return sortQuestVec(tmpVec);
      }
      
      public static function getChapterQuestVec() : Vector.<Quest>
      {
         var resultVec:Vector.<Quest> = null;
         resultVec = new Vector.<Quest>();
         var questVec:Vector.<Quest> = QuestManager.getQuestListByType(1);
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status != -1)
            {
               resultVec.push(param1);
            }
         });
         return sortQuestVec(resultVec);
      }
      
      public static function getMiniQuestVec() : Vector.<Quest>
      {
         return sortQuestVec(getStoryQuestVec().concat(getBranchQuest()).concat(getActivityQuest()));
      }
      
      public static function getStoryQuestVec() : Vector.<Quest>
      {
         var resultVec:Vector.<Quest> = null;
         resultVec = new Vector.<Quest>();
         var questVec:Vector.<Quest> = QuestManager.getQuestListByType(0).concat(getChapterQuestVec());
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status != -1)
            {
               if(!isSpecialTask(param1.id))
               {
                  resultVec.push(param1);
               }
            }
         });
         return sortQuestVec(resultVec);
      }
      
      public static function getPetQuestVec() : Vector.<Quest>
      {
         var tmpVec:Vector.<Quest> = null;
         tmpVec = new Vector.<Quest>();
         var questVec:Vector.<Quest> = QuestManager.getQuestListByType(2);
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1 || param1.status == 0)
            {
               tmpVec.push(param1);
            }
         });
         return tmpVec;
      }
      
      public static function getNPCQuestVec() : Vector.<Quest>
      {
         var tmpVec:Vector.<Quest> = null;
         tmpVec = new Vector.<Quest>();
         var questVec:Vector.<Quest> = QuestManager.getQuestListByType(3);
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1 || param1.status == 0)
            {
               tmpVec.push(param1);
            }
         });
         return tmpVec;
      }
      
      private static function getLingShouQuestVec() : Vector.<Quest>
      {
         var tmpVec:Vector.<Quest> = null;
         tmpVec = new Vector.<Quest>();
         var questVec:Vector.<Quest> = QuestManager.getQuestListByType(6);
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1 || param1.status == 0)
            {
               tmpVec.push(param1);
            }
         });
         return tmpVec;
      }
      
      private static function getActivityQuest() : Vector.<Quest>
      {
         var ingVec:Vector.<Quest> = null;
         var acceptVec:Vector.<Quest> = null;
         ingVec = new Vector.<Quest>();
         acceptVec = new Vector.<Quest>();
         var questVec:Vector.<Quest> = QuestManager.getQuestListByType(5);
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1 && param1.id != 30001 && param1.id != 30040)
            {
               if(param1.isInTime)
               {
                  ingVec.push(param1);
               }
            }
            else if(param1.status == 0 && param1.id != 30001 && param1.id != 30040)
            {
               if(param1.isInTime)
               {
                  acceptVec.push(param1);
               }
            }
         });
         return ingVec.concat(randomQuestVec(acceptVec));
      }
      
      private static function getBranchQuest() : Vector.<Quest>
      {
         var ingVec:Vector.<Quest> = null;
         var acceptVec:Vector.<Quest> = null;
         ingVec = new Vector.<Quest>();
         acceptVec = new Vector.<Quest>();
         var questVec:Vector.<Quest> = getLingShouQuestVec().concat(getNPCQuestVec().concat(getPetQuestVec()));
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1)
            {
               ingVec.push(param1);
            }
            else if(param1.status == 0)
            {
               acceptVec.push(param1);
            }
         });
         return ingVec.concat(randomQuestVec(acceptVec));
      }
      
      private static function randomQuestVec(param1:Vector.<Quest>) : Vector.<Quest>
      {
         var resultVec:Vector.<Quest>;
         var tempVec:Vector.<Quest> = null;
         var index:int = 0;
         var questVec:Vector.<Quest> = param1;
         tempVec = new Vector.<Quest>();
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1)
            {
               tempVec.push(param1);
            }
         });
         if(tempVec.length == 0)
         {
            questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
            {
               if(param1.status == 0)
               {
                  tempVec.push(param1);
               }
            });
         }
         resultVec = new Vector.<Quest>();
         if(tempVec.length > 0)
         {
            index = Math.random() * tempVec.length;
            resultVec.push(tempVec[index]);
         }
         return resultVec;
      }
      
      private static function sortQuestVec(param1:Vector.<Quest>) : Vector.<Quest>
      {
         var resultVec:Vector.<Quest> = null;
         var questVec:Vector.<Quest> = param1;
         resultVec = new Vector.<Quest>();
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.status == 1)
            {
               resultVec.push(param1);
            }
         });
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(!param1.isNewOnline && param1.status == 0)
            {
               resultVec.push(param1);
            }
         });
         questVec.forEach(function(param1:Quest, param2:int, param3:Vector.<Quest>):void
         {
            if(param1.isNewOnline && param1.status == 0)
            {
               resultVec.push(param1);
            }
         });
         return resultVec;
      }
      
      private static function isSpecialTask(param1:int) : Boolean
      {
         if(param1 == 53 || param1 >= 68 && param1 <= 73 || param1 == 83 || param1 == 86 || param1 == 60 || param1 == 99)
         {
            return true;
         }
         return false;
      }
   }
}

