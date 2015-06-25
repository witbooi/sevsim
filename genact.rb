#!/usr/bin/env ruby

id = ARGV[0].sub ':', ''
title = ARGV.drop(1).join ' '

tpl = <<HAML
%span.preview
  %a #{title}

.story-content.modal.fade
  .modal-dialog.modal-lg
    .modal-content
      .modal-header
        %h4.modal-title #{title}
      .modal-body
        %img{ src: "templates/actions/img/#{id}.png" }
HAML

filename = "./templates/actions/#{id}.html.haml"
File.open(filename, 'w') { |f| f.write tpl }

puts "Generated '#{id}: #{title}' to #{filename}"
