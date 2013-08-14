require 'spec_helper'

feature 'evaluating' do
  scenario do
    visit '/evaluate'
    fill_in :user_string, with: '\x.x'
    click_button 'Evaluate'
    expect(page).to have_selector 'img'
  end
end