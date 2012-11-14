$(document).ready(function(){
  $('#cpForm').validate({
    rules: {
      images: { required: "input[name='images[]']", minlength: 1 },
      user: {
          required: { function(element){
                  return $("input[name=pass]").val().length > 0;
              }
          }
      },
      pass: {
          required: { function(element){
                  return $("input[name=user]").val().length > 0;
              }
          }
      }
    },
    messages: {
      images: 'Please select at least one option',
      user: 'If you set a user, a password must also be set.',
      pass: 'If you set a password, a user must be set.'
    },
    errorElement: "div",
    errorPlacement: function(error, element) {
      error.insertBefore(element).css('color', 'red');
    }
  });
});