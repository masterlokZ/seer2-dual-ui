package data
{
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   
   public class Config
   {
      
      public static var isHttps:Boolean;
      
      public static var redirectRes:Boolean;
      
      public static const HTTPS:String = "https://";
      
      public var jsCallback:String;
      
      public var leftUrl:String;
      
      public var rightUrl:String;
      
      public var silence:Boolean;
      
      public var loading:Boolean;
      
      public var playUrl:String;
      
      public function Config()
      {
         super();
      }
      
      public static function from(param1:Sprite) : Config
      {
         var _loc4_:Config = new Config();
         var _loc2_:LoaderInfo = LoaderInfo(param1.root.loaderInfo);
         var _loc3_:Object = _loc2_.parameters;
         _loc4_.jsCallback = _loc3_["cb"] || "flash_dispatch";
         _loc4_.leftUrl = _loc3_["url"] || "";
         _loc4_.rightUrl = _loc3_["url2"] || "";
         _loc4_.silence = _loc3_["silence"];
         _loc4_.loading = _loc3_["loading"];
         _loc4_.playUrl = _loc3_["playUrl"];
         isHttps = _loc2_.loaderURL.slice(0,"https://".length) === "https://";
         return _loc4_;
      }
   }
}

