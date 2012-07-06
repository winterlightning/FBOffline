// Generated by CoffeeScript 1.3.3
(function() {
  var Feed, FeedList, Friends, Image, Me, exports,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Feed = (function(_super) {

    __extends(Feed, _super);

    function Feed() {
      return Feed.__super__.constructor.apply(this, arguments);
    }

    Feed.configure("Feed", "id", "from&id", "from&name", "to&id", "to&name", "message", "type", "updated_time", "picture", "link", "story", "name", "tag");

    Feed.extend(Spine.Model.Local);

    return Feed;

  })(Spine.Model);

  FeedList = (function(_super) {

    __extends(FeedList, _super);

    function FeedList() {
      return FeedList.__super__.constructor.apply(this, arguments);
    }

    FeedList.configure("FeedList", "tag", "name", "icon", "content", "type", "watched", "editable");

    FeedList.extend(Spine.Model.Local);

    FeedList.extend(Spine.Events);

    return FeedList;

  })(Spine.Model);

  Image = (function(_super) {

    __extends(Image, _super);

    function Image() {
      return Image.__super__.constructor.apply(this, arguments);
    }

    Image.configure("Image", "image", "name", "id");

    Image.extend(Spine.Model.Local);

    return Image;

  })(Spine.Model);

  Friends = (function(_super) {

    __extends(Friends, _super);

    function Friends() {
      return Friends.__super__.constructor.apply(this, arguments);
    }

    Friends.configure("Friends", "name", "id");

    Friends.extend(Spine.Model.Local);

    return Friends;

  })(Spine.Model);

  Me = (function(_super) {

    __extends(Me, _super);

    function Me() {
      return Me.__super__.constructor.apply(this, arguments);
    }

    Me.configure("Me", "name", "id");

    Me.extend(Spine.Model.Local);

    return Me;

  })(Spine.Model);

  exports = this;

  this.Feed = Feed;

  this.FeedList = FeedList;

  this.Image = Image;

  this.Friends = Friends;

  this.Me = Me;

}).call(this);
