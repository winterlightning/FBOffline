class DelayedOp
  constructor: (@callback) -> @count = 1
  wait: => @count++
  ok: => @callback() unless --@count
  ready: => @ok()
  
exports = this
exports.DelayedOp = DelayedOp