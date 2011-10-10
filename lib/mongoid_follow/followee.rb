module Mongoid
  module Followee
    extend ActiveSupport::Concern

    included do |base|
      base.has_many :followers, :class_name => 'Follow', :as => :follower, :dependent => :destroy
    end

    # see if this model is followed of some model
    #
    # Example:
    # >> @clyde.follower?(@bonnie)
    # => true
    def follower?(model)
      0 < self.followers.find(:all, conditions: {ff_id: model.id}).limit(1).count
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
