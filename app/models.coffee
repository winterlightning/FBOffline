#models
class Feed extends Spine.Model
  @configure "Feed", "id", "from&id", "from&name", "to&id", "to&name", "message", "type", "updated_time", "picture", "link", "story", "name", "tag"
  @extend Spine.Model.Local
  
class FeedList extends Spine.Model
  @configure "FeedList", "tag", "name", "icon"
  @extend Spine.Model.Local
  @extend(Spine.Events)

class Image extends Spine.Model
  @configure "Image", "image", "name", "id"
  @extend Spine.Model.Local

class Friends extends Spine.Model
  @configure "Friends", "name", "id"
  @extend Spine.Model.Local

exports = this
this.Feed = Feed
this.FeedList = FeedList
this.Image = Image
this.Friends = Friends