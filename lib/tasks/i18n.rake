# frozen_string_literal: true

Rake::Task['assets:precompile'].enhance ['i18n:js:export']
