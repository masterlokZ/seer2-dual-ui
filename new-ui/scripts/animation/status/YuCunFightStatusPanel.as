package animation.status
{
   import data.pet.ArenaData;
   import utils.an.DisplayUtil;
   
   public class YuCunFightStatusPanel extends SPTFightStatusPanel
   {
      
      private var _itemBar:PetItemBar;
      
      public function YuCunFightStatusPanel()
      {
         super();
      }
      
      override public function initData(param1:ArenaData, param2:int) : void
      {
         super.initData(param1,param2);
         this._itemBar.initData(param1.left.master.ext);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _itemBar = new PetItemBar();
         addChild(_itemBar);
      }
      
      override protected function layout() : void
      {
         super.layout();
         var _loc1_:Function = DisplayUtil.setChildPosition;
         _loc1_(_itemBar,170,15);
      }
   }
}

import animation.common.IconDisplay;
import animation.common.TipsDisplay;
import data.pet.PetExtData;
import flash.display.Sprite;
import ui.Resource;
import utils.an.DisplayObjectUtil;

class PetItemBar extends Sprite
{
   
   public static var sex0:Class = §合体_swf$71b0cb52682dd26fef411789ea2276e7-1828220406§;
   
   public static var sex1:Class = 雄性_swf$06d07298cd534235b969b86bfab2dd071095970018;
   
   public static var sex2:Class = 雌性_swf$a12f8393ec3cf01c1dc83859fbba80111291187194;
   
   public static var feature0:Class = 特性_swf$0bae5e370ff3fd01d82b02eac3ab969c1893554953;
   
   public static var emblem1:Class = 白纹章_swf$5a3c72695762d0219d2b55a280278042995787757;
   
   public static var emblem2:Class = 黑纹章_swf$7645f82d029b18dd28f6fecaadfce2801873025561;
   
   public static var fetter0:Class = 羁绊_swf$b3576d6eb63b06284e4a531ba9c434191555842668;
   
   public static var morph0:Class = §变身_swf$b7a27e42a658f2dd9b1a00455703b1a7-1111504654§;
   
   Resource.clazz["UI_ext_sex0"] = sex0;
   Resource.clazz["UI_ext_sex1"] = sex1;
   Resource.clazz["UI_ext_sex2"] = sex2;
   Resource.clazz["UI_ext_feature0"] = feature0;
   Resource.clazz["UI_ext_emblem1"] = emblem1;
   Resource.clazz["UI_ext_emblem2"] = emblem2;
   Resource.clazz["UI_ext_fetter0"] = fetter0;
   Resource.clazz["UI_ext_morph0"] = morph0;
   
   private var _sexIcon:IconDisplay;
   
   private var _featureIcon:IconDisplay;
   
   private var _emblem1Icon:IconDisplay;
   
   private var _emblem2Icon:IconDisplay;
   
   private var _fetterIcon:IconDisplay;
   
   private var _morphIcon:IconDisplay;
   
   private var _data:PetExtData;
   
   public function PetItemBar()
   {
      super();
   }
   
   public function initData(param1:PetExtData) : void
   {
      var _loc3_:TipsDisplay = null;
      if(_data && param1 && _data.sex === param1.sex && _data.featureTips === param1.featureTips && _data.emblem1 === param1.emblem1 && _data.emblem1Tips === param1.emblem1Tips && _data.emblem2 === param1.emblem2 && _data.emblem2Tips === param1.emblem2Tips && _data.fetterTips === param1.fetterTips && _data.morphTips === param1.morphTips)
      {
         return;
      }
      DisplayObjectUtil.removeAllChildren(this);
      _data = param1;
      if(!param1)
      {
         return;
      }
      var _loc2_:int = 0;
      _sexIcon = new IconDisplay();
      _sexIcon.initData("internal://UI_ext_sex" + (param1.sex > 2 ? 0 : param1.sex));
      _sexIcon.x = _loc2_;
      addChild(_sexIcon);
      _loc2_ += 30;
      if(param1.featureTips)
      {
         _featureIcon = new IconDisplay();
         _featureIcon.initData("internal://UI_ext_feature0");
         _loc3_ = new TipsDisplay(_featureIcon);
         _loc3_.x = _loc2_;
         _loc3_.y = 5;
         _loc3_.initData(param1.featureTips);
         addChild(_loc3_);
         _loc2_ += 45;
      }
      if(param1.emblem1Tips)
      {
         _emblem1Icon = new IconDisplay();
         _emblem1Icon.initData(param1.emblem1 ? "internal://UI_ext_emblem1" : "internal://UI_ext_emblem2");
         _loc3_ = new TipsDisplay(_emblem1Icon);
         _loc3_.x = _loc2_;
         _loc3_.initData(param1.emblem1Tips);
         addChild(_loc3_);
         _loc2_ += 30;
      }
      if(param1.emblem2Tips)
      {
         _emblem2Icon = new IconDisplay();
         _emblem2Icon.initData(param1.emblem2 ? "internal://UI_ext_emblem1" : "internal://UI_ext_emblem2");
         _loc3_ = new TipsDisplay(_emblem2Icon);
         _loc3_.x = _loc2_;
         _loc3_.initData(param1.emblem2Tips);
         addChild(_loc3_);
         _loc2_ += 30;
      }
      if(param1.fetterTips)
      {
         _fetterIcon = new IconDisplay();
         _fetterIcon.initData("internal://UI_ext_fetter0");
         _loc3_ = new TipsDisplay(_fetterIcon);
         _loc3_.x = _loc2_;
         _loc3_.initData(param1.fetterTips);
         addChild(_loc3_);
         _loc2_ += 30;
      }
      if(param1.morphTips)
      {
         _morphIcon = new IconDisplay();
         _morphIcon.initData("internal://UI_ext_morph0");
         _loc3_ = new TipsDisplay(_morphIcon);
         _loc3_.x = _loc2_;
         _loc3_.initData(param1.morphTips);
         addChild(_loc3_);
      }
   }
}
