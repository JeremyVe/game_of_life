$redis = Redis::Namespace.new('gof', :redis => Redis.new(:url => "redis://h:pdcf2ea033a7c3d850a1e6c049ea0c26cb0f6510d34c9eb2d907b78ef4c37ad5d@ec2-34-198-54-21.compute-1.amazonaws.com:25159"))

$redis.set('cells', {} )
