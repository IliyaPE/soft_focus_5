require 'rails_helper'

describe Image do
  it "have default blur and alpha" do
    img = Image.new
    expect(img.alpha).to be > 0
    expect(img.blur).to be > 0
  end

  it "are processed after save" do
    img = new_image
    img.save
    expect(img.file?).to eq(true)
    for style in img.file.styles.keys
      expect(File.exists?(img.file.path(style))).to eq(true)
    end
  end

  it "errors on invalid image" do
    img = new_image :file => File.open("spec/fixtures/invalid.txt")
    expect(img.save).to eq(false)
    expect(img.errors[:file_content_type]).not_to be_empty
  end

  it "errors without image" do
    img = new_image :file => nil
    expect(img.save).to eq(false)
    expect(img.errors[:file]).not_to be_empty
  end
end
