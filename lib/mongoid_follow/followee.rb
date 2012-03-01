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
    # Note: this is a cache counter
    #
    # Example:
    # >> @bonnie.followers_count
    # => 1
    def followers_count
      self.fferc
    end

    # get followers count by model
    #
    # Example:
    # >> @bonnie.followers_count_by_model(User)
    # => 1
    def followers_count_by_model(model)
      self.followers.where(:ff_type => model.to_s).count
    end

    # view all selfs followers
    #
    # Example:
    # >> @clyde.all_followers
    # => [@bonnie, @alec]
    def all_followers
      get_followers_of(self)
    end

    # view all selfs followers by model
    #
    # Example:
    # >> @clyde.all_followers_by_model
    # => [@bonnie]
    def all_followers_by_model(model)
      get_followers_of(self, model)
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
    def get_followers_of(me, model = nil)
      followers = !model ? me.followers : me.followers.where(:ff_type => model.to_s)

      followers.collect do |f|
        f.ff_type.constantize.find(f.ff_id)
      end
    end

    def method_missing(missing_method, *args, &block)
      if missing_method.to_s =~ /^(.+)_followers_count$/
        followers_count_by_model($1.camelize)
      elsif missing_method.to_s =~ /^all_(.+)_followers$/
        all_followers_by_model($1.camelize)
      else
        super
      end
    end
  end
end
