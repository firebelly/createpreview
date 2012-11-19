$(document).ready(function(){
  $('#cpForm').validate({
    rules: {
      images: { required: "input[name='images[]']", minlength: 1 }
    },
    messages: {
      images: 'Please select at least one option',
    },
    errorElement: "div",
    errorPlacement: function(error, element) {
      error.insertBefore(element).css('color', 'red');
    }
  });
  $('<a href="#">Select All</a>').appendTo('#images-label').click(function() {
    $('.images input').attr('checked',true);
  });
});