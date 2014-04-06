namespace :build do

  LIST_VIEW = 'rails g faalis:js:list_view lib/scaffolds/'

  desc 'Clean database for fresh generation'
  task fresh: :environment do
    system "rm #{Rails.root}/db/development.sqlite3"
    system 'rake db:migrate --trace'
    system 'rake db:seed --trace'
  end

  desc 'Generate newsletter subsystem'
  task newsletter: :environment do
    system "#{LIST_VIEW}newsletter.json"
  end

  desc 'Generate newsletter users subsystem'
  task newsletter_user: :environment do
    system "#{LIST_VIEW}newsletter_user.json"
  end
end
