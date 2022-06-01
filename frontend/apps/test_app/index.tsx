import { IDoNothing } from "./utils";

function sayHi(person: string): string {
    // let i: Number = "4";  // for checking tsc -noEmit type-checks
    return "Hello, " + person;
}

let user = "Jane User";

document.body.textContent = sayHi(user);
const nothing = new IDoNothing();

const link = (<a></a>)
console.log(link)