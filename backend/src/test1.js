let DataToUpdate = function (total_price, quantity) {
    let needed_index = 2;

    update = { "$inc": {} };
    update["$inc"]["total_price"] = 100;

    update["$inc"]["products." + needed_index] = {};
    update["$inc"]["products." + needed_index]["quantity"] = 2;

        let b = `products.$needed_index.quantity`;
        let a = {
            total_price: 100,
            b: 3,
        }
    return a;
}

//console.log(DataToUpdate(1000, 2));

function give(){
    let a = 3;
    return {
        ["biki." + a + "." + "quantity"]: 3,
    };
}
console.log(give());