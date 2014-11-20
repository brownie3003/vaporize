# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$("#fullPage").fullpage
		anchors: ['', 'eCigarettes', 'eLiquids', 'pricing']
		verticalCentered: true
		resize: false
		css3: true
		menu: "#menu"
		navigation: true

	$("#bgVid").get(0).play()
	
	console.log("hello")