const customRadios = [];
let isPlaying = false;
let index = -1;
let volume = GetProfileSetting(306) / 10;
let previousVolume = volume;

SetRadioStationDisabled("RADIO_01_CLASS_ROCK", false);
SetRadioStationDisabled("RADIO_02_POP", false);
SetRadioStationDisabled("RADIO_03_HIPHOP_NEW", false);
SetRadioStationDisabled("RADIO_04_PUNK", false);
SetRadioStationDisabled("RADIO_05_TALK_01", false);
SetRadioStationDisabled("RADIO_06_COUNTRY", false);
SetRadioStationDisabled("RADIO_07_DANCE_01", false);
SetRadioStationDisabled("RADIO_08_MEXICAN", false);
SetRadioStationDisabled("RADIO_09_HIPHOP_OLD", false);
SetRadioStationDisabled("RADIO_12_REGGAE", false);
SetRadioStationDisabled("RADIO_13_JAZZ", false);
SetRadioStationDisabled("RADIO_14_DANCE_02", false);
SetRadioStationDisabled("RADIO_15_MOTOWN", false);
SetRadioStationDisabled("RADIO_20_THELAB", false);
SetRadioStationDisabled("RADIO_16_SILVERLAKE", false);
SetRadioStationDisabled("RADIO_17_FUNK", false);
SetRadioStationDisabled("RADIO_18_90S_ROCK", false);
SetRadioStationDisabled("RADIO_19_USER", false);
SetRadioStationDisabled("RADIO_11_TALK_02", false);

for (let i = 0, length = GetNumResourceMetadata("vradio", "supersede_radio"); i < length; i++) {
    const vradio = GetResourceMetadata("vradio", "supersede_radio", i);

    if (!availableRadios.includes(vradio)) {
        console.error(`vradio: ${vradio} is an invalid vradio.`);
        continue;
    }

    try {
        //setTimeout(SRGet,10000);
        const data = JSON.parse(GetResourceMetadata("vradio", "supersede_radio_extra", i));
        //if (data.name == "Simulator Radio") {
        //    customRadios.push({
        //        "isPlaying": false,
        //        "name": vradio,
        //        "data": SRdata[5] + " is playing " + SRdata[2] + " by " + SRdata[3] + " to " + SRdata[1] + " listeners!"
        //    });
        //} else {
        if (data !== null) {

            customRadios.push({
                "isPlaying": false,
                "name": vradio,
                "data": data
            });
            if (data.name) {
                AddTextEntry(vradio, data.name);
            }
        } else {
           console.error(`vradio: Missing data for ${vradio}.`);
        }
        //}
    } catch (e) {
        console.error(e);
    }
}

RegisterNuiCallbackType("vradio:ready");
on("__cfx_nui:vradio:ready", (data, cb) => {
    SendNuiMessage(JSON.stringify({ "type": "create", "radios": customRadios, "volume": volume }));
    previousVolume = -1;
});
SendNuiMessage(JSON.stringify({ "type": "create", "radios": customRadios, "volume": volume }));

const PlayCustomRadio = (vradio) => {
    isPlaying = true;
    index = customRadios.indexOf(vradio);
    ToggleCustomRadioBehavior();
    SendNuiMessage(JSON.stringify({ "type": "play", "vradio": vradio.name }));
};

const StopCustomRadios = () => {
    isPlaying = false;
    ToggleCustomRadioBehavior();
    SendNuiMessage(JSON.stringify({ "type": "stop" }));
};

const ToggleCustomRadioBehavior = () => {
    SetFrontendRadioActive(!isPlaying);

    if (isPlaying) {
        StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE");
    } else {
        StopAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE");
    }
};

setTick(() => {
    if (IsPlayerVehicleRadioEnabled()) {
        let playerRadioStationName = GetPlayerRadioStationName();

        let customRadio = customRadios.find((vradio) => {
            return vradio.name === playerRadioStationName;
        });

        if (!isPlaying && customRadio) {
            PlayCustomRadio(customRadio);
        } else if (isPlaying && customRadio && customRadios.indexOf(customRadio) !== index) {
            StopCustomRadios();
            PlayCustomRadio(customRadio);
        } else if (isPlaying && !customRadio) {
            StopCustomRadios();
        }
    } else if (isPlaying) {
        StopCustomRadios();
    }

    volume = GetProfileSetting(306) / 10;
    if (previousVolume !== volume) {
        SendNuiMessage(JSON.stringify({ "type": "volume", "volume": volume }));
        previousVolume = volume;
    }
});