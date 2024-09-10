import { IUserInterface } from "../database/interface/user_interface";
import { OrderModel } from "../database/models/order_model";
import ProductModel from "../database/models/product_model";
import UserModel from "../database/models/user_model";

export const addToCartRepo = async (productId: String, userId: string) => {
  try {
    const product = await ProductModel.findById(productId);
    if (!product) {
      throw new Error("Product not found");
    }

    let user = await UserModel.findById(userId);
    if (!user) {
      throw new Error("User not found");
    }
    user.cart = user.cart || [];
    const existingCartItem = user?.cart.find(
      (item) => item.product.id.toString() === product.id.toString()
    );

    if (existingCartItem) {
      existingCartItem.quantity += 1;
    } else {
      user.cart.push({ product, quantity: 1 });
    }

    await user.save();
    return user;
  } catch (error) {
    console.log(error);
    throw error;
  }
};
export const removeFromCartRepo = async (productId: String, userId: string) => {
  try {
    const product = await ProductModel.findById(productId);
    if (!product) {
      throw new Error("Product not found");
    }

    let user = await UserModel.findById(userId);
    if (!user) {
      throw new Error("User not found");
    }
    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product.id.toString() === product.id.toString()) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        }
        user.cart[i].quantity -= 1;
      }
    }
    await user.save();
    return user;
  } catch (error) {
    console.log(error);
    throw error;
  }
};
export const fetchUserDataRepo = async (
  userId: string
): Promise<IUserInterface | null> => {
  try {
    const user = await UserModel.findById(userId);
    if (user) {
      return user;
    } else {
      return null;
    }
  } catch (error) {
    console.log(error);
    throw error;
  }
};

export const saveUserAddressRepo = async (address: String, userId: string) => {
  try {
    const user = await UserModel.findById(userId);
    if (user) {
      user.updateOne({ address: address });
      user.save();
    }
    return user;
  } catch (error) {
    throw error;
  }
};
export const placeOrderRepo = async (
  address: String,
  totalPrice: Number,
  cart: any,
  userId: string
) => {
  try {
    let products = [];
    for (let i = 0; i < cart.length; i++) {
      let product = await ProductModel.findById(cart[i].product._id);
      if (!product) {
        throw new Error("Product not found");
      }
      if (product?.quantity >= cart[i].quantity) {
        products.push({ product, quantity: cart[i].quantity });
        await product.save();
      } else {
        throw new Error("Stock Unavailable");
      }
    }

    let user = await UserModel.findById(userId);
    if (!user) {
      throw new Error("Product not found");
    }
    user.cart = [];
    user = await user.save();
    let order = new OrderModel({
      products,
      totalPrice,
      address,
      userId,
      orderAt: new Date().getTime(),
    });

    order = await order.save();
    return order;
  } catch (error) {
    console.log(error);
    throw error;
  }
};

export const getAllOrdersRepo=async(userId:string)=>{
  try {
    const userOrder=await OrderModel.find({userId:userId});
    if(userOrder){
      return userOrder
    }
    else{
      return 'NO ORDER'
    }
  } catch (error) {
    console.log(error);
    throw error;
    
  }
}