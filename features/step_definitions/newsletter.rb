Given(/^there is a newsletter named "(.*?)" in database$/) do |name|
  Newsletter.new(:name => name).save!
end

Then(/^there shouldn't be any newsletter$/) do
  Newsletter.all.count.should == 0
end
