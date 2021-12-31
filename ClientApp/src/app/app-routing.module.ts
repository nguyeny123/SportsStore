import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
// import { ProductTableComponent } from "./structure/productTable.component"
// import { ProductDetailComponent } from "./structure/productDetail.component";
import { ProductSelectionComponent } from "./store/productSelection.component";
import { CartDetailComponent } from "./store/cartDetail.component";

import { CheckoutDetailsComponent }
from "./store/checkout/checkoutDetails.component";
import { CheckoutPaymentComponent }
from "./store/checkout/checkoutPayment.component";
import { CheckoutSummaryComponent }
from "./store/checkout/checkoutSummary.component";
import { OrderConfirmationComponent }
from "./store/checkout/orderConfirmation.component";

const routes: Routes = [
  {
    path: "admin",
    loadChildren: () =>
    import("./admin/admin.module").then(module => module.AdminModule),
  },
  { path: "checkout/step1", component: CheckoutDetailsComponent },
  { path: "checkout/step2", component: CheckoutPaymentComponent },
  { path: "checkout/step3", component: CheckoutSummaryComponent },
  { path: "checkout/confirmation", component: OrderConfirmationComponent },
  { path: "checkout", redirectTo: "/checkout/step1", pathMatch: "full" },
  
    { path: "cart", component: CartDetailComponent },
    // { path: "table", component: ProductTableComponent },
    // { path: "detail", component: ProductDetailComponent },
    // { path: "detail/:id", component: ProductDetailComponent },    
    // { path: "", component: ProductTableComponent }
    { path: "store/:category", component: ProductSelectionComponent },
    { path: "store", component: ProductSelectionComponent },
    { path: "", redirectTo: "/store", pathMatch: "full" }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
