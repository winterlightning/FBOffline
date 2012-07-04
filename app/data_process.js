// Generated by CoffeeScript 1.3.3
(function() {

  window.suck_down_feed = function(json, tag) {
    var a, data, field, field_a, field_b, one, two, x, _i, _j, _len, _len1, _ref, _ref1, _results;
    _ref = json.data;
    _results = [];
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
      if (FeedList.findByAttribute("name", tag)) {
        a = FeedList.findByAttribute("name", tag);
        _results.push(a.save());
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  window.suck_down_friends = function(json) {
    var data, field, x, _i, _j, _len, _len1, _ref, _ref1, _results;
    _ref = json.data;
    _results = [];
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
      _results.push((function() {
        var _k, _len2, _ref2, _results1;
        _ref2 = Friends.all();
        _results1 = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          x = _ref2[_k];
          _results1.push($("#friendpicker").append("<option value='" + x.id + "'>" + x.name + "</option>"));
        }
        return _results1;
      })());
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

  window.suck_in_image = function(url) {
    console.log("suck in image");
    return $.ajax({
      url: url,
      cache: false
    }).done(function(result) {
      console.log(result);
      return Image.create({
        name: url,
        image: result
      });
    });
  };

  window.getBase64Image = function(img) {
    var canvas, ctx, dataURL;
    canvas = document.createElement("canvas");
    canvas.width = img.width;
    canvas.height = img.height;
    ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0);
    dataURL = canvas.toDataURL("image/png");
    dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
    return Image.create({
      name: img.src,
      image: dataURL
    });
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
