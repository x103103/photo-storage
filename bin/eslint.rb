#!/usr/bin/env ruby

require 'set'

BASE_REMOTE = 'origin'.freeze
BASE_BRANCH = 'main'.freeze
diff_list = []
commit_to_files = {}

system "git fetch #{BASE_REMOTE} #{BASE_BRANCH}"

commit_list = `git --no-pager log --no-merges #{BASE_REMOTE}/#{BASE_BRANCH}...HEAD | grep -e '^commit'`
commit_list = commit_list.split("\n").map { |commit| commit.slice(7..14) }
file_diff_list = `git --no-pager diff #{BASE_REMOTE}/#{BASE_BRANCH}...HEAD --name-only`
file_diff_list = file_diff_list.split("\n")

puts "\e[32m#{file_diff_list.size} files modified...\e[0m"

file_diff_list.each do |file|
  unless File.exist?(file)
    file_diff_list.delete(file)
    next
  end

  commit_list.each do |commit|
    unless commit_to_files.key?(commit)
      git_files = `git diff-tree --no-commit-id --name-only -r #{commit}`
      commit_to_files[commit] = git_files.split("\n").to_set
    end

    next unless commit_to_files[commit].include?(file)

    diffs = `git --no-pager blame --follow --show-name -s #{file} | grep -e .js -e .jsx | grep #{commit}`
    diffs = diffs.split("\n")

    diffs.each do |diff_line|
      diff_list << diff_line
    end
  end
end

err_lines = []

eslint_results = `./node_modules/.bin/eslint #{file_diff_list.join(' ')} --format unix`
eslint_results = eslint_results.split("\n")

eslint_results.each do |eslint_line|
  diff_list.each do |diff_list_line|
    matches = diff_list_line.match(/^[a-z0-9]{8} ([-\/\w]+\.jsx?)\s*(\d*).*$/)
    next if matches.nil?

    eslint_identifier = "#{matches[1]}:#{matches[2]}:"

    if eslint_line.include?(eslint_identifier)
      err_lines << eslint_line
      next
    end
  end
end

if err_lines.size.positive?
  puts "\e[31m#{err_lines.size} Lint Errors\e[0m"
  puts "\e[31m-----------------------------------\e[0m"
  err_lines.each do |err_line|
    puts "\e[31m#{err_line}\e[0m\n"
  end
  puts "\e[31mPlease resolve them before merging.\e[0m"
  exit(1)
else
  puts "\e[32mNo issues found, good job!\e[0m"
end
