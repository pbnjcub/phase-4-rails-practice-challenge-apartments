class CreateLeases < ActiveRecord::Migration[6.1]
  def change
    create_table :leases do |t|
      t.decimal :rent

      t.timestamps
    end
  end
end
