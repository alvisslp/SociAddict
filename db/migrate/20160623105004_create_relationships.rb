class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.belongs_to :referrer
      t.belongs_to :referral

      t.timestamps null: false
    end
    add_index :relationships, :referral_id
    add_index :relationships, :referrer_id
    add_index :relationships, [:referral_id, :referrer_id], unique: true
  end
end
