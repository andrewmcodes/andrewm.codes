# frozen_string_literal: true

require_relative "line_editor/basic"
require_relative "line_editor/readline"

module Freyia
  module LineEditor
    def self.readline(prompt, **)
      best_available.new(prompt, **).readline
    end

    def self.best_available
      [
        Freyia::LineEditor::Readline,
        Freyia::LineEditor::Basic,
      ].detect(&:available?)
    end
  end
end
