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
      if self.id != model.id && !self.follows?(model)
        model.followers.create!(:ff_type => self.class.name, :ff_id => self.id)
        model.inc(:fferc, 1)

        self.followees.create!(:ff_type => model.class.name, :ff_id => model.id)
        self.inc(:ffeec, 1)
      else
        return false
      end
    end

    # unfollow a model
    #
    # Example:
    # >> @bonnie.unfollow(@clyde)
    def unfollow(model)
      if self.id != model.id && self.follows?(model)
        model.followers.where(:ff_type => self.class.name, :ff_id => self.id).destroy
        model.inc(:fferc, -1)

        self.followees.where(:ff_type => model.class.name, :ff_id => model.id).destroy
        self.inc(:ffeec, -1)
      else
        return false
      end
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
    # >> @alec.all_followees
    # => [@bonnie]
    def all_followees
      get_followees_of(self)
    end

    # view all common followees of self against model
    #
    # Example:
    # >> @clyde.common_followees_with(@gang)
    # => [@bonnie, @alec]
    def common_followees_with(model)
      model_followees = get_followees_of(model)
      self_followees = get_followees_of(self)

      self_followees & model_followees
    end

    private
    def get_followees_of(me)
      me.followees.collect do |f|
        f.ff_type.constantize.find(f.ff_id)
      end
    end
  end
end
