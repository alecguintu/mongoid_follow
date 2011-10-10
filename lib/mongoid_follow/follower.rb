module Mongoid
  module Follower
    extend ActiveSupport::Concern

    included do |base|
      base.has_many :followees, :class_name => 'Follow', :as => :followee, :dependent => :destroy
    end

    # follow a model
    #
    # Example:
    # >> @bonnie.follow(@clyde)
    def follow(model)
      model.followers.create!(:ff_type => self.class.name, :ff_id => self.id)

      self.followees.create!(:ff_type => model.class.name, :ff_id => model.id)
    end

    # unfollow a model
    #
    # Example:
    # >> @bonnie.unfollow(@clyde)
    def unfollow(model)
      model.followers.where(:ff_type => self.class.name, :ff_id => self.id).destroy

      self.followees.where(:ff_type => model.class.name, :ff_id => model.id).destroy
    end

    # follow a model
    #
    # Example:
    # >> @bonnie.follows?(@clyde)
    # => true
    def follows?(model)
      0 < self.followees.find(:all, conditions: {ff_id: model.id}).limit(1).count
    end

    # view all selfs followees
    #
    # Example:
    # >> @alec.followees
    def followees(model)
      # TODO
    end
  end
end
