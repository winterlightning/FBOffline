(function() {
  var exports, feedHolder;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Feed.fetch();
  feedHolder = (function() {
    __extends(feedHolder, Spine.Controller);
    feedHolder.prototype.el = ".holder";
    function feedHolder() {
      feedHolder.__super__.constructor.apply(this, arguments);
      this.addall();
    }
    feedHolder.prototype.addall = function() {
      var feed, r, _i, _len, _ref, _results;
      console.log("add all");
      _ref = Feed.all();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        feed = _ref[_i];
        r = $("#feedTmpl").tmpl(feed);
        _results.push(this.el.append(r));
      }
      return _results;
    };
    return feedHolder;
  })();
  $(function() {
    return new feedHolder();
  });
  exports = this;
  exports.feedHolder = feedHolder;
}).call(this);
