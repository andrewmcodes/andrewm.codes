# frozen_string_literal: true

module BridgetownSitemap
  class GitInspector
    def initialize(resource)
      @resource = resource
    end

    def latest_git_commit_date
      return nil unless git_repo?
      return nil unless repo_origin?

      date = cache.getset(@resource.id) do
        `git log -1 --pretty="format:%cI" "#{@resource.path}"`
      end

      Time.parse(date) if !date.nil? && date.size > 0
    end

    private

      def repo_origin?
        @resource.model.origin.url.scheme == "repo"
      end

      def git_repo?
        self.class.git_repo?
      end

      def self.git_repo?
        return @git_repo if defined?(@git_repo)

        @git_repo = system("git rev-parse --is-inside-work-tree", out: File::NULL, err: File::NULL)
      end

      def cache
        @cache ||= Bridgetown::Cache.new("sitemap")
      end
  end
end
