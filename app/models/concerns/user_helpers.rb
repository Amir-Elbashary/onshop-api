module UserHelpers
  extend ActiveSupport::Concern

  def full_name
    first_name + ' ' + last_name
  end

  def full_name_parameterized
    if full_name !~ /\p{Arabic}/
      full_name.parameterize
    else
      full_name.gsub(/\s+/, "-").gsub( /[^a-zA-Z0-9أ-ي-]*/ , "" ) 
    end
  end
end
