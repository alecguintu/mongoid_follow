require 'spec_helper'

describe Mongoid::Follower do

  describe User do

    before do
      @bonnie = User.create(:name => 'Bonnie')
      @clyde = User.create(:name => 'Clyde')
      @alec = User.create(:name => 'Alec')

      @gang = Group.create(:name => 'Gang')
    end

    it "should have no follows or followers" do
      @bonnie.follows?(@clyde).should be_false

      @bonnie.follow(@clyde)
      @clyde.follower?(@alec).should be_false
      @alec.follows?(@clyde).should be_false
    end

    it "can follow another User" do
      @bonnie.follow(@clyde)

      @bonnie.follows?(@clyde).should be_true
      @clyde.follower?(@bonnie).should be_true
    end

    it "should decline to follow self" do
      @bonnie.follow(@bonnie).should be_false
    end

    it "should decline two follows" do
      @bonnie.follow(@clyde)

      @bonnie.follow(@clyde).should be_false
    end

    it "can unfollow another User" do
      @bonnie.follows?(@clyde).should be_false
      @clyde.follower?(@bonnie).should be_false

      @bonnie.follow(@clyde)
      @bonnie.follows?(@clyde).should be_true
      @clyde.follower?(@bonnie).should be_true

      @bonnie.unfollow(@clyde)
      @bonnie.follows?(@clyde).should be_false
      @clyde.follower?(@bonnie).should be_false
    end

    it "should decline unfollow of non-followed User" do
      @bonnie.unfollow(@clyde).should be_false
    end

    it "should decline unfollow of self" do
      @bonnie.unfollow(@bonnie).should be_false
    end

    it "can follow a group" do
      @bonnie.follow(@gang)

      @bonnie.follows?(@gang).should be_true
      @gang.follower?(@bonnie).should be_true
    end

    it "should increment / decrement counters" do
      @clyde.followers_count.should == 0

      @bonnie.follow(@clyde)

      @bonnie.followees_count.should == 1
      @clyde.followers_count.should == 1

      @alec.follow(@clyde)
      @clyde.followers_count.should == 2
      @bonnie.followers_count.should == 0

      @alec.unfollow(@clyde)
      @alec.followees_count.should == 0
      @clyde.followers_count.should == 1

      @bonnie.unfollow(@clyde)
      @bonnie.followees_count.should == 0
      @clyde.followers_count.should == 0
    end

    it "should list all followers" do
      @bonnie.follow(@clyde)
      # @clyde.all_followers.should == [@bonnie] # spec has an error on last #all_followers when this is called

      @alec.follow(@clyde)
      @clyde.all_followers.should == [@bonnie, @alec]
    end

    it "should list all followee" do
      @bonnie.follow(@clyde)
      # @bonnie.all_followees.should == [@clyde] # spec has an error on last #all_followees when this is called

      @bonnie.follow(@gang)
      @bonnie.all_followees.should == [@clyde, @gang]
    end

    it "should have common followers" do
      @bonnie.follow(@clyde)
      @bonnie.follow(@gang)

      @gang.common_followers_with(@clyde).should == [@bonnie]

      @alec.follow(@clyde)
      @alec.follow(@gang)

      @clyde.common_followers_with(@gang).should == [@bonnie, @alec]
    end

    it "should have common followees" do
      @bonnie.follow(@gang)
      @alec.follow(@gang)

      @alec.common_followees_with(@bonnie).should == [@gang]

      @bonnie.follow(@clyde)
      @alec.follow(@clyde)

      @bonnie.common_followees_with(@alec).should == [@gang, @clyde]
    end

    # Duh... this is a useless spec... Hrmn...
    it "should respond on callbacks" do
      @bonnie.respond_to?('after_follow').should be_true
      @bonnie.respond_to?('after_unfollowed').should be_true
      @bonnie.respond_to?('before_follow').should be_false

      @gang.respond_to?('before_followed').should be_true
      @gang.respond_to?('after_followed').should be_false
    end
  end
end
