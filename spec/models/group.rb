class Group
  include Mongoid::Document
  include Mongoid::Followee

  field :name

  def before_followed
    # before followee is followed
  end

  def before_unfollowed
    # before followee is unfollowed
  end
end