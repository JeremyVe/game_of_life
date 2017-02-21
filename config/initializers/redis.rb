$redis = Redis::Namespace.new('gof', :redis => Redis.new

$redis.set('cells', {} )
