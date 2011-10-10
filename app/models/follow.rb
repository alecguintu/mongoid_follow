class Follow
  include Mongoid::Document

  field :ff_type
  field :ff_id

  belongs_to :follower, :polymorphic => true
  belongs_to :followee, :polymorphic => true
end