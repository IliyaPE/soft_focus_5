http://softfocus.me

Run tests:

    bin/rspec

Start dev server:

    bin/rails s

Regenerate some images:

```ruby
Image.all.each {|i| i.file.reprocess!(:mini) }
```

Cleanup old images in production rails console:

```ruby
Image.lt(created_at: 2.months.ago).destroy_all
```