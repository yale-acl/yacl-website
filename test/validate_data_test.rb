require 'tmpdir'
require 'fileutils'
require 'open3'
require_relative '../scripts/validate_data'

ROOT = File.expand_path('..', __dir__)
$count = 0

def check(name)
  yield
  $count += 1
  puts "PASS: #{name}"
end

def invalid(name, file, pattern)
  check(name) do
    Dir.mktmpdir do |root|
      FileUtils.cp_r(File.join(ROOT, '_data'), root)
      FileUtils.cp_r(File.join(ROOT, 'schemas'), root)
      path = File.join(root, '_data', file)
      yield path
      begin
        DataValidation.validate!(root)
      rescue DataValidation::Error => e
        raise "Unexpected diagnostic: #{e.message}" unless e.message.match?(pattern)
      else
        raise 'Invalid data was accepted'
      end
    end
  end
end

def mutate(path)
  data = YAML.safe_load_file(path)
  yield data
  File.write(path, YAML.dump(data))
end

check('existing data validates') { raise unless DataValidation.validate!(ROOT) == 5 }
%w[role advisor typo].each do |field|
  invalid("reject student #{field}", 'people.yml', /phd_students\/0\/#{field}/) do |path|
    mutate(path) { |d| d['phd_students'][0][field] = 'Unsupported' }
  end
end
invalid('required name', 'people.yml', /missing required properties: name/) do |path|
  mutate(path) { |d| d['phd_students'][0].delete('name') }
end
invalid('invalid email', 'people.yml', /email/) do |path|
  mutate(path) { |d| d['phd_students'][0]['email'] = 'not-an-email' }
end
invalid('wrong section type', 'people.yml', /not an array/) do |path|
  mutate(path) { |d| d['postdocs'] = nil }
end
invalid('invalid calendar date', 'updates.yml', /date/) do |path|
  mutate(path) { |d| d[0]['date'] = '2026-02-30' }
end
invalid('unknown update tag', 'updates.yml', /not one of/) do |path|
  mutate(path) { |d| d[0]['tag'] = 'typo' }
end
invalid('nested course typo', 'courses.yml', /titel/) do |path|
  mutate(path) { |d| d['semesters'][0]['courses'][0]['titel'] = 'Typo' }
end
invalid('missing navigation URL', 'nav.yml', /missing required properties: url/) do |path|
  mutate(path) { |d| d[0].delete('url') }
end
invalid('malformed seminar link', 'seminars.yml', /links/) do |path|
  mutate(path) { |d| d['upcoming'][0]['links'] = [{'title' => 'Missing URL'}] }
end
invalid('duplicate YAML key', 'nav.yml', /duplicate key "title"/) do |path|
  File.write(path, "- title: First\n  title: Second\n  url: /\n")
end
invalid('multiple YAML documents', 'nav.yml', /exactly one YAML document/) do |path|
  File.write(path, "---\n[]\n---\n[]\n")
end
invalid('unknown data file', 'new.yml', /missing schema/) { |path| File.write(path, '[]') }
invalid('missing data file', 'people.yml', /required data file is missing/) { |path| File.delete(path) }
check('Jekyll build rejects invalid data') do
  Dir.mktmpdir do |root|
    %w[_data schemas scripts _plugins].each do |dir|
      FileUtils.cp_r(File.join(ROOT, dir), root)
    end
    File.write(File.join(root, '_config.yml'), "title: Validation test\n")
    mutate(File.join(root, '_data', 'people.yml')) do |d|
      d['phd_students'][0]['advisor'] = 'Unsupported'
    end
    output, status = Open3.capture2e('bundle', 'exec', 'jekyll', 'build',
                                    '--source', root, '--destination', File.join(root, '_site'))
    raise "Build did not reject invalid data: #{output}" if status.success? || !output.include?('YAML data validation failed')
  end
end
puts "#{$count} validation checks passed."
