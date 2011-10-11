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
    # >> @clyde.follower?(@bonnie)
    # => true
    def followers(model)
      #TODO
    end
  end
end
