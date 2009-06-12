class FixDateForVersionColumns < ActiveRecord::Migration
  def self.up
    Version.all.each do |version|
      begin
        version.date = Date.parse(version.date.to_s)
      rescue
        version.date = nil
      end
      version.save!
    end
  end

  def self.down
  end
end
