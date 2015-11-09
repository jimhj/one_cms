carrierwave_config = CONFIG['carrierwave']

CarrierWave.configure do |config|
  config.asset_host = carrierwave_config['asset_host']
end
