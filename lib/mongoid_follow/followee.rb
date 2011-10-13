module Mongoid
  module Followee
    extend ActiveSupport::Concern

    included do |base|
      base.field    :fferc, :type => Integer, :default => 0
      base.has_many :followers, :class_name => 'Follow', :as => :follower, :dependent => :destroy
    end

    # know if self is followed by model
    #
    # Example:
    # >> @clyde.follower?(@bonnie)
    # => true
    def follower?(model)
      0 < self.followers.find(:all, conditions: {ff_id: model.id}).limit(1).count
    end

    # get followees count
    #
    # Example:
    # >> @bonnie.followees_count
    # => 1
    def followers_count
      self.fferc
    end

    # view all selfs followers
    #
    # Example:
    # >> @clyde.all_followers
    # => [@bonnie, @alec]
    def all_followers
      get_followers_of(self)
    end

    # view all common followers of self against model
    #
    # Example:
    # >> @clyde.common_followers_with(@gang)
    # => [@bonnie, @alec]
    def common_followers_with(model)
      model_followers = get_followers_of(model)
      self_followers = get_followers_of(self)

      self_followers & model_followers
    end

    private
    def get_followers_of(me)
      me.followers.collect do |f|
        f.ff_type.constantize.find(f.ff_id)
      end
    end
  end
end
