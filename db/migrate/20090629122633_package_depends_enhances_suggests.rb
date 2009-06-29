class PackageDependsEnhancesSuggests < ActiveRecord::Migration
  def self.up
    create_table :required_package_version, :id => false do |t|
      t.integer :version_id, :null => false
      t.integer :required_package_id, :null => false
    end

    add_index :required_package_version, [:version_id, :required_package_id],
                                          :unique => true

    create_table :enhanced_package_version, :id => false do |t|
      t.integer :version_id, :null => false
      t.integer :enhanced_package_id, :null => false
    end

    add_index :enhanced_package_version, [:version_id, :enhanced_package_id],
                                          :unique => true

    create_table :suggested_package_version, :id => false do |t|
      t.integer :version_id, :null => false
      t.integer :suggested_package_id, :null => false
    end

    add_index :suggested_package_version, [:version_id, :suggested_package_id],
                                          :unique => true

    # Create associations for existing data
    Version.all.each do |v|
      v.parse_depends.each  { |i| v.required_packages  << i }
      v.parse_enhances.each { |i| v.enhanced_packages  << i }
      v.parse_suggests.each { |i| v.suggested_packages << i }
    end
  end

  def self.down
    drop_table :required_package_version
    drop_table :enhanced_package_version
    drop_table :suggested_package_version
  end
end
