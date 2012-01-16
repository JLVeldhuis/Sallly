var speed = 2000;

function beat(heart) {
	var width = heart.width()
	var height = heart.height()
	heart.animate(
		{"width": width * 1.2,
		"height": height * 1.2,}).animate(
                {"width": width,
		"height": height,});
	setTimeout(beat, speed, heart);
}

$(function() {
var heart = $("#heart");
beat(heart);
});
