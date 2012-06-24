#models
class Feed extends Spine.Model
  @configure "Feed", "id", "from&id", "from&name", "message", "type", "updated_time", "picture", "link"
  @extend Spine.Model.Local

exports = this
this.Feed = Feed