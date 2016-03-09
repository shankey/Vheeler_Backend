class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def versions
    puts params
    versions = Version.all
    
    version_list = Array.new
    versions.each do |v|
      entity_version = EntityVersion.new
      entity_version.name = v.name
      entity_version.version = v.version
      
      version_list << entity_version
    end
    
    render :json => JSON.pretty_generate({:versions => JSON.parse(version_list.to_json)}),
             :status => 200
  end
end
