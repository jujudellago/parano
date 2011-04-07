// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.noConflict();
function randOrd(){
	return (Math.round(Math.random())-0.5); 
}

jQuery(document).ready(function(){
	//alert("dom loaded - jquery :) ");
	imagesArray=[
		{image : '/photos/backgrounds/parano-bg-1000.jpg', title : '', url : '/photos/backgrounds/parano-bg-1000.jpg'},
		{image : '/photos/backgrounds/parano-bg-1001.jpg', title : '', url : '/photos/backgrounds/parano-bg-1001.jpg'},
		{image : '/photos/backgrounds/parano-bg-1002.jpg', title : '', url : '/photos/backgrounds/parano-bg-1002.jpg'},
		{image : '/photos/backgrounds/parano-bg-1003.jpg', title : '', url : '/photos/backgrounds/parano-bg-1003.jpg'},
		{image : '/photos/backgrounds/parano-bg-1004.jpg', title : '', url : '/photos/backgrounds/parano-bg-1004.jpg'},
		{image : '/photos/backgrounds/parano-bg-1005.jpg', title : '', url : '/photos/backgrounds/parano-bg-1005.jpg'},
		{image : '/photos/backgrounds/parano-bg-1006.jpg', title : '', url : '/photos/backgrounds/parano-bg-1006.jpg'},
		{image : '/photos/backgrounds/parano-bg-1007.jpg', title : '', url : '/photos/backgrounds/parano-bg-1007.jpg'},
		{image : '/photos/backgrounds/parano-bg-1008.jpg', title : '', url : '/photos/backgrounds/parano-bg-1008.jpg'},
		{image : '/photos/backgrounds/parano-bg-1009.jpg', title : '', url : '/photos/backgrounds/parano-bg-1009.jpg'},
		{image : '/photos/backgrounds/parano-bg-1010.jpg', title : '', url : '/photos/backgrounds/parano-bg-1010.jpg'},
		{image : '/photos/backgrounds/parano-bg-1011.jpg', title : '', url : '/photos/backgrounds/parano-bg-1011.jpg'},
		{image : '/photos/backgrounds/parano-bg-1012.jpg', title : '', url : '/photos/backgrounds/parano-bg-1012.jpg'},
		{image : '/photos/backgrounds/parano-bg-1013.jpg', title : '', url : '/photos/backgrounds/parano-bg-1013.jpg'},
		{image : '/photos/backgrounds/parano-bg-1014.jpg', title : '', url : '/photos/backgrounds/parano-bg-1014.jpg'},
		{image : '/photos/backgrounds/parano-bg-1015.jpg', title : '', url : '/photos/backgrounds/parano-bg-1015.jpg'},
		{image : '/photos/backgrounds/parano-bg-1016.jpg', title : '', url : '/photos/backgrounds/parano-bg-1016.jpg'},
		{image : '/photos/backgrounds/parano-bg-1017.jpg', title : '', url : '/photos/backgrounds/parano-bg-1017.jpg'},
		{image : '/photos/backgrounds/parano-bg-1018.jpg', title : '', url : '/photos/backgrounds/parano-bg-1018.jpg'},
		{image : '/photos/backgrounds/parano-bg-1019.jpg', title : '', url : '/photos/backgrounds/parano-bg-1019.jpg'}
	];
	
	imagesArray.sort( randOrd );
	
	// backgrounds
	jQuery.fn.supersized.options = {  
		startwidth: 840,  
		startheight: 680,
		vertical_center: 1,
		slideshow: 1,
		navigation: 0,
		thumbnail_navigation: 1,
		transition: 1, //0-None, 1-Fade, 2-slide top, 3-slide right, 4-slide bottom, 5-slide left
		pause_hover: 0,
		slide_counter: 0,
		slide_captions: 0,
		slide_interval: 6000,
		slides : imagesArray
	};
    jQuery('#supersized').supersized();
});

