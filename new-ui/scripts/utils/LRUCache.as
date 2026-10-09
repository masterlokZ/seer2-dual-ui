package utils
{
   public class LRUCache
   {
      
      private var _capacity:int;
      
      private var _size:int = 0;
      
      private var _cache:Object = {};
      
      private var _head:CacheNode;
      
      private var _tail:CacheNode;
      
      public function LRUCache(param1:int = 100)
      {
         super();
         if(param1 <= 0)
         {
            throw new Error("缓存容量必须大于0");
         }
         _capacity = param1;
         _head = new CacheNode();
         _tail = new CacheNode();
         _head.next = _tail;
         _tail.prev = _head;
      }
      
      public function get(param1:*) : *
      {
         var _loc3_:String = String(param1);
         var _loc2_:CacheNode = _cache[_loc3_];
         if(_loc2_ != null)
         {
            moveToHead(_loc2_);
            return _loc2_.value;
         }
         return null;
      }
      
      public function put(param1:*, param2:*) : void
      {
         var _loc5_:CacheNode = null;
         var _loc4_:CacheNode = null;
         var _loc6_:String = String(param1);
         var _loc3_:CacheNode = _cache[_loc6_];
         if(_loc3_ != null)
         {
            _loc3_.value = param2;
            moveToHead(_loc3_);
         }
         else
         {
            _loc5_ = new CacheNode(param1,param2);
            if(_size >= _capacity)
            {
               _loc4_ = removeTail();
               delete _cache[String(_loc4_.key)];
               _size = _size - 1;
            }
            _cache[_loc6_] = _loc5_;
            addToHead(_loc5_);
            _size = _size + 1;
         }
      }
      
      public function has(param1:*) : Boolean
      {
         return _cache[String(param1)] != null;
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc3_:String = String(param1);
         var _loc2_:CacheNode = _cache[_loc3_];
         if(_loc2_ != null)
         {
            removeNode(_loc2_);
            delete _cache[_loc3_];
            _size = _size - 1;
            return true;
         }
         return false;
      }
      
      public function clear() : void
      {
         _cache = {};
         _size = 0;
         _head.next = _tail;
         _tail.prev = _head;
      }
      
      public function get size() : int
      {
         return _size;
      }
      
      public function get capacity() : int
      {
         return _capacity;
      }
      
      public function set capacity(param1:int) : void
      {
         var _loc2_:CacheNode = null;
         if(param1 <= 0)
         {
            throw new Error("缓存容量必须大于0");
         }
         _capacity = param1;
         while(_size > _capacity)
         {
            _loc2_ = removeTail();
            delete _cache[String(_loc2_.key)];
            _size = _size - 1;
         }
      }
      
      public function get isEmpty() : Boolean
      {
         return _size === 0;
      }
      
      public function get isFull() : Boolean
      {
         return _size >= _capacity;
      }
      
      public function get keys() : Array
      {
         var _loc2_:Array = [];
         var _loc1_:CacheNode = _head.next;
         while(_loc1_ !== _tail)
         {
            _loc2_.push(_loc1_.key);
            _loc1_ = _loc1_.next;
         }
         return _loc2_;
      }
      
      public function get values() : Array
      {
         var _loc2_:Array = [];
         var _loc1_:CacheNode = _head.next;
         while(_loc1_ !== _tail)
         {
            _loc2_.push(_loc1_.value);
            _loc1_ = _loc1_.next;
         }
         return _loc2_;
      }
      
      public function get utilizationRate() : Number
      {
         return _capacity > 0 ? _size / _capacity : 0;
      }
      
      public function peekMostRecent() : Object
      {
         if(_head.next !== _tail)
         {
            return {
               "key":_head.next.key,
               "value":_head.next.value
            };
         }
         return null;
      }
      
      public function peekLeastRecent() : Object
      {
         if(_tail.prev !== _head)
         {
            return {
               "key":_tail.prev.key,
               "value":_tail.prev.value
            };
         }
         return null;
      }
      
      public function forEach(param1:Function) : void
      {
         if(param1 == null)
         {
            throw new Error("回调函数不能为null");
         }
         var _loc2_:CacheNode = _head.next;
         var _loc3_:int = 0;
         while(_loc2_ !== _tail)
         {
            param1(_loc2_.key,_loc2_.value,_loc3_);
            _loc2_ = _loc2_.next;
            _loc3_++;
         }
      }
      
      public function getStats() : Object
      {
         return {
            "size":_size,
            "capacity":_capacity,
            "utilizationRate":utilizationRate,
            "isEmpty":isEmpty,
            "isFull":isFull,
            "mostRecent":peekMostRecent(),
            "leastRecent":peekLeastRecent()
         };
      }
      
      private function addToHead(param1:CacheNode) : void
      {
         param1.prev = _head;
         param1.next = _head.next;
         _head.next.prev = param1;
         _head.next = param1;
      }
      
      private function removeNode(param1:CacheNode) : void
      {
         param1.prev.next = param1.next;
         param1.next.prev = param1.prev;
      }
      
      private function moveToHead(param1:CacheNode) : void
      {
         removeNode(param1);
         addToHead(param1);
      }
      
      private function removeTail() : CacheNode
      {
         var _loc1_:CacheNode = _tail.prev;
         removeNode(_loc1_);
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc2_:Array = [];
         var _loc1_:CacheNode = _head.next;
         while(_loc1_ !== _tail)
         {
            _loc2_.push(String(_loc1_.key) + ":" + String(_loc1_.value));
            _loc1_ = _loc1_.next;
         }
         return "[LRUCache size=" + _size + "/" + _capacity + " items={" + _loc2_.join(", ") + "}]";
      }
   }
}

class CacheNode
{
   
   public var key:*;
   
   public var value:*;
   
   public var prev:CacheNode;
   
   public var next:CacheNode;
   
   public function CacheNode(param1:* = null, param2:* = null)
   {
      super();
      this.key = param1;
      this.value = param2;
      this.prev = null;
      this.next = null;
   }
}
