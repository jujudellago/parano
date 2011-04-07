/*
Supersized - Fullscreen Slideshow jQuery Plugin
Version 3.0
By Sam Dunn (www.buildinternet.com // www.onemightyroar.com)
Version: supersized.3.0.js
Website: www.buildinternet.com/project/supersized
*/

(function(jQuery){

	//Resize image on ready or resize
	jQuery.fn.supersized = function() {
		
		
		jQuery.inAnimation = false;
		jQuery.paused = false;
		
		var options = jQuery.extend(jQuery.fn.supersized.defaults, jQuery.fn.supersized.options);
		jQuery.currentSlide = options.start_slide - 1;
		
		/******Set up initial images -- Add class doesnt work*****/
		//Set previous image
		var imageLink = (options.slides[options.slides.length - 1].url) ? "href='" + options.slides[options.slides.length - 1].url + "'" : "";
		jQuery("<img/>").attr("src", options.slides[options.slides.length - 1].image).appendTo("#supersized").wrap("<a " + imageLink + "></a>");//Doesnt account for start slide
		
		//Set current image
		imageLink = (options.slides[jQuery.currentSlide].url) ? "href='" + options.slides[jQuery.currentSlide].url + "'" : "";
		jQuery("<img/>").attr("src", options.slides[jQuery.currentSlide].image).appendTo("#supersized").wrap("<a class=\"activeslide\" " + imageLink + "></a>");
		
		//Set next image
		imageLink = (options.slides[jQuery.currentSlide + 1].url) ? "href='" + options.slides[jQuery.currentSlide + 1].url + "'" : "";
		jQuery("<img/>").attr("src", options.slides[jQuery.currentSlide + 1].image).appendTo("#supersized").wrap("<a " + imageLink + "></a>");
		
		jQuery(window).bind("load", function(){
			
			jQuery('#loading').hide();
			jQuery('#supersized').fadeIn('fast');
			
			jQuery('#controls-wrapper').show();
			
			if (options.thumbnail_navigation == 1){
			
				/*****Set up thumbnails****/
				//Load previous thumbnail
				jQuery.currentSlide - 1 < 0  ? prevThumb = options.slides.length - 1 : prevThumb = jQuery.currentSlide - 1;
				jQuery('#prevthumb').show().html(jQuery("<img/>").attr("src", options.slides[prevThumb].image));
				
				//Load next thumbnail
				jQuery.currentSlide == options.slides.length - 1 ? nextThumb = 0 : nextThumb = jQuery.currentSlide + 1;
				jQuery('#nextthumb').show().html(jQuery("<img/>").attr("src", options.slides[nextThumb].image));
		
			}
			
			jQuery('#supersized').resizenow();
			
			if (options.slide_captions == 1) jQuery('#slidecaption').html(options.slides[jQuery.currentSlide].title);//*********Pull caption from array
			if (options.navigation == 0) jQuery('#navigation').hide();
			if (options.thumbnail_navigation == 0){ jQuery('#nextthumb').hide(); jQuery('#prevthumb').hide(); }
			
			//Slideshow
			if (options.slideshow == 1){
				if (options.slide_counter == 1){ //Initiate slide counter if active
					jQuery('#slidecounter .slidenumber').html(options.start_slide);
	    			jQuery('#slidecounter .totalslides').html(options.slides.length); //*******Pull total from length of array
	    		}
				slideshow_interval = setInterval(nextslide, options.slide_interval);
				
				if (options.thumbnail_navigation == 1){
					//Thumbnail Navigation
					jQuery('#nextthumb').click(function() {
				    	if(jQuery.inAnimation) return false;
					    clearInterval(slideshow_interval);
					    nextslide();
					    if(!(jQuery.paused)) slideshow_interval = setInterval(nextslide, options.slide_interval);
					    return false;
				    });
				    jQuery('#prevthumb').click(function() {
				    	if(jQuery.inAnimation) return false;
				        clearInterval(slideshow_interval);
				        prevslide();
				       	if(!(jQuery.paused)) slideshow_interval = setInterval(nextslide, options.slide_interval);
				        return false;
				    });
					}
				
				if (options.navigation == 1){ //Skip if no navigation
					jQuery('#navigation a').click(function(){  
   						jQuery(this).blur();  
   						return false;  
   					});
   					 	
					//Slide Navigation
				    jQuery('#nextslide').click(function() {
				    	if(jQuery.inAnimation) return false;
					    clearInterval(slideshow_interval);
					    nextslide();
					    if(!(jQuery.paused)) slideshow_interval = setInterval(nextslide, options.slide_interval);
					    return false;
				    });
				    jQuery('#prevslide').click(function() {
				    	if(jQuery.inAnimation) return false;
				        clearInterval(slideshow_interval);
				        prevslide();
				        if(!(jQuery.paused)) slideshow_interval = setInterval(nextslide, options.slide_interval);
				        return false;
				    });
				    jQuery('#nextslide').mousedown(function() {
					   	jQuery(this).attr("src", "images/forward.png");
					});
					jQuery('#nextslide').mouseup(function() {
					    jQuery(this).attr("src", "images/forward_dull.png");
					});
					jQuery('#nextslide').mouseout(function() {
					    jQuery(this).attr("src", "images/forward_dull.png");
					});
					
					jQuery('#prevslide').mousedown(function() {
					    jQuery(this).attr("src", "images/back.png");
					});
					jQuery('#prevslide').mouseup(function() {
					    jQuery(this).attr("src", "images/back_dull.png");
					});
					jQuery('#prevslide').mouseout(function() {
					    jQuery(this).attr("src", "images/back_dull.png");
					});
					
				    //Play/Pause Button
				    jQuery('#pauseplay').click(function() {
				    	if(jQuery.inAnimation) return false;
				    	var src = (jQuery(this).attr("src") === "images/play.png") ? "images/pause.png" : "images/play.png";
      					if (src == "images/pause.png"){
      						jQuery(this).attr("src", "images/play.png");
      						jQuery.paused = false;
					        slideshow_interval = setInterval(nextslide, options.slide_interval);  
				        }else{
				        	jQuery(this).attr("src", "images/pause.png");
				        	clearInterval(slideshow_interval);
				        	jQuery.paused = true;
				        }
      					jQuery(this).attr("src", src);
					    return false;
				    });
				    jQuery('#pauseplay').mouseover(function() {
				    	var imagecheck = (jQuery(this).attr("src") === "images/play_dull.png");
				    	if (imagecheck){
      						jQuery(this).attr("src", "images/play.png"); 
				        }else{
				        	jQuery(this).attr("src", "images/pause.png");
				        }
				    });
				    
				    jQuery('#pauseplay').mouseout(function() {
				    	var imagecheck = (jQuery(this).attr("src") === "images/play.png");
				    	if (imagecheck){
      						jQuery(this).attr("src", "images/play_dull.png"); 
				        }else{
				        	jQuery(this).attr("src", "images/pause_dull.png");
				        }
				        return false;
				    });
				}
			}
		});
				
		jQuery(document).ready(function() {
			jQuery('#supersized').resizenow(); 
		});
		
		//Pause when hover on image
		jQuery('#supersized').hover(function() {
	   		if (options.slideshow == 1 && options.pause_hover == 1){
	   			if(!(jQuery.paused) && options.navigation == 1){
	   				jQuery('#pauseplay').attr("src", "images/pause.png"); 
	   				clearInterval(slideshow_interval);
	   			}
	   		}
	   		if(jQuery.inAnimation) return false; //*******Pull title from array
	   	}, function() {
			if (options.slideshow == 1 && options.pause_hover == 1){
				if(!(jQuery.paused) && options.navigation == 1){
					jQuery('#pauseplay').attr("src", "images/pause_dull.png");
					slideshow_interval = setInterval(nextslide, options.slide_interval);
				} 
			}
				//*******Pull title from array
	   	});
		
		jQuery(window).bind("resize", function(){
    		jQuery('#supersized').resizenow(); 
		});
		
		jQuery('#supersized').hide();
		jQuery('#controls-wrapper').hide();
	};
	
	//Adjust image size
	jQuery.fn.resizenow = function() {
		var t = jQuery(this);
		var options = jQuery.extend(jQuery.fn.supersized.defaults, jQuery.fn.supersized.options);
	  	return t.each(function() {
	  		
			//Define image ratio
			var ratio = options.startheight/options.startwidth;
			
			//Gather browser and current image size
			var imagewidth = t.width();
			var imageheight = t.height();
			var browserwidth = jQuery(window).width();
			var browserheight = jQuery(window).height();
			var offset;

			//Resize image to proper ratio
			if ((browserheight/browserwidth) > ratio){
			    t.height(browserheight);
			    t.width(browserheight / ratio);
			    t.children().height(browserheight);
			    t.children().width(browserheight / ratio);
			} else {
			    t.width(browserwidth);
			    t.height(browserwidth * ratio);
			    t.children().width(browserwidth);
			    t.children().height(browserwidth * ratio);
			}
			if (options.vertical_center == 1){
				t.children().css('left', (browserwidth - t.width())/2);
				t.children().css('top', (browserheight - t.height())/2);
			}
			return false;
		});
	};
	
		//Slideshow Next Slide
	function nextslide() {
		if(jQuery.inAnimation) return false;
		else jQuery.inAnimation = true;
	    var options = jQuery.extend(jQuery.fn.supersized.defaults, jQuery.fn.supersized.options);
		
		var currentslide = jQuery('#supersized .activeslide');
	    currentslide.removeClass('activeslide');
		
	    if ( currentslide.length == 0 ) currentslide = jQuery('#supersized a:last'); //*******Check if end of array?
			
	    var nextslide =  currentslide.next().length ? currentslide.next() : jQuery('#supersized a:first'); //*******Array
	    var prevslide =  nextslide.prev().length ? nextslide.prev() : jQuery('#supersized a:last'); //*******Array
		
		jQuery('.prevslide').removeClass('prevslide');
		prevslide.addClass('prevslide');
		
		//Get the slide number of new slide
		jQuery.currentSlide + 1 == options.slides.length ? jQuery.currentSlide = 0 : jQuery.currentSlide++;
		
		/**** Image Loading ****/
		//Load next image
		loadSlide=false;
		jQuery.currentSlide == options.slides.length - 1 ? loadSlide = 0 : loadSlide = jQuery.currentSlide + 1;
		imageLink = (options.slides[loadSlide].url) ? "href='" + options.slides[loadSlide].url + "'" : "";
		jQuery("<img/>").attr("src", options.slides[loadSlide].image).appendTo("#supersized").wrap("<a " + imageLink + "></a>");
		
		if (options.thumbnail_navigation == 1){
		//Load previous thumbnail
		jQuery.currentSlide - 1 < 0  ? prevThumb = options.slides.length - 1 : prevThumb = jQuery.currentSlide - 1;
		jQuery('#prevthumb').html(jQuery("<img/>").attr("src", options.slides[prevThumb].image));
		
		//Load next thumbnail
		nextThumb = loadSlide;
		jQuery('#nextthumb').html(jQuery("<img/>").attr("src", options.slides[nextThumb].image));
		}
		
		currentslide.prev().remove(); //Remove Old Image
		
		/**** End Image Loading ****/
		
		//Display slide counter
		if (options.slide_counter == 1){
		    jQuery('#slidecounter .slidenumber').html(jQuery.currentSlide + 1);//**display current slide after checking if last
		}
		
		//Captions
	    if (options.slide_captions == 1){
	    	(options.slides[jQuery.currentSlide].title) ? jQuery('#slidecaption').html(options.slides[jQuery.currentSlide].title) : jQuery('#slidecaption').html('') ; //*******Grab next slide's title from array
	    }
		
	    nextslide.hide().addClass('activeslide')
	    	if (options.transition == 0){
	    		nextslide.show(); jQuery.inAnimation = false;
	    	}
	    	if (options.transition == 1){
	    		nextslide.fadeIn(750, function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 2){
	    		nextslide.show("slide", { direction: "up" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 3){
	    		nextslide.show("slide", { direction: "right" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 4){
	    		nextslide.show("slide", { direction: "down" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 5){
	    		nextslide.show("slide", { direction: "left" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    jQuery('#supersized').resizenow();
	}
	
	//Slideshow Previous Slide
	function prevslide() {
		if(jQuery.inAnimation) return false;
		else jQuery.inAnimation = true;
		var options = jQuery.extend(jQuery.fn.supersized.defaults, jQuery.fn.supersized.options);
	    
	    var currentslide = jQuery('#supersized .activeslide');
	    currentslide.removeClass('activeslide');
		
	    if ( currentslide.length == 0 ) currentslide = jQuery('#supersized a:first');
			
	    var nextslide =  currentslide.prev().length ? currentslide.prev() : jQuery('#supersized a:last'); //****** If equal to total length of array
	    var prevslide =  nextslide.next().length ? nextslide.next() : jQuery('#supersized a:first');
				
		//Get current slide number
		jQuery.currentSlide == 0 ?  jQuery.currentSlide = options.slides.length - 1 : jQuery.currentSlide-- ;
		
		/**** Image Loading ****/
		//Load next image
		loadSlide=false;
		jQuery.currentSlide - 1 < 0  ? loadSlide = options.slides.length - 1 : loadSlide = jQuery.currentSlide - 1;
		imageLink = (options.slides[loadSlide].url) ? "href='" + options.slides[loadSlide].url + "'" : "";
		jQuery("<img/>").attr("src", options.slides[loadSlide].image).prependTo("#supersized").wrap("<a " + imageLink + "></a>");
		
		if (options.thumbnail_navigation == 1){
		//Load previous thumbnail
		prevThumb = loadSlide;
		jQuery('#prevthumb').html(jQuery("<img/>").attr("src", options.slides[prevThumb].image));
		
		//Load next thumbnail
		jQuery.currentSlide == options.slides.length - 1 ? nextThumb = 0 : nextThumb = jQuery.currentSlide + 1;
		jQuery('#nextthumb').html(jQuery("<img/>").attr("src", options.slides[nextThumb].image));
		}
		
		currentslide.next().remove(); //Remove Old Image
		
		/**** End Image Loading ****/
		
		//Display slide counter
		if (options.slide_counter == 1){
		    jQuery('#slidecounter .slidenumber').html(jQuery.currentSlide + 1);
		}
		
		jQuery('.prevslide').removeClass('prevslide');
		prevslide.addClass('prevslide');
		
		//Captions
	    if (options.slide_captions == 1){
	    	(options.slides[jQuery.currentSlide].title) ? jQuery('#slidecaption').html(options.slides[jQuery.currentSlide].title) : jQuery('#slidecaption').html('') ; //*******Grab next slide's title from array
	    }
		
	    nextslide.hide().addClass('activeslide')
	    	if (options.transition == 0){
	    		nextslide.show(); jQuery.inAnimation = false;
	    	}
	    	if (options.transition == 1){
	    		nextslide.fadeIn(750, function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 2){
	    		nextslide.show("slide", { direction: "down" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 3){
	    		nextslide.show("slide", { direction: "left" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 4){
	    		nextslide.show("slide", { direction: "up" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    	if (options.transition == 5){
	    		nextslide.show("slide", { direction: "right" }, 'slow', function(){jQuery.inAnimation = false;});
	    	}
	    	
	    	jQuery('#supersized').resizenow();//Fix for resize mid-transition
	}
	
	jQuery.fn.supersized.defaults = { 
			startwidth: 4,  
			startheight: 3,
			vertical_center: 1,
			slideshow: 1,
			navigation:1,
			thumbnail_navigation: 0,
			transition: 1, //0-None, 1-Fade, 2-slide top, 3-slide right, 4-slide bottom, 5-slide left
			pause_hover: 0,
			slide_counter: 1,
			slide_captions: 1,
			slide_interval: 5000,
			start_slide: 1
	};
	
})(jQuery);

