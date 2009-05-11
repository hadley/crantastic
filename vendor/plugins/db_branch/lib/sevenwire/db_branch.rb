require "ftools"

module Sevenwire
  class DbBranch
    def self.load_database
      if branch? && database_file_for_branch?
        Rails.configuration.database_configuration_file = database_file_for_branch
        ActiveRecord::Base.configurations = Rails.configuration.database_configuration
        ActiveRecord::Base.establish_connection
      end
    end

    def self.database_file_for_branch
      "#{Rails.root}/config/database.branch.#{branch}.yml"
    end

    def self.database_file_for_branch?
      File.exists?(database_file_for_branch)
    end

    def self.branch?
      !branch.blank?
    end

    def self.branch
      git? && git_repository? && `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/'`.chomp
    end

    def self.git?
      !`which git`.blank?
    end

    def self.git_repository?
      File.exists?("#{Rails.root}/.git")
    end
  end
end

Sevenwire::DbBranch.load_database
