require 'rails_helper'

describe "download request" do
  before :each do
    @image = new_image
    @image.save
  end

  it "should be valid" do
    visit download_path(@image)
    expect(page.status_code).to eq(200)
  end

  it "should update downloaded_at" do
    expect {
      visit download_path(@image)
      @image.reload
    }.to change(@image, :downloaded_at)
  end

  it "should reject unknown ip" do
    @image.owner.update_attribute :ip, '8.8.4.4'
    visit download_path(@image)
    expect(page.status_code).to eq(401)
  end

  it "should allow admin to download other ip" do
    page.driver.browser.basic_authorize('bigbourin', 'secret')
    @image.owner.update_attribute :ip, '8.8.4.4'
    visit download_path(@image)
    expect(page.status_code).to eq(200)
  end

  after :all do
    Image.destroy_all
  end
end