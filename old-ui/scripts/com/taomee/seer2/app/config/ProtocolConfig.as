package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.debugTools.ParameterInfo;
   import com.taomee.seer2.app.debugTools.ProtocolInfo;
   import org.taomee.ds.HashMap;
   
   public class ProtocolConfig
   {
      
      private static var _protocolXml:XML;
      
      private static var _protocolMap:HashMap;
      
      private static var ProtocolClass:Class = ProtocolConfig_ProtocolClass;
      
      initialize();
      
      public function ProtocolConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _protocolMap = new HashMap();
         _protocolXml = XML(new ProtocolClass());
         parseProtocol(_protocolXml);
      }
      
      private static function parseProtocol(param1:XML) : void
      {
         var _loc9_:XML = null;
         var _loc8_:uint = 0;
         var _loc4_:String = null;
         var _loc3_:String = null;
         var _loc6_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc2_:ProtocolInfo = null;
         var _loc7_:XMLList = param1.descendants("Protocol");
         for each(_loc9_ in _loc7_)
         {
            _loc8_ = parseUint(_loc9_,"ID");
            _loc4_ = parseString(_loc9_,"Name");
            _loc3_ = parseString(_loc9_,"Description");
            _loc6_ = parseBool(_loc9_,"HaveRequest");
            _loc5_ = parseBool(_loc9_,"HaveReturn");
            _loc2_ = new ProtocolInfo(_loc8_,_loc4_,_loc3_,_loc6_,_loc5_);
            if(_loc6_)
            {
               _loc2_.requestPack = new Vector.<ParameterInfo>();
               parseParameter(_loc9_.RequestPack[0],_loc2_.requestPack);
            }
            if(_loc5_)
            {
               _loc2_.returnPack = new Vector.<ParameterInfo>();
               parseParameter(_loc9_.ReturnPack[0],_loc2_.returnPack);
            }
            _protocolMap.add(_loc8_,_loc2_);
         }
      }
      
      private static function parseParameter(param1:XML, param2:Vector.<ParameterInfo>) : void
      {
         var _loc11_:XML = null;
         var _loc6_:uint = 0;
         var _loc4_:String = null;
         var _loc9_:String = null;
         var _loc7_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc8_:uint = 0;
         var _loc10_:String = null;
         var _loc5_:ParameterInfo = null;
         var _loc12_:XMLList = param1.children();
         for each(_loc11_ in _loc12_)
         {
            _loc6_ = parseUint(_loc11_,"PID");
            _loc4_ = parseString(_loc11_,"Name");
            _loc9_ = parseString(_loc11_,"Type");
            _loc7_ = parseBool(_loc11_,"IsArray");
            _loc3_ = parseUint(_loc11_,"Length");
            _loc8_ = parseUint(_loc11_,"FixedLen");
            _loc10_ = parseString(_loc11_,"Description");
            _loc5_ = new ParameterInfo(_loc6_,_loc4_,_loc9_,_loc7_,_loc3_,_loc8_,_loc10_);
            param2.push(_loc5_);
            if(_loc9_ == "struct")
            {
               _loc5_.structList = new Vector.<ParameterInfo>();
               parseParameter(_loc11_,_loc5_.structList);
            }
         }
      }
      
      private static function parseUint(param1:XML, param2:String, param3:int = 0) : uint
      {
         var _loc4_:String = null;
         _loc4_ = String(param1.attribute(param2));
         if(_loc4_ == "")
         {
            return param3;
         }
         return uint(_loc4_);
      }
      
      private static function parseString(param1:XML, param2:String, param3:String = "") : String
      {
         var _loc4_:String = null;
         _loc4_ = String(param1.attribute(param2));
         if(_loc4_ == "")
         {
            _loc4_ = param3;
         }
         return _loc4_;
      }
      
      private static function parseBool(param1:XML, param2:String, param3:Boolean = false) : Boolean
      {
         var _loc4_:String = null;
         _loc4_ = String(param1.attribute(param2));
         if(_loc4_ == "")
         {
            return param3;
         }
         if(_loc4_ == "0")
         {
            return false;
         }
         return true;
      }
      
      public static function getProtocol(param1:uint) : ProtocolInfo
      {
         if(_protocolMap.containsKey(param1))
         {
            return _protocolMap.getValue(param1);
         }
         return null;
      }
   }
}

