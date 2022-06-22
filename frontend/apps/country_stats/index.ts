export { };

async function get_country_seasons(ev: Event) {
    console.log(`Got input for ${ev.currentTarget?.id}`);
    // send json to the server with country name, and
    // server gives me back a list of seasons
    let id = `${ev.currentTarget?.id}`.toLowerCase();
    const request = {
        headers: {
            "Content-Type": "application/json",
        },
    }
    let response = await fetch(id, request);

    console.log(response);

    let seasonJSON = await response.json();
    //let seasons = JSON.parse(seasonJSON);
    console.log(seasonJSON)
}

async function main() {
    let inputs = document.getElementsByTagName("input");
    console.log(inputs);
    for (let input of inputs) {
        input.addEventListener("input", get_country_seasons);
    }
}

main().catch((err) => {
    console.log(err);
});

