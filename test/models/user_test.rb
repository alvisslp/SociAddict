require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.create(name: 'Pierre')
    @user1 = User.create(name: 'Paul')
    @user2 = User.create(name: 'Jacques')
    @user3 = User.create(name: 'Kevin')
    @user4 = User.create(name: 'Kevin2')
    @user5 = User.create(name: 'Kevin3')
    @user6 = User.create(name: 'Jean')
    @user.referrals << @user1
    @user.referrals << @user2
    @user1.referrals << @user3
    @user1.referrals << @user4
    @user1.referrals << @user5
    @user2.referrals << @user6
    @user.reload
    @user1.reload
    @user2.reload
    @user3.reload
    @user4.reload
    @user5.reload
    @user6.reload
  end

  test 'Should be referral' do
    assert(@user.referrals.include?(@user1), '@user1 not referral of @user')
    assert(@user.referrals.include?(@user2), '@user2 not referral of @user')
    assert(@user1.referrals.include?(@user3), '@user1 not referral of @user')
  end

  test 'should not be referral' do
    assert(!@user.referrals.include?(@user), '@user referral of @user')
    assert(!@user.referrals.include?(@user3), '@user3 referral of @user')
    assert(!@user1.referrals.include?(@user), '@user referral of @user1')
    assert(!@user1.referrals.include?(@user1), '@user1 referral of @user1')
    assert(!@user1.referrals.include?(@user2), '@user2 referral of @user1')
    assert(!@user2.referrals.include?(@user), '@user referral of @user2')
    assert(!@user2.referrals.include?(@user1), '@user1 referral of @user2')
    assert(!@user2.referrals.include?(@user2), '@user2 referral of @user2')
    assert(!@user2.referrals.include?(@user3), '@user3 referral of @user2')
    assert(!@user3.referrals.include?(@user), '@user referral of @user3')
    assert(!@user3.referrals.include?(@user1), '@user1 referral of @user3')
    assert(!@user3.referrals.include?(@user2), '@user2 referral of @user3')
    assert(!@user3.referrals.include?(@user3), '@user3 referral of @user3')
  end

  test 'should be referrer' do
    assert_equal(@user1.referrer, @user, '@user referrer of @user1')
    assert_equal(@user2.referrer, @user, '@user referrer of @user2')
  end

  test 'should not be referrer' do
    assert_not_equal(@user.referrer, @user, '@user referrer of @user')
    assert_not_equal(@user.referrer, @user1, '@user1 referrer of @user')
    assert_not_equal(@user.referrer, @user2, '@user2 referrer of @user')
    assert_not_equal(@user.referrer, @user3, '@user3 referrer of @user')
    assert_not_equal(@user1.referrer, @user1, '@user1 referrer of @user1')
    assert_not_equal(@user1.referrer, @user2, '@user1 referrer of @user2')
    assert_not_equal(@user1.referrer, @user3, '@user1 referrer of @user3')
    assert_not_equal(@user2.referrer, @user1, '@user2 referrer of @user1')
    assert_not_equal(@user2.referrer, @user2, '@user2 referrer of @user2')
    assert_not_equal(@user2.referrer, @user3, '@user2 referrer of @user3')
    assert_not_equal(@user3.referrer, @user, '@user referrer of @user3')
    assert_not_equal(@user3.referrer, @user2, '@user2 referrer of @user3')
    assert_not_equal(@user3.referrer, @user2, '@user3 referrer of @user3')
  end

  test 'should be original' do
    assert_equal(@user1.original, @user, '@user not original of @user1')
    assert_equal(@user2.original, @user, '@user2 referral de @user')
    assert_equal(@user3.original, @user, '@user2 referral de @user')
  end

  test 'should not be original' do
    assert_not_equal(@user.original, @user1, '@user1 original of @user')
    assert_not_equal(@user.original, @user2, '@user2 original of @user')
    assert_not_equal(@user.original, @user3, '@user3 original of @user')
    assert_not_equal(@user1.original, @user1, '@user1 original of @user1')
    assert_not_equal(@user1.original, @user2, '@user2 original of @user1')
    assert_not_equal(@user1.original, @user3, '@user3 original of @user1')
    assert_not_equal(@user2.original, @user1, '@user1 original of @user2')
    assert_not_equal(@user2.original, @user2, '@user2 original of @user2')
    assert_not_equal(@user2.original, @user3, '@user3 original of @user2')
    assert_not_equal(@user3.original, @user1, '@user1 original of @user3')
    assert_not_equal(@user3.original, @user2, '@user2 original of @user3')
    assert_not_equal(@user3.original, @user3, '@user3 original of @user3')
  end

  test 'Paul to the top' do
    result = User.top(1).first
    assert_equal(result, @user1, "#{result.name} is the first")
  end

  test 'Destroy Kevin3' do
    nb_referrals = @user1.referrals.size
    @user5.destroy
    assert_not_equal(@user1.referrals.size, nb_referrals, "Paul still have #{nb_referrals} referrals")
  end

  test 'Find Users with no referral' do
    user_list = User.no_referrals
    assert(user_list.include?(@user3), '@user3 has referrals')
    assert(user_list.include?(@user4), '@user4 has referrals')
    assert(user_list.include?(@user5), '@user5 has referrals')
    assert(user_list.include?(@user6), '@user6 has referrals')
    assert(!user_list.include?(@user), '@user has no referral')
    assert(!user_list.include?(@user1), '@user1 has no referral')
    assert(!user_list.include?(@user2), '@user2 has no referral')
  end

  test 'more than' do
    user_list = User.more_than(1)
    assert(!user_list.include?(@user2), '@user2 has more than 1 referral')
    assert(!user_list.include?(@user3), '@user3 has more than 1 referral')
    assert(!user_list.include?(@user4), '@user4 has more than 1 referral')
    assert(!user_list.include?(@user5), '@user5 has more than 1 referral')
    assert(!user_list.include?(@user6), '@user6 has more than 1 referral')
    assert(user_list.include?(@user), '@user has less than 2 referral')
    assert(user_list.include?(@user1), '@user1 has less than 2 referral')
    user_list = User.more_than(2)
    assert(!user_list.include?(@user), '@user has more than 3 referral')
    assert(user_list.include?(@user1), '@user1 has less than 3 referral')
  end

  test 'more or equal to' do
    user_list = User.more_or_equal_to(1)
    assert(!user_list.include?(@user3), '@user3 has referrals')
    assert(!user_list.include?(@user4), '@user4 has referrals')
    assert(!user_list.include?(@user5), '@user5 has referrals')
    assert(!user_list.include?(@user6), '@user6 has referrals')
    assert(user_list.include?(@user), '@user has no referral')
    assert(user_list.include?(@user1), '@user1 has no referral')
    assert(user_list.include?(@user2), '@user2 has no referral')
    user_list = User.more_or_equal_to(2)
    assert(user_list.include?(@user), '@user has less than 2 referral')
    assert(user_list.include?(@user1), '@user1 has less than 2 referral')
    assert(!user_list.include?(@user2), '@user2 has more than 1 referral')
  end
end
