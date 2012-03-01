class OtherUser
  include Mongoid::Document
  include Mongoid::Follower

  field :name
end