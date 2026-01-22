require 'rails_helper'

describe "legacy page" do
  before :each do
    visit legacy_path
  end

  it "allows image upload with UTF-8 filenames" do
    attach_file 'file', "spec/fixtures/jpn_すべての人間は.png"
    click_on 'Send'
    image = Image.last
    expect(current_path).to eq(result_path(image))
  end

  it "reject invalid images" do
    expect {
      attach_file 'file', "spec/fixtures/invalid.txt"
      click_on 'Send'
      expect(find('.error')).to have_content('not an image')
    }.not_to change(Image, :count)
  end

  it "reject missing files" do
    expect {
      click_on 'Send'
      expect(find('.error')).to have_content('select a file first')
    }.not_to change(Image, :count)
  end

  after :all do
    Image.destroy_all
  end
end
