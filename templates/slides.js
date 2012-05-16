$(document).ready(function() {
	(client_name.length == 0) ? alert("Client Name Required") : '';
	(image_array.length == 0) ? alert("Images Required") : '';
	/***********************************/
	/***********************************/
	$('#welcome h2 span').text(client_name);
	
	var bc = $('#nav');
	var last_element
	
	last_element = ($('#welcome').length) ? $('#welcome') : $('#placeholder')
	
	$.each(image_array, function(index, value){
		var slide = $('<img>');
		slide.attr('src', './images/' + value);
		var slide_holder = $('<div class="slide" id="slide' + index + '">');
		$(slide_holder).append(slide);
		$(last_element).after(slide_holder);
		last_element = slide_holder;
	});
	
	($('#welcome').length) ? $("#welcome").show() : $("#slide0").show();
	
	/***********************************/    
	/**  
	  use "poor man's pager" to include hash 	in URL
	  for easy linking and refreshing
	*/
	$('.container .slide').each(function (i, e) {
		var slide_number = parseInt(i + 1);
		var slide = $(e).attr('id')
		$('<a id="link-' + slide + '"href="#' + slide + '">' + slide_number + '</a>')
		.appendTo(bc).click(function(){
			displaySlide(slide);
		});
	});
});

if (location.hash) {
	displaySlide(location.hash);
}

function displaySlide(slide){
	$(".slide").hide();
	$("#" + slide).show();
	$(".activeSlide").removeClass("activeSlide");
	$("#link-" + slide).addClass("activeSlide");
	$(window).scrollTop(0);
}
/***********************************/
/***********************************/