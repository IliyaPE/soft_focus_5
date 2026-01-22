require 'rails_helper'

describe Admin::ImagesController do
  it "reject unauthenticated" do
    visit admin_images_path
    expect(page.status_code).to eq(401)
  end

  it "allows authenticated use" do
    page.driver.browser.basic_authorize('bigbourin', 'secret')
    visit admin_images_path
    expect(page.status_code).to eq(200)
  end
end
