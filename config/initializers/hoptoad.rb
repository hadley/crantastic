HoptoadNotifier.configure do |config|
  config.api_key = ENV['HOPTOAD_API_KEY']

  # Whitelist of errors that Hoptoad ignores
  config.ignore_by_filter do |exception_data|
    exception_data.error_message =~ "ActionController::UnknownHttpMethod: PROPFIND"
  end
end
