(function() {
  var Feed, exports;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Feed = (function() {
    __extends(Feed, Spine.Model);
    function Feed() {
      Feed.__super__.constructor.apply(this, arguments);
    }
    Feed.configure("Feed", "id", "from&id", "from&name", "message", "type", "updated_time", "picture", "link");
    Feed.extend(Spine.Model.Local);
    return Feed;
  })();
  exports = this;
  this.Feed = Feed;
}).call(this);
