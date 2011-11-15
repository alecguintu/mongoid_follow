class User
  include Mongoid::Document
  include Mongoid::Followee
  include Mongoid::Follower

  field :name

  def after_follow
    # after follower follows
  end

  def after_unfollowed
    # after follower unfollows
  end
end