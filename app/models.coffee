#models
class Feed extends Spine.Model
  @configure "Feed", "id", "from_id", "from_name", "message", "type", "updated_time", "picture", "link"
  @extend Spine.Model.Local

exports = this
this.Feed = Feed