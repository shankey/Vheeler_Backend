Rails.application.routes.draw do
  post '/coordinate' => 'coordinate#coordinate'
  post '/coordinate_batch' => 'coordinate#coordinate_batch'
  get '/coordinate_markers' => 'coordinate#coordinate_markers'
  
  get '/area' => 'area#area'
  
  get '/ads' => 'ads#ads'
  
  get '/versions' => 'application#versions'
  
  get '/get_campaign_details' => 'report#get_campaign_details'
  get '/get_polylines' => 'report#get_polylines'
  
end
