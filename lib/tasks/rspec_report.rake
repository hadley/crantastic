namespace :spec do
  desc "Print HTML documentation of spec"
  task :html_doc do
    `spec spec -f h:spec/spec_report.html`
  end
end
