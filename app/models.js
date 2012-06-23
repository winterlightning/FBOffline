(function() {
  var feed;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  feed = (function() {
    __extends(feed, Spine.Model.Local);
    function feed() {
      feed.__super__.constructor.apply(this, arguments);
    }
    feed.configure("Feed", "id", "from_id", "from_name", "message", "type", "updated_time", "picture", "link");
    return feed;
  })();
}).call(this);
