require "json"
require "net/http"
require "uri"

# Fetches repository and user metadata from the GitHub API at build time so the
# cards on /repositories/ can be rendered as static HTML. The al-folio default
# embeds SVGs from github-readme-stats.vercel.app, a shared public instance that
# is frequently rate limited or offline, which makes the page slow or blank.
#
# Results are cached under .jekyll-cache so local rebuilds do not re-fetch, and
# a failed fetch falls back to the cache (or to a bare stub) rather than
# breaking the build.
module Jekyll
  class GitHubRepoData < Generator
    safe true
    priority :high

    CACHE_FILE = ".jekyll-cache/github-repo-data.json".freeze
    API_ROOT = "https://api.github.com".freeze

    def generate(site)
      repositories = site.data["repositories"] || {}
      @cache = read_cache(site)
      @fresh = { "repos" => {}, "users" => {} }

      repos = {}
      (repositories["github_repos"] || []).each do |full_name|
        repos[full_name] = repo_data(full_name)
      end

      users = {}
      (repositories["github_users"] || []).each do |username|
        users[username] = user_data(username)
      end

      site.data["github"] = { "repos" => repos, "users" => users }
      write_cache(site)
    end

    private

    def repo_data(full_name)
      owner, name = full_name.split("/")
      cached = @cache.dig("repos", full_name)

      data = fetch("#{API_ROOT}/repos/#{owner}/#{name}")
      if data.nil?
        Jekyll.logger.warn "GitHub:", "using cached data for #{full_name}" if cached
        return cached || { "name" => name, "owner" => owner, "url" => "https://github.com/#{full_name}" }
      end

      result = {
        "name" => data["name"],
        "owner" => data.dig("owner", "login"),
        "url" => data["html_url"],
        "description" => data["description"],
        "language" => data["language"],
        "language_color" => language_color(data["language"]),
        "stars" => data["stargazers_count"],
        "forks" => data["forks_count"],
        "archived" => data["archived"],
      }
      @fresh["repos"][full_name] = result
      result
    end

    def user_data(username)
      cached = @cache.dig("users", username)

      data = fetch("#{API_ROOT}/users/#{username}")
      if data.nil?
        Jekyll.logger.warn "GitHub:", "using cached data for @#{username}" if cached
        return cached || { "login" => username, "url" => "https://github.com/#{username}" }
      end

      owned = fetch("#{API_ROOT}/users/#{username}/repos?per_page=100&type=owner&sort=pushed") || []
      stars = owned.reject { |r| r["fork"] }.sum { |r| r["stargazers_count"].to_i }

      result = {
        "login" => data["login"],
        "name" => data["name"],
        "url" => data["html_url"],
        "avatar" => data["avatar_url"],
        "bio" => data["bio"],
        "company" => data["company"],
        "location" => data["location"],
        "repos" => data["public_repos"],
        "followers" => data["followers"],
        "following" => data["following"],
        "stars" => stars,
      }
      @fresh["users"][username] = result
      result
    end

    # Returns parsed JSON, or nil if the request failed for any reason.
    # Follows redirects, which GitHub issues for renamed repositories.
    def fetch(url, redirects_left = 3)
      uri = URI(url)
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/vnd.github+json"
      request["User-Agent"] = "al-folio-site"
      token = ENV["GITHUB_TOKEN"] || ENV["GH_TOKEN"]
      request["Authorization"] = "Bearer #{token}" unless token.nil? || token.empty?

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 10) do |http|
        http.request(request)
      end

      if response.is_a?(Net::HTTPRedirection) && redirects_left > 0 && response["location"]
        return fetch(URI.join(url, response["location"]).to_s, redirects_left - 1)
      end

      unless response.is_a?(Net::HTTPSuccess)
        Jekyll.logger.warn "GitHub:", "#{url} returned #{response.code}"
        return nil
      end

      JSON.parse(response.body)
    rescue StandardError => e
      Jekyll.logger.warn "GitHub:", "could not fetch #{url}: #{e.class} - #{e.message}"
      nil
    end

    # A small subset of GitHub's linguist colors; anything else falls back to grey.
    COLORS = {
      "C" => "#555555",
      "C++" => "#f34b7d",
      "CSS" => "#563d7c",
      "Cuda" => "#3a4e3a",
      "Go" => "#00add8",
      "HTML" => "#e34c26",
      "Java" => "#b07219",
      "JavaScript" => "#f1e05a",
      "Jupyter Notebook" => "#da5b0b",
      "Lua" => "#000080",
      "MATLAB" => "#e16737",
      "Makefile" => "#427819",
      "Python" => "#3572a5",
      "R" => "#198ce7",
      "Ruby" => "#701516",
      "Rust" => "#dea584",
      "SCSS" => "#c6538c",
      "Shell" => "#89e051",
      "Swift" => "#f05138",
      "TeX" => "#3d6117",
      "TypeScript" => "#3178c6",
      "Vim script" => "#199f4b",
    }.freeze

    def language_color(language)
      COLORS[language] || "#8b949e"
    end

    def read_cache(site)
      path = site.in_source_dir(CACHE_FILE)
      return {} unless File.exist?(path)
      JSON.parse(File.read(path))
    rescue StandardError
      {}
    end

    # Merge so a partial failure keeps whatever the last good build recorded.
    def write_cache(site)
      return if @fresh["repos"].empty? && @fresh["users"].empty?
      path = site.in_source_dir(CACHE_FILE)
      FileUtils.mkdir_p(File.dirname(path))
      merged = {
        "repos" => (@cache["repos"] || {}).merge(@fresh["repos"]),
        "users" => (@cache["users"] || {}).merge(@fresh["users"]),
      }
      File.write(path, JSON.pretty_generate(merged))
    rescue StandardError => e
      Jekyll.logger.warn "GitHub:", "could not write cache: #{e.class} - #{e.message}"
    end
  end
end
