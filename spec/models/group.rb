class Group
  include Mongoid::Document
  include Mongoid::Followee

  field :name
end