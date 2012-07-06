// Generated by CoffeeScript 1.3.3
(function() {

  window.suck_down_feed = function(json, tag) {
    var a, data, field, field_a, field_b, one, two, x, _i, _j, _len, _len1, _ref, _ref1;
    _ref = json.data;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      x = _ref[_i];
      data = {};
      _ref1 = Feed.attributes;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        field = _ref1[_j];
        if (field.indexOf("&") === -1) {
          if (x[field] != null) {
            data[field] = x[field];
          }
        } else {
          field_a = field.split("&")[0];
          field_b = field.split("&")[1];
          if (x[field_a] != null) {
            one = x[field_a];
            if (one[field_b] != null) {
              data[field] = one[field_b];
            }
          }
          if (field_a === "to" && (x[field_a] != null)) {
            console.log("got here");
            one = x[field_a];
            two = one["data"][0];
            if (two[field_b] != null) {
              data[field] = two[field_b];
            }
          }
        }
      }
      console.log(data);
      if (tag != null) {
        data["tag"] = tag;
      }
      if (Feed.findByAttribute("id", x["id"]) != null) {
        console.log("this feed is already there");
      } else {
        Feed.create(data);
      }
    }
    if (FeedList.findByAttribute("tag", tag)) {
      a = FeedList.findByAttribute("tag", tag);
      return a.save();
    }
  };

  window.suck_down_friends = function(json) {
    var data, field, x, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
    _ref = json.data;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      x = _ref[_i];
      data = {};
      _ref1 = Friends.attributes;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        field = _ref1[_j];
        if (x[field] != null) {
          data[field] = x[field];
        }
        Friends.create(data);
      }
    }
    _ref2 = Friends.all();
    _results = [];
    for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
      x = _ref2[_k];
      _results.push($("#friendpicker").append("<option value='" + x.id + "'>" + x.name + "</option>"));
    }
    return _results;
  };

  window.get_stream = function() {
    return window.fb_call(fb_match.newsfeed, suck_down_feed, "stream");
  };

  window.get_wall = function() {
    return window.fb_call(fb_match.wall, suck_down_feed, "wall");
  };

  window.get_friends = function() {
    return window.fb_call(fb_match.friends, suck_down_friends);
  };

  window.get_friend_list = function(feed_list) {
    var a, id, list, url, _i, _len, _results;
    list = JSON.parse(feed_list.content);
    _results = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      if (id === "") {
        _results.push(console.log("empty id, need to remove these"));
      } else {
        url = "/" + id + "/feed";
        a = {
          url: url
        };
        console.log("calling", url);
        _results.push(window.fb_call(a, suck_down_feed, feed_list.tag));
      }
    }
    return _results;
  };

  window.refresh_column = function(feed_list) {
    console.log("refresh column called");
    switch (feed_list.type) {
      case "friends":
        return window.get_friend_list(feed_list);
      case "newstream":
        return window.get_stream();
      case "wall":
        return window.get_wall();
      case "messages":
        return console.log("messages");
      default:
        return console.log("feed_list is not suppose to be this type", feed_list.type);
    }
  };

  window.speak_all = function(feed_list) {
    var f, speak, _i, _len, _ref, _results;
    chrome.tts.speak("starting");
    _ref = Feed.findAllByAttribute("tag", feed_list.tag);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      f = _ref[_i];
      if (f.type === "status") {
        if (f.message != null) {
          speak = f.message;
        }
        if (f.story != null) {
          speak = f.story;
        }
        if (f.name != null) {
          speak = name;
        }
        if (f["to&name"] != null) {
          chrome.tts.speak(f["from&name"] + " said to " + f["to&name"] + " " + speak + ".", {
            'enqueue': true
          });
          _results.push(console.log("SPEAKING:", f["from&name"] + " said to " + f["to&name"] + " " + speak + "."));
        } else {
          chrome.tts.speak(f["from&name"] + " said " + speak + ".", {
            'enqueue': true
          });
          _results.push(console.log("SPEAKING:", f["from&name"] + " said " + speak + "."));
        }
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

}).call(this);
