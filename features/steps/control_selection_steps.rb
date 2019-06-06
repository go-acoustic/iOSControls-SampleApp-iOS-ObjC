

Then (/^I select row (1|2|3|4|5|6) on home screen table$/) do |selected_row|
  #each_cell(:animate => true) do |row, sec|
    #if row == Integer(selected_row) - 1
      row = Integer(selected_row) - 1
      puts "selecting row: #{row}"
      #txt = query("tableViewCell indexPath:#{row},#{sec} label", :text).first
      touch("tableViewCell index:#{row}")
      sleep(15)
      status = backdoor "requestManualPost:", 'dummyParam'
    #end
  #end
  #sleep(5)
end

Then (/^I touch Custom Event Button$/) do
  touch("view marked:'CustomEventBtn'")
  sleep(10)
  status = backdoor "requestManualPost:", 'dummyParam'
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I touch App Crash Button$/) do
  touch("view marked:'AppCrashBtn with image'")
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I touch Location Button$/) do
  touch("view marked:'LocationBtn'")
  sleep(10)
  status = backdoor "requestManualPost:", 'dummyParam'
end

Then (/^I touch button labeled tapView$/) do
  touch("view marked:'tapView'")
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I touch textField1$/) do
  touch("view marked:'textField1'")
  sleep(10)
  status = backdoor "requestManualPost:", 'dummyParam'
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I enter text in textField1$/) do
  touch("view marked:'textField1'")
  keyboard_enter_text("Watson1234")
  query "textField isFirstResponder:1", :resignFirstResponder
  sleep(10)
  status = backdoor "requestManualPost:", 'dummyParam'
  #tap_keyboard_action_key()
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I touch TeaLeaf Sample App back button$/) do
  touch("view marked:'TeaLeaf Sample App'")
  status = backdoor "requestManualPost:", 'dummyParam'
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I touch Get Photo button$/) do
  touch("view marked:'Get Photo'")
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I touch Post to Server button$/) do
  touch("view marked:'Post to Server'")
  status = backdoor "requestManualPost:", 'dummyParam'
  puts "sleeping now -----"
  sleep(5)
end

Then (/^I touch Back Button$/) do
  touch("UINavigationItemButtonView index:0")
end
