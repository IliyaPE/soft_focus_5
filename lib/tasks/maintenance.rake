namespace :maintenance do
  desc "Delete images older than 30 days and their associated files"
  task expire_images: :environment do
    cutoff = 30.days.ago
    old_images = Image.where(:created_at.lt => cutoff)
    count = old_images.count
    old_images.each do |image|
      image.file.destroy
      image.destroy
    end
    puts "Deleted #{count} image(s) older than 30 days"
  end
end
