Given(/^there is a newsletter_user named "(.*?)" in database$/) do |name|
  NewsletterUser.new(:name => name).save!
end

Then(/^there shouldn't be any newsletter_user$/) do
  NewsletterUser.all.count.should == 0
end
