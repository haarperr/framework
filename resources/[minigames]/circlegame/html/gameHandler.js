(function($) {
    $.fn.rotationDegrees = function() {
        var matrix = this.css("-webkit-transform") ||
            this.css("-moz-transform") ||
            this.css("-ms-transform") ||
            this.css("-o-transform") ||
            this.css("transform");
        if (typeof matrix === 'string' && matrix !== 'none') {
            var values = matrix.split('(')[1].split(')')[0].split(',');
            var a = values[0];
            var b = values[1];
            var angle = Math.round(Math.atan2(b, a) * (180 / Math.PI));
        } else {
            var angle = 0;
        }
        return angle;
    };
}(jQuery));
jQuery.fn.rotate = function(degrees) {
    $(this).css({
        '-webkit-transform': 'rotate(' + degrees + 'deg)',
        '-moz-transform': 'rotate(' + degrees + 'deg)',
        '-ms-transform': 'rotate(' + degrees + 'deg)',
        'transform': 'rotate(' + degrees + 'deg)'
    });
    return $(this);
};

function init($param) {
    var angle = Math.floor((Math.random() * 720) - 360);
    $("#circle2").rotate(angle);
    $("#container > p").html($param);
    if ($param != 1)
        $("#container > p").append("<br><h4>locks left</h4>");
    else
        $("#container > p").append("<br><h4>locks left</h4>");
}

function openGame(data) {
    digits = data.difficulty || 5;
    $("body").show();
    init(digits);
    angle = $("#circle2").rotationDegrees();
    $("#circle").rotate(2440);
}

function closeGame() {
    $("body").hide();
}

$(document).ready(function() {
    var counter = 0;
    $('#circle').click(function() {
        var unghi = $(this).rotationDegrees();
        if (unghi > angle - 25 && unghi < angle + 25) {
            digits--;

            if (!digits) {
                closeGame()
                $.post('http://circlegame/closeGame', JSON.stringify({
                    won: true,
                }));
            } else init(digits);
            angle = $("#circle2").rotationDegrees();
        } else {
            closeGame();
            $.post('http://circlegame/closeGame', JSON.stringify({
                won: false,
            }));
        }
        counter++;
        if (counter % 2) {
            $(this).rotate(-2880);
        } else $(this).rotate(2160);
    });
});

window.addEventListener('message', (event) => {
    if (event.data.type === "open") {
        openGame(event.data.payload);
    }
});