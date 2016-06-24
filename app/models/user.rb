class User < ActiveRecord::Base
  has_many :relationships, foreign_key: 'referrer_id'
  has_many :referrals, :through => :relationships

  has_one :relationship, foreign_key: 'referral_id'
  has_one :referrer, :through => :relationship
  after_destroy :destroy_ref
  accepts_nested_attributes_for :referrer

  def initialize(attributes = nil, options = {})
    unless attributes.nil?
      # Change this line to allow 2 user with the same name / depend on referrer attribution method / works with pseudonymes
      attributes['referrer'] = User.where(name: attributes['referrer']).first
    end
    super(attributes, options)
  end

  def update(attributes)
    puts attributes.to_s
    unless attributes['referrer_attributes'].nil?
      # Change this lines to allow 2 user with the same name / depend on referrer attribution method / works with pseudonymes
      self.referrer = nil
      self.referrer = User.where(name: attributes['referrer_attributes']['name']).first unless attributes['referrer_attributes']['name'] == ''

      attributes.delete('referrer_attributes')
    end
    unless attributes['referrer'].nil?
      # Change this line to allow 2 user with the same name / depend on referrer attribution method
      attributes['referrer'] = User.where(name: attributes['referrer']).first
    end
    super(attributes)
  end

  def original
    ref = self
    ref = ref.referrer until ref.referrer.nil?
    ref
  end

  def self.top(x)
    select('users.id, count(relationships.referrer_id) AS referrer_count')
        .joins(:relationships)
        .group('users.id')
        .order('referrer_count DESC')
        .limit(x).map { |result| User.find(result.id) }
  end

  def self.more_than(x)
    return User.all if x.to_i < 0
    select('users.id, count(relationships.referrer_id) AS referrer_count')
        .joins(:relationships)
        .group('users.id')
        .order('referrer_count DESC')
        .having("count(relationships.referrer_id) > #{x}")
        .map { |result| User.find(result.id) }
  end

  def self.more_or_equal_to(x)
    more_than(x.to_i - 1)
  end

  def self.no_referrals
    select('users.id').where('NOT EXISTS (SELECT 1 FROM relationships WHERE referrer_id = users.id)')
        .map { |result| User.find(result.id) }
  end

  private

  def destroy_ref
    Relationship.where('referrer_id = ? OR referral_id = ?', id, id).destroy_all
  end
end
