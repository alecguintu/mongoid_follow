class Group
  include Mongoid::Document
  include Mongoid::Followee

  field :name

  def before_followed_by(follower)
    # before followee is followed
  end

  def before_unfollowed_by(follower)
    # before followee is unfollowed
  end
end