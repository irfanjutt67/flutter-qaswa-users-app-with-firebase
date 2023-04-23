import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/product_controller.dart';
import '../../widgets_common/loading_indicator.dart';
import '../../widgets_common/our_button.dart';
import '../cart_screen/cart_screen.dart';
import '../chat_screen/chat_screen.dart';

class ItemsDetailsScreen extends StatefulWidget {
  final String? title;
  final dynamic data;
  const ItemsDetailsScreen({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  var controller = Get.put(ProductController());

  var lengths = 0;
  void cartItemslength() {
    firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: currentUser!.uid)
        .get()
        .then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          lengths = snap.docs.length;
        });
      } else {
        setState(() {
          lengths = 0;
        });
      }
    });
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    cartItemslength();
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              color: isdarkMode ? darkFontGrey : whiteColor,
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          title: widget.title!.text.white
              .fontFamily(bold)
              .color(isdarkMode ? darkFontGrey : whiteColor)
              .make(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: badges.Badge(
                badgeAnimation: const badges.BadgeAnimation.slide(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeContent: "$lengths".text.white.make(),
                child: Image.asset(icCart, width: 24.0).onTap(() {
                  Get.to(() => const CartScreens());
                }),
              ),
            ),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWishList(widget.data.id, context);
                    } else {
                      controller.addToWishList(widget.data.id, context);
                    }
                  },
                  icon: Icon(Icons.favorite_outlined,
                      color: controller.isFav.value ? redColor : fontGrey)),
            ),
          ],
        ),
        body: Stack(
          children: [
            Image(
              image: CachedNetworkImageProvider(
                  widget.data['p_imgs'][selectedIndex]),
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: -10,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(widget.data['p_imgs'].length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.deepPurple,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                widget.data["p_imgs"][index],
                              ),
                              height: 50,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        "Name: "
                                            .text
                                            .fontFamily(bold)
                                            .color(isdarkMode
                                                ? whiteColor
                                                : darkFontGrey)
                                            .size(16)
                                            .make(),
                                        widget.title!.text
                                            .size(16)
                                            .color(isdarkMode
                                                ? whiteColor
                                                : darkFontGrey)
                                            .fontFamily(semibold)
                                            .make(),
                                      ],
                                    ),
                                    10.heightBox,
                                    Row(
                                      children: [
                                        "Rating: ".text.fontFamily(bold).make(),
                                        VxRating(
                                          value: double.parse(
                                              widget.data['p_rating']),
                                          onRatingUpdate: (value) {},
                                          normalColor: textfieldGrey,
                                          selectionColor: golden,
                                          size: 25,
                                          isSelectable: false,
                                          count: 5,
                                          maxRating: 5,
                                        ),
                                      ],
                                    ),
                                    10.heightBox,
                                    Row(
                                      children: [
                                        "Rs: "
                                            .text
                                            .fontFamily(bold)
                                            .color(isdarkMode
                                                ? whiteColor
                                                : darkFontGrey)
                                            .size(16)
                                            .make(),
                                        "${widget.data['p_price']}"
                                            .numCurrency
                                            .text
                                            .color(isdarkMode
                                                ? whiteColor
                                                : redColor)
                                            .fontFamily(bold)
                                            .size(16)
                                            .make(),
                                      ],
                                    ),
                                    10.heightBox,
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            "Brand: "
                                                .text
                                                .fontFamily(bold)
                                                .color(isdarkMode
                                                    ? whiteColor
                                                    : darkFontGrey)
                                                .size(16)
                                                .make(),
                                            "${widget.data['p_brand']}"
                                                .text
                                                .color(isdarkMode
                                                    ? whiteColor
                                                    : darkFontGrey)
                                                .fontFamily(bold)
                                                .size(16)
                                                .make(),
                                          ],
                                        ),
                                        10.heightBox,
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    "Seller"
                                                        .text
                                                        .white
                                                        .fontFamily(semibold)
                                                        .make(),
                                                    5.heightBox,
                                                    "${widget.data['p_seller']}"
                                                        .text
                                                        .fontFamily(semibold)
                                                        .color(darkFontGrey)
                                                        .make(),
                                                  ],
                                                ),
                                              ),
                                              const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                    Icons.message_rounded,
                                                    color: fontGrey),
                                              ).onTap(() {
                                                Get.to(() => const ChatScreen(),
                                                    arguments: [
                                                      widget.data['p_seller'],
                                                      widget.data['vaendor_id']
                                                    ]);
                                              })
                                            ],
                                          )
                                              .box
                                              .topRightRounded(value: 30)
                                              .height(60)
                                              .padding(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16))
                                              .color(isdarkMode
                                                  ? fontGrey
                                                  : textfieldGrey)
                                              .make(),
                                        ),
                                        10.heightBox,
                                        Obx(() => Column(
                                              children: [
                                                //quantity section
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      // width: 70,
                                                      child: "Quantity: "
                                                          .text
                                                          .fontFamily(bold)
                                                          .color(darkFontGrey)
                                                          .make(),
                                                    ),
                                                    //color section
                                                    20.heightBox,
                                                    Obx(
                                                      () => Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                controller
                                                                    .decreaseQuantity();
                                                                if (controller
                                                                        .quantity
                                                                        .value >
                                                                    3) {
                                                                  controller.calculateTotalPrice(
                                                                      int.parse(
                                                                          widget
                                                                              .data['p_discountprice']));
                                                                } else {
                                                                  controller.calculateTotalPrice(
                                                                      int.parse(
                                                                          widget
                                                                              .data['p_price']));
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .remove)),
                                                          controller.quantity
                                                              .value.text
                                                              .size(16)
                                                              .color(isdarkMode
                                                                  ? whiteColor
                                                                  : darkFontGrey)
                                                              .fontFamily(bold)
                                                              .make(),
                                                          IconButton(
                                                              onPressed: () {
                                                                controller
                                                                    .increaseQuantity(
                                                                  int.parse(widget
                                                                          .data[
                                                                      'p_quantity']),
                                                                );
                                                                if (controller
                                                                        .quantity
                                                                        .value >
                                                                    3) {
                                                                  controller.calculateTotalPrice(
                                                                      int.parse(
                                                                          widget
                                                                              .data['p_discountprice']));
                                                                } else {
                                                                  controller.calculateTotalPrice(
                                                                      int.parse(
                                                                          widget
                                                                              .data['p_price']));
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                  Icons.add)),
                                                          2.widthBox,
                                                          "(${widget.data['p_quantity']} available)"
                                                              .text
                                                              .color(
                                                                  darkFontGrey)
                                                              .make(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ).box.make(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child:
                                                      "NOTE: Discount of ${widget.data['p_discountprice']} PKR will be applied when you order more than Three items of the this product"
                                                          .text
                                                          .make(),
                                                ),
                                                10.heightBox,
                                                //Total section
                                                Row(
                                                  children: [
                                                    "Total: "
                                                        .text
                                                        .fontFamily(bold)
                                                        .color(darkFontGrey)
                                                        .make(),
                                                    "${controller.totalPrice.value}"
                                                        .numCurrency
                                                        .text
                                                        .color(isdarkMode
                                                            ? whiteColor
                                                            : redColor)
                                                        .size(16)
                                                        .fontFamily(bold)
                                                        .make(),
                                                  ],
                                                )
                                              ],
                                            )),
                                        // description section
                                        10.heightBox,
                                        "Description"
                                            .text
                                            .color(isdarkMode
                                                ? whiteColor
                                                : darkFontGrey)
                                            .size(16)
                                            .fontFamily(semibold)
                                            .make()
                                            .box
                                            .alignCenterLeft
                                            .make(),
                                        5.heightBox,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: "${widget.data['p_desc']}"
                                              .text
                                              .color(isdarkMode
                                                  ? whiteColor
                                                  : darkFontGrey)
                                              .make()
                                              .box
                                              .alignCenterLeft
                                              .make(),
                                        ),
                                        10.heightBox,
                                        SizedBox(
                                            width: double.infinity,
                                            height: 60,
                                            child: outButton(
                                              color: redColor,
                                              onPress: () {
                                                controller.addItemInCart(
                                                    cartCollection);
                                                // controller.addnotification("Notification");
                                                if (controller.quantity.value >
                                                    0) {
                                                  controller.addToCart(
                                                    context: context,
                                                    vendorID: widget
                                                        .data['vaendor_id'],
                                                    img: widget.data['p_imgs']
                                                        [0],
                                                    qty: controller
                                                        .quantity.value,
                                                    sellername:
                                                        widget.data['p_seller'],
                                                    title:
                                                        widget.data['p_name'],
                                                    tprice: controller
                                                        .totalPrice.value,
                                                  );
                                                  VxToast.show(context,
                                                      msg: "Added to cart");
                                                } else {
                                                  VxToast.show(context,
                                                      msg:
                                                          "Minimum 1 product is required");
                                                }
                                              },
                                              textColor: whiteColor,
                                              title: "Add to cart",
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                          .box
                          .width(285)
                          .padding(const EdgeInsets.symmetric(vertical: 20))
                          .make(),
                    )
                        .box
                        .topRightRounded(value: 130)
                        .size(320, 350)
                        .color(
                          isdarkMode
                              ? fontGrey.withOpacity(0.9)
                              : whiteColor.withOpacity(0.9),
                        )
                        .make(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
