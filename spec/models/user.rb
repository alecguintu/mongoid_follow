class User
  include Mongoid::Document
  include Mongoid::Followee
  include Mongoid::Follower
end