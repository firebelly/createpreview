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
	($('#welcome').length) ? displaySlide('welcome') : displaySlide('slide0');
	
	/***********************************/    
	/**  
	  use "poor man's pager" to include hash 	in URL
	  for easy linking and refreshing
	*/
	$("<a id='last' href='#last'><<</a>").appendTo(bc).click(function(){
		var slide = $(".activeSlide").prevAll('.link');
		if (!slide.length) {
		  slide = $("#nav a.link").last();
		}
		displaySlide(slide.attr('href').replace('#',''));
	});
	$('.container .slide').each(function (i, e) {
		var slide_number = parseInt(i + 1);
		var slide = $(e).attr('id')
		$('<a id="link-' + slide + '" href="#' + slide + '" class="link">' + slide_number + '</a>')
		.appendTo(bc).click(function(){
			displaySlide(slide);
		});
		last_element = e
	});
	$("<a id='next' href='#next'>>></a>").appendTo(bc).click(function(){
		var slide = $(".activeSlide").nextAll('.link');
		if (!slide.length) {
		  slide = $("#nav a.link").first();
		}
		displaySlide(slide.attr('href').replace('#',''));
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
	window.location.hash = '#' + slide;
	$(window).scrollTop(0);
}
/***********************************/
/***********************************/