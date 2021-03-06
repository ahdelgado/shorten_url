require 'rails_helper'

RSpec.feature 'Urls', type: :feature do
  scenario 'create a shortened URL, edit URL, and delete URL' do
    visit root_path
    expect(page).to have_content('List of Shortened URLs')
    expect(page).to_not have_content('Create New Short URL')
    expect(page).to have_content('Create New URL')
    url1 = Faker::Internet.url
    fill_in 'url_long_url', with: url1
    click_button 'Generate a Short URL'
    expect(current_path) == '/urls'
    expect(page).to have_content('Create New Short URL')
    expect(page).to have_content('List of URLs')
    expect(page).to have_content('Original URL')
    expect(page).to have_content('Short URL')
    expect(page).to have_content('Actions')
    expect(page).to_not have_content('List of Shortened URLs')
    click_link 'Edit'
    expect(current_path) == '/urls/*/edit'
    expect(page).to have_content('Change your URL')
    url2 = Faker::Internet.url
    fill_in 'url_long_url', with: url2
    click_button 'Generate a Short URL'
    expect(current_path) == '/urls'
    click_link 'Edit'
    fill_in 'url_long_url', with: url2
    click_button 'Generate a Short URL'
    expect(page).to have_content('URL already exists in database.')
    fill_in 'url_long_url', with: Faker::Internet.url
    click_button 'Generate a Short URL'
    expect(current_path) == '/urls'
    click_link 'Delete'
    expect(page).to have_content('Short URL deleted')
    click_link 'Create New Short URL'
    expect(current_path) == root_path
  end

  scenario 'pagination is used urls.count > 5 Url instances' do
    (0..5).each do create(:url) end
    visit urls_path
    expect(page).to have_css('div.pagination')
    Url.last.destroy
    visit urls_path
    expect(page).to_not have_css('div.pagination')
  end

  scenario 'redirects to last page in order to display newly created URL' do
    (0..6).each do create(:url) end
    visit root_path
    fill_in 'url_long_url', with: Faker::Internet.url
    click_button 'Generate a Short URL'
    expect(page).to have_current_path('/urls?page=2')
  end

  scenario 'edit action redirects back to previous page' do
    (0..5).each do create(:url) end
    visit urls_path(page: 2)
    click_link 'Edit'
    url3 = Faker::Internet.url
    fill_in 'url_long_url', with: url3
    click_button 'Generate a Short URL'
    expect(page).to have_current_path('/urls?page=2')
  end
end