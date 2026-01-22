require 'rails_helper'

describe "home page" do
  before :each do
    visit '/'
  end

  it "displays the project name & author" do
    expect(page).to have_selector('h1', :text => 'SoftFocus')
    expect(page).to have_selector('footer a', :text => 'Adrien Rey-Jarthon')
  end

  it "shows demo images and switcher", :js => true do
    img1 = find('.intro .left .picture img')
    src1 = img1['src']
    img2 = find('.intro .right .picture img')
    src2 = img2['src']
    # test js demo switcher
    expect {
    expect {
        find('.intro .middle a#next_demo').click
    }.to change { img2['src'] }
    }.to change { img1['src'] }
  end

  it "shows valid legacy upload link" do
    click_on 'legacy upload form'
    expect(current_path).to eq(legacy_path)
  end
end
