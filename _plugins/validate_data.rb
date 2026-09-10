require_relative '../scripts/validate_data'

Jekyll::Hooks.register :site, :post_read do |site|
  begin
    DataValidation.validate!(site.source)
  rescue DataValidation::Error => e
    raise Jekyll::Errors::FatalException, "YAML data validation failed:\n#{e.message}"
  end
end
