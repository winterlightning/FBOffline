(function() {
  var exports, feedHolder, listHolder;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Feed.fetch();
  FeedList.fetch();
  Image.fetch();
  Friends.fetch();
  feedHolder = (function() {
    __extends(feedHolder, Spine.Controller);
    feedHolder.prototype.tag = "div.column";
    feedHolder.prototype.proxied = ["render", "addall"];
    feedHolder.prototype.events = {
      "click .bullhorn": "speak_all"
    };
    feedHolder.prototype.elements = {
      ".holder": "holder"
    };
    function feedHolder() {
      feedHolder.__super__.constructor.apply(this, arguments);
      this.addall();
    }
    feedHolder.prototype.speak_all = function() {
      return window.speak_all(this.item);
    };
    feedHolder.prototype.render = function() {
      var elements;
      elements = $("#listTmpl").tmpl(this.item);
      this.el.html(elements);
      this.refreshElements();
      this.el.data("id", this.item.id);
      return this;
    };
    feedHolder.prototype.addall = function() {
      var feed, r, _i, _len, _ref, _results;
      console.log("add all");
      this.holder.html("");
      _ref = Feed.findAllByAttribute("tag", this.item.tag);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        feed = _ref[_i];
        r = $("#feedTmpl").tmpl(feed);
        _results.push(this.holder.append(r));
      }
      return _results;
    };
    return feedHolder;
  })();
  listHolder = (function() {
    __extends(listHolder, Spine.Controller);
    listHolder.prototype.el = "#columns";
    listHolder.prototype.proxied = ["addone", "addall"];
    function listHolder() {
      listHolder.__super__.constructor.apply(this, arguments);
      this.addall();
    }
    listHolder.prototype.addall = function() {
      var feedList, list, _i, _len, _ref, _results;
      console.log("add all listall");
      this.el.html("");
      _ref = FeedList.all();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        feedList = _ref[_i];
        list = new feedHolder({
          item: feedList
        });
        this.el.append(list.render().el);
        _results.push(list.addall());
      }
      return _results;
    };
    listHolder.prototype.addone = function(list) {
      list = new feedHolder({
        item: list
      });
      $('#columns').width(FeedList.all().length * 344 + 20);
      this.el.append(list.render().el);
      list.addall();
      return setTimeout("window.list_holder.addall()", 3000);
    };
    return listHolder;
  })();
  $(function() {
    var x, _i, _len, _ref;
    window.list_holder = new listHolder();
    if (localStorage.accessToken) {
      $("#loading").hide();
    }
    chrome.tts.stop();
    if (FeedList.all().length === 0) {
      FeedList.create({
        name: "Newfeed",
        "tag": "stream"
      });
      FeedList.create({
        name: "Your Wall",
        "tag": "wall"
      });
    }
    _ref = Friends.all();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      x = _ref[_i];
      $("#friendpicker").append("<option value='" + x.id + "'>" + x.name + "</option>");
    }
    $(".chzn-select").chosen();
    $('#pane-target').width($(window).width());
    return $('#columns').width(FeedList.all().length * 344 + 20);
  });
  window.fb_selector = function() {
    return $('#myModal').modal({});
  };
  window.add_column = function() {
    var a, f, id, name, url, user_ids, _i, _len, _ref, _results;
    console.log("called add column");
    $('#myModal').modal('hide');
    name = $("#column_name").val();
    user_ids = $(".chzn-select").val();
    f = FeedList.create({
      name: name,
      tag: name
    });
    window.list_holder.addone(f);
    _ref = $(".chzn-select").val();
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      id = _ref[_i];
      url = "/" + id + "/feed";
      a = {
        url: url
      };
      console.log(url);
      _results.push(window.fb_call(a, suck_down_feed, name));
    }
    return _results;
  };
  window.stop_talking = function() {
    console.log("stop talking");
    return chrome.tts.stop();
  };
  window.logout = function() {
    localStorage.accessToken = "";
    $("#loading").show();
    return chrome.tabs.onUpdated.addListener(onFacebookLogin);
  };
  exports = this;
  exports.feedHolder = feedHolder;
}).call(this);
