import { Component } from "@angular/core";
import { Repository } from "../models/repository";
import { Product } from "../models/product.model";
import { Cart } from '../models/cart.model';
@Component({
selector: "store-product-list",
templateUrl: "productList.component.html"
})
export class ProductListComponent {
constructor(private repo: Repository,private cart: Cart) { }
get products(): Product[] {
    return this.repo.products;
}
addToCart(product: Product) {
    this.cart.addProduct(product);
    }
}