// Generated by CoffeeScript 1.3.3
(function() {
  var exports, feedHolder, listHolder,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Feed.fetch();

  FeedList.fetch();

  Image.fetch();

  Friends.fetch();

  feedHolder = (function(_super) {

    __extends(feedHolder, _super);

    feedHolder.prototype.tag = "div.column";

    feedHolder.prototype.proxied = ["render", "addall", "remove"];

    feedHolder.prototype.events = {
      "click .bullhorn": "speak_all",
      "click .settings": "edit_settings",
      "click .eye": "toggle_watched"
    };

    feedHolder.prototype.elements = {
      ".holder": "holder",
      ".eye": "eye"
    };

    function feedHolder() {
      this.remove = __bind(this.remove, this);
      feedHolder.__super__.constructor.apply(this, arguments);
      this.item.bind("destroy", this.remove);
      this.addall();
    }

    feedHolder.prototype.edit_settings = function() {
      var _this = this;
      console.log("settings");
      $("#dialog").dialog({
        autoOpen: true,
        width: 600,
        title: "Edit Column",
        modal: true,
        open: function() {
          console.log("clicked save");
          $(".chzn-select").val(JSON.parse(_this.item.content));
          $(".chzn-select").trigger("liszt:updated");
          $(".chzn-select").blur();
          return $("#column_name").val("");
        },
        buttons: {
          Delete: function() {
            console.log("delete item called");
            _this.item.destroy();
            return $("#dialog").dialog("close");
          },
          Save: function() {
            return $(_this).dialog("close");
          },
          Cancel: function() {
            return $(this).dialog("close");
          }
        }
      });
      return $(".chzn-select").chosen();
    };

    feedHolder.prototype.speak_all = function() {
      return window.speak_all(this.item);
    };

    feedHolder.prototype.toggle_watched = function() {
      console.log("toggle watch called");
      this.item.watched = true;
      this.item.save();
      return this.eye.toggleClass("on");
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

    feedHolder.prototype.remove = function() {
      this.el.remove();
      return $('#columns').width(FeedList.all().length * 344 + 20);
    };

    return feedHolder;

  })(Spine.Controller);

  listHolder = (function(_super) {

    __extends(listHolder, _super);

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

  })(Spine.Controller);

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
    var _this = this;
    $(".chzn-select").val("");
    return $("#dialog").dialog({
      autoOpen: true,
      width: 600,
      title: "Add Column",
      modal: true,
      open: function() {
        console.log("clicked save");
        $(".chzn-select").val("");
        $(".chzn-select").trigger("liszt:updated");
        $(".chzn-select").blur();
        return $("#column_name").val("");
      },
      buttons: {
        Save: function() {
          window.add_column();
          return $("#dialog").dialog("close");
        },
        Cancel: function() {
          return $(this).dialog("close");
        }
      }
    });
  };

  window.add_column = function() {
    var a, f, id, name, url, user_ids, _i, _len, _ref, _results;
    console.log("called add column");
    name = $("#column_name").val();
    user_ids = $(".chzn-select").val();
    f = FeedList.create({
      name: name,
      tag: name,
      type: "friends",
      content: JSON.stringify(user_ids)
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
