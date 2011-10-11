module Mongoid
  module Follower
    extend ActiveSupport::Concern

    included do |base|
      base.field    :ffeec, :type => Integer, :default => 0
      base.has_many :followees, :class_name => 'Follow', :as => :followee, :dependent => :destroy
    end

    # follow a model
    #
    # Example:
    # >> @bonnie.follow(@clyde)
    def follow(model)
      model.followers.create!(:ff_type => self.class.name, :ff_id => self.id)
      model.inc(:fferc, 1)

      self.followees.create!(:ff_type => model.class.name, :ff_id => model.id)
      self.inc(:ffeec, 1)
    end

    # unfollow a model
    #
    # Example:
    # >> @bonnie.unfollow(@clyde)
    def unfollow(model)
      model.followers.where(:ff_type => self.class.name, :ff_id => self.id).destroy
      model.inc(:fferc, -1)

      self.followees.where(:ff_type => model.class.name, :ff_id => model.id).destroy
      self.inc(:ffeec, -1)
    end

    # know if self is already following model
    #
    # Example:
    # >> @bonnie.follows?(@clyde)
    # => true
    def follows?(model)
      0 < self.followees.find(:all, conditions: {ff_id: model.id}).limit(1).count
    end

    # get followees count
    #
    # Example:
    # >> @bonnie.followees_count
    # => 1
    def followees_count
      self.ffeec
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
