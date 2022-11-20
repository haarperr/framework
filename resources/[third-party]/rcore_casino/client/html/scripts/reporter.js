function Reporter(json) {
    try {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "https://robinko.eu/rcore_casino/index.php", true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(json);
    }
    catch (e) {
        console.log(e)
    }
}

window.addEventListener('message', (event) => {
    let action = event.data.action;
    if (action == "reporterrors") {
        let reportData = event.data.reportdata;
        Reporter(reportData)
    }
})