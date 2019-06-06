
Then (/^I tap view 1$/) do
  touch("view marked:'tapView'")
  status = backdoor "requestManualPost:", 'dummyParam'
  puts 'sleeping now -----'
  sleep(5)
end

Then (/^I double tap view 1$/) do
  double_tap("view marked:'tapView'")
  status = backdoor "requestManualPost:", 'dummyParam'
  puts 'sleeping now -----'
  sleep(5)
end

Then (/^I left swipe view 2$/) do
  swipe :left, :query => "view marked:'swipeView'"
  status = backdoor "requestManualPost:", 'dummyParam'
  puts 'sleeping now -----'
  sleep(5)
end

Then (/^I right swipe view 2$/) do
  swipe :right, :query => "view marked:'swipeView'"
  status = backdoor "requestManualPost:", 'dummyParam'
  puts 'sleeping now -----'
  sleep(5)
end

Then (/^I pinch view 3$/) do
  pinch(:in, :query => "view marked:'pinchView'")
  status = backdoor "requestManualPost:", 'dummyParam'
  puts 'sleeping now -----'
  sleep(5)
end