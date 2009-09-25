# Borrowed from mislav's tip over at StackOverflow:
# http://stackoverflow.com/questions/64827
module AuthHelper
  protected

  def login_as(model, id_or_attributes = {})
    attributes = id_or_attributes.is_a?(Fixnum) ? {:id => id} : id_or_attributes
    @current_user = stub_model(model, attributes.update(:valid? => true))
    target = controller rescue template
    target.instance_variable_set '@current_user', @current_user

    if block_given?
      yield
      target.instance_variable_set '@current_user', nil
    end
    return @current_user
  end

  def login_as_user(id_or_attributes = {}, &block)
    login_as(User, id_or_attributes, &block)
  end
end
