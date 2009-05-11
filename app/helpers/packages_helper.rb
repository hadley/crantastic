module PackagesHelper
  def select_rating(enabled=true)
    output = []

    1.upto(5) do |i|
      opts = {:type => "radio", :class => "starselect", :value => i.to_s, :name => "rating"}
      opts.merge!({:disabled => "disabled"}) if enabled != true
      opts.merge!({:checked => "checked"}) if i == @package.average_rating
      output << content_tag(:input, nil, opts)
    end
    output.join
  end
end
