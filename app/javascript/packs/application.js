// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
ActiveStorage.start()

$(document).on('change', '.skill-select', function (){
  $.ajax({
    method: "get",
    url: "/update_experience",
    data: {
      name: $(".skill-select option:selected").val()
    }
  })
});

$(document).on('click', '.edit_skill_button', function (e){
  e.preventDefault();

  var id = $(this).attr('data_id');

  var skillData = {
    name: $('.skill_edit_name').val(),
    min: $('.skill_edit_min').val(),
    max: $('.skill_edit_max').val(),
    experience: $('.skill_edit_experience').val()
  }

  $.ajax({
    type: "PUT",
    url: "skills/" + id,
    data: {'skill': skillData},
  });
});
