# frozen_string_literal: true

require_relative './app'

Database.setup(database: 'bookmark_manager')
run BookmarkManager
