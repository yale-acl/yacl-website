require 'json'
require 'json_schemer'
require 'yaml'

module DataValidation
  class Error < StandardError; end

  def self.check_keys(node, file)
    if node.is_a?(Psych::Nodes::Mapping)
      keys = {}
      node.children.each_slice(2) do |key, _value|
        unless key.is_a?(Psych::Nodes::Scalar)
          raise Error, "#{file}:#{key.start_line + 1}: mapping keys must be strings"
        end
        if keys.key?(key.value)
          raise Error, "#{file}:#{key.start_line + 1}: duplicate key #{key.value.inspect}"
        end
        keys[key.value] = true
      end
    end
    Array(node.children).each { |child| check_keys(child, file) }
  end

  def self.validate_file(file, schema_file)
    raise Error, "#{file}: missing schema #{schema_file}" unless File.file?(schema_file)

    source = File.read(file)
    stream = Psych.parse_stream(source, filename: file)
    raise Error, "#{file}: expected exactly one YAML document" unless stream.children.size == 1
    check_keys(stream, file)
    data = YAML.safe_load(source, filename: file, aliases: false)
    schema = JSON.parse(File.read(schema_file))
    unless JSONSchemer.valid_schema?(schema)
      raise Error, "#{schema_file}: invalid JSON Schema"
    end
    errors = JSONSchemer.schema(schema).validate(data).map do |error|
      "#{file}#{error.fetch('data_pointer')}: #{error.fetch('error')}"
    end
    raise Error, errors.join("\n") unless errors.empty?
  rescue Psych::Exception, JSON::ParserError => e
    raise Error, "#{file}: #{e.message}"
  end

  def self.validate!(root)
    files = Dir[File.join(root, '_data', '**', '*.{yml,yaml}')].sort
    schemas = Dir[File.join(root, 'schemas', '*.schema.json')].sort
    errors = []
    schemas.each do |schema|
      name = File.basename(schema, '.schema.json')
      unless files.any? { |file| File.basename(file, File.extname(file)) == name }
        errors << "_data/#{name}.yml: required data file is missing"
      end
    end
    files.each do |file|
      name = File.basename(file, File.extname(file))
      schema = File.join(root, 'schemas', "#{name}.schema.json")
      begin
        validate_file(file, schema)
      rescue Error => e
        errors << e.message
      end
    end
    raise Error, errors.join("\n") unless errors.empty?
    files.size
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    count = DataValidation.validate!(File.expand_path('..', __dir__))
    puts "Validated #{count} YAML data files."
  rescue DataValidation::Error => e
    warn e.message
    exit 1
  end
end
