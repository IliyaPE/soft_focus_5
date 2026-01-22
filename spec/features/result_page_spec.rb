require 'rails_helper'

describe "result page" do
  before :each do
    @image = new_image
    @image.save!
  end

  it "shows preview images" do
    visit result_path(@image.id)
    src1 = find('.intro .left .picture img')['src']
    src2 = find('.intro .right .picture img')['src']
    link = find('.intro .right .download a')['href']
    expect(src1).to eq(@image.file.url(:half))
    expect(src2).to eq(@image.file.url(:halfsoft))
    expect(link).to eq(download_path(@image))
    visit src1
    visit src2
    visit link
  end

  it "should reject unknown ip" do
    @image.owner.update_attribute :ip, '8.8.4.4'
    visit result_path(@image)
    expect(page.status_code).to eq(401)
  end

  it "should allow admin to view other ip" do
    page.driver.browser.basic_authorize('bigbourin', 'secret')
    @image.owner.update_attribute :ip, '8.8.4.4'
    visit result_path(@image)
    expect(page.status_code).to eq(200)
  end

  after :all do
    Image.destroy_all
  end
end
