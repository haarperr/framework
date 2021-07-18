Template = undefined;
ContactNodes = [];
Timeout = 2.152 * 14 * 1000; // Amount of rings rather than time.
PhoneNumber = undefined;
ContactName = undefined;
TimeoutHandle = undefined;
Ring = new Audio("../../sounds/ring.ogg");
Tone = new Audio("../../sounds/tone.ogg");

$(document).ready(function() {

});

window.addEventListener("message", function(event) {
    var data = event.data;
    var payload = data.payload;

    console.log("phone-call", JSON.stringify(payload));

    if (data.closed) {
        hangup();
    }

    if (payload == undefined) {
        return;
    }

    if (payload.hangup) {
        console.log("being asked to hang up")
            // hangup();
        closeApp(true, "phone-call");
        return;
    }

    if (payload.number != undefined) {
        PhoneNumber = payload.number;
        ContactName = payload.name;
        if (ContactName === "Unknown Number") {
            document.querySelector("#number").innerHTML = PhoneNumber ? formatPhoneNumber(PhoneNumber) : "Unknown Number";
        } else {
            document.querySelector("#number").innerHTML = ContactName
        }
    }

    if (payload.state != undefined) {
        var isIncoming = payload.state == "Incoming Call";
        var isCalling = payload.state == "Calling";
        var inCall = payload.state == "In Call";

        document.querySelector("#state").innerHTML = payload.state;
        document.querySelector("#answer-call").style.display = isIncoming ? "block" : "none";
        document.querySelector("#end-call").style.display = "block";

        // Incoming ring.
        if (isIncoming) {
            Ring.loop = true;
            Ring.currentTime = 0;
            Ring.volume = 0.2;
            Ring.load();
            Ring.play();
        }

        // Outgoing tone.
        if (isCalling) {
            Tone.loop = true;
            Tone.currentTime = 0;
            Tone.volume = 0.2;
            Tone.load();
            Tone.play();
        }

        console.log(isIncoming + " " + isCalling + " " + inCall);

        // Passive state.
        if (inCall) {
            Ring.pause();
            Tone.pause();
        }

        if (TimeoutHandle != undefined) {
            clearTimeout(TimeoutHandle);
        }

        if (isCalling || isIncoming) {
            TimeoutHandle = setTimeout(function() {
                if (isIncoming) {
                    Ring.pause();
                } else if (isCalling) {
                    Tone.pause();
                }

                closeApp(false, "phone-call");
            }, Timeout);
            console.log("timeout id " + TimeoutHandle);
        }
    }
});

$("#end-call").click(function() {
    hangup();
})

$("#answer-call").click(function() {
    answer();
})

function answer() {
    Ring.pause();
    Tone.pause();

    $.post("http://phone/answer", JSON.stringify({}));
}

function hangup() {
    Ring.pause();
    Tone.pause();

    $.post("http://phone/hangup", JSON.stringify({}));
}

function call(target) {
    $.post("http://phone/call", JSON.stringify({
        target: target,
    }));
}