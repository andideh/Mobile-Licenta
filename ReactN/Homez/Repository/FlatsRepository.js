import {Flats, Flat} from "../Models/Flat";

export class FlatsRepository {
    foodItems: Array<Flat>;
    static instance: FlatsRepository;

    constructor() {
        this.flats = [];
        this.flats.push(new Flat(1, "Republicii", 200000, 1));
        this.flats.push(new Flat(2, "Andrei Mureasanu", 800000, 2));
        this.flats.push(new Flat(3, "Horea", 450000, 1));
        
    }

    static get repository(): FlatsRepository {
        return FoodItemRepository.instance;
    }

    add(foodItem: Flat): void {
        this.flats.push(foodItem);
    }

    find(id: number): Flat {
        let flat: Flat;
        let i: number;

        for (i = 0; i < this.flats.length; i++) {
            if (id === this.flats[i].id) {
                flat = this.flats[i];
                break;
            }
        }

        return flat;
    }

    update(flat: Flat): void {
        let i: number;

        for (i = 0; i < this.flats.length; i++) {
            if (this.flats[i].id === flat.id) {
                this.flats[i].address = flat.address;
                this.flats[i].price = flat.price;
                break;
            }
        }
    }

    getAll(): Array<Flat> {
        return this.flats;
    }
}

FlatsRepository.instance = new FlatsRepository();