class LiveValidationsController < ApplicationController
  # Poll with /live_validations/uniqueness?model_class=User&column=username&value=theusername. Returns
  # either 'true' or 'false'.
  def uniqueness
    responder = LiveValidations.current_adapter.validation_responses[:uniqueness]
    render :text => responder.respond(params)
  end
end