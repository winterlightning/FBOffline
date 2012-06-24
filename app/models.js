(function() {
  var Feed, FeedList, Image, exports;
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
    Feed.configure("Feed", "id", "from&id", "from&name", "to&id", "to&name", "message", "type", "updated_time", "picture", "link", "story", "name", "tag");
    Feed.extend(Spine.Model.Local);
    return Feed;
  })();
  FeedList = (function() {
    __extends(FeedList, Spine.Model);
    function FeedList() {
      FeedList.__super__.constructor.apply(this, arguments);
    }
    FeedList.configure("FeedList", "tag", "name", "icon");
    FeedList.extend(Spine.Model.Local);
    return FeedList;
  })();
  Image = (function() {
    __extends(Image, Spine.Model);
    function Image() {
      Image.__super__.constructor.apply(this, arguments);
    }
    Image.configure("Image", "image", "name", "id");
    Image.extend(Spine.Model.Local);
    return Image;
  })();
  exports = this;
  this.Feed = Feed;
  this.FeedList = FeedList;
  this.Image = Image;
}).call(this);
