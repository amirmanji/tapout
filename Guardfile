group :backend do
  guard 'bundler' do
    watch('Gemfile.lock') { 'rspec' }
  end

  guard 'rspec', cli: '--fail-fast' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})       { |m| "spec/lib/\#{m[1]}_spec.rb" }
    watch(%r{^spec/models/.+\.rb$}) { ['spec/models', 'spec/acceptance'] }
    watch(%r{^app/(.+)\.rb$})       { |m| "spec/#{m[1]}_spec.rb" }

    watch('spec/spec_helper.rb') { 'spec' }
  end
end

group :frontend do
  guard 'livereload' do
    watch(%r(^(app|lib|Gemfile.lock)/.*))
  end
end
