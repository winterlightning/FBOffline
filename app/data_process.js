(function() {
  window.suck_down_feed = function(json) {
    var data, field, field_a, field_b, one, x, _i, _j, _len, _len2, _ref, _ref2, _results;
    _ref = json.data;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      x = _ref[_i];
      data = {};
      _ref2 = Feed.attributes;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        field = _ref2[_j];
        if (field.indexOf("&") === -1) {
          if (x[field] != null) {
            data[field] = x[field];
          }
        } else {
          field_a = field.split("&")[0];
          field_b = field.split("&")[1];
          one = x[field_a];
          data[field] = one[field_b];
        }
      }
      console.log(data);
      _results.push(Feed.findByAttribute("id", x["id"]) != null ? console.log("this feed is already there") : Feed.create(data));
    }
    return _results;
  };
}).call(this);