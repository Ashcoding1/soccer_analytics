export {};

async function get_country_seasons(ev: Event) {
    console.log(`Got input for ${ev.currentTarget?.id}`);
    // send json to the server with country name, and
    // server gives me back a list of seasons
    let id = `${ev.currentTarget?.id}`.toLowerCase();
    let response = await fetch(id, {
        headers: {
            "Content-Type": "application/json",
        },
    });
    console.log(response);
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
