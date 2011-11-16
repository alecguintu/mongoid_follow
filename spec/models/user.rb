class User
  include Mongoid::Document
  include Mongoid::Followee
  include Mongoid::Follower

  field :name

  def after_follow(followee)
    # after follower follows
  end

  def after_followed_by(follower)
    # after followee is followed
  end

  def after_unfollowed_by(followee)
    # after follower unfollows
  end
end