import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/home_controller.dart';
import '../../services/firebase_services.dart';
import '../../widgets_common/loading_indicator.dart';
import '../category_screen/items_details.dart';
import 'search_screen.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthCount = (MediaQuery.of(context).size.width ~/ 150).toInt();
    const minCount = 2;
    var controller = Get.find<HomeController>();
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        width: context.screenWidth,
        height: context.screenHeight,
        color: isdarkMode ? darkColor : lightGrey,
        child: SafeArea(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              child: TextFormField(
                controller: controller.searchController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: 'Search'
                      .text
                      .white
                      .makeCentered()
                      .box
                      .color(isdarkMode ? fontGrey : Colors.lightBlue.shade100)
                      .size(60, 47)
                      .shadowSm
                      .make()
                      .onTap(() {
                    if (controller.searchController.text.isNotEmptyAndNotNull) {
                      Get.to(
                        () => SearchScreen(
                          title: controller.searchController.text,
                        ),
                      );
                    }
                  }),
                  filled: true,
                  fillColor: isdarkMode ? fontGrey : whiteColor,
                  hintText: searchAnything,
                  hintStyle: const TextStyle(color: textfieldGrey),
                ),
              ),
            ),
            5.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: FirestoreServices.homeallproducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return loadingIndicator();
                          } else {
                            var allproductsdata = snapshot.data!.docs;

                            return VxSwiper.builder(
                              scrollPhysics: const BouncingScrollPhysics(),
                              autoPlay: true,
                              autoPlayCurve: Curves.easeInOutBack,
                              scrollDirection: Axis.vertical,
                              height: 300,
                              enlargeCenterPage: true,
                              itemCount: 4,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1.0,
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      loadingIndicator(),
                                  imageUrl: allproductsdata[index]['p_imgs'][0],
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                  fadeOutDuration: const Duration(seconds: 1),
                                  fadeInDuration: const Duration(seconds: 3),
                                ).box.make().onTap(() {
                                  Get.to(() => ItemsDetailsScreen(
                                      title:
                                          "${allproductsdata[index]['p_name']}",
                                      data: allproductsdata[index]));
                                });
                              },
                            )
                                .box
                                .bottomRightRounded(value: 100)
                                .clip(Clip.antiAlias)
                                .make();
                          }
                        }),

                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          popular.text.size(18).fontFamily(semibold).make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: StreamBuilder(
                                stream: FirestoreServices.homeallproducts(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return loadingIndicator();
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: "No Popular products "
                                          .text
                                          .color(darkFontGrey)
                                          .make(),
                                    );
                                  } else {
                                    var data = snapshot.data!.docs;

                                    return Row(
                                        children: List.generate(
                                      data.length,
                                      (index) => data[index]['p_wishlist']
                                                  .length ==
                                              0
                                          ? const SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      loadingIndicator(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(8),
                                                      ),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  imageUrl: data[index]
                                                      ['p_imgs'][0],
                                                  width: 100,
                                                  height: 130,
                                                  fit: BoxFit.cover,
                                                  fadeOutDuration:
                                                      const Duration(
                                                          seconds: 1),
                                                  fadeInDuration:
                                                      const Duration(
                                                          seconds: 3),
                                                )
                                                    .box
                                                    .shadow
                                                    .topRounded(value: 50)
                                                    .clip(Clip.antiAlias)
                                                    .make(),
                                                10.heightBox,
                                                "${data[index]['p_name']}"
                                                    .text
                                                    .fontFamily(semibold)
                                                    .color(isdarkMode
                                                        ? whiteColor
                                                        : darkFontGrey)
                                                    .make(),
                                                10.heightBox,
                                                "${data[index]['p_price']}"
                                                    .numCurrency
                                                    .text
                                                    .fontFamily(bold)
                                                    .size(16)
                                                    .color(isdarkMode
                                                        ? whiteColor
                                                        : redColor)
                                                    .make(),
                                              ],
                                            )
                                              .box
                                              .margin(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4))
                                              .p4
                                              .make()
                                              .onTap(() {
                                              Get.to(() => ItemsDetailsScreen(
                                                  title:
                                                      "${data[index]['p_name']}",
                                                  data: data[index]));
                                            }),
                                    ));
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    // featured Products

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProducts.text
                            .color(whiteColor)
                            .size(18)
                            .fontFamily(semibold)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                              future: FirestoreServices.getfeaturedproducts(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(redColor),
                                    ),
                                  );
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    child: "No featured products "
                                        .text
                                        .color(darkFontGrey)
                                        .make(),
                                  );
                                } else {
                                  var featuredData = snapshot.data!.docs;

                                  return Row(
                                      children: List.generate(
                                    featuredData.length,
                                    (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              loadingIndicator(),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          imageUrl: featuredData[index]
                                              ['p_imgs'][0],
                                          width: 100,
                                          height: 130,
                                          fit: BoxFit.cover,
                                          fadeOutDuration:
                                              const Duration(seconds: 1),
                                          fadeInDuration:
                                              const Duration(seconds: 3),
                                        )
                                            .box
                                            .shadow
                                            .topRounded(value: 50)
                                            .clip(Clip.antiAlias)
                                            .make(),
                                        10.heightBox,
                                        "${featuredData[index]['p_name']}"
                                            .text
                                            .fontFamily(semibold)
                                            .color(isdarkMode
                                                ? whiteColor
                                                : darkFontGrey)
                                            .make(),
                                        10.heightBox,
                                        "${featuredData[index]['p_price']}"
                                            .numCurrency
                                            .text
                                            .fontFamily(bold)
                                            .size(16)
                                            .color(isdarkMode
                                                ? whiteColor
                                                : redColor)
                                            .make(),
                                      ],
                                    )
                                        .box
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 4))
                                        .p3
                                        .make()
                                        .onTap(() {
                                      Get.to(() => ItemsDetailsScreen(
                                          title:
                                              "${featuredData[index]['p_name']}",
                                          data: featuredData[index]));
                                    }),
                                  ));
                                }
                              }),
                        ),
                      ],
                    )
                        .box
                        .bottomRightRounded(value: 70)
                        .clip(Clip.antiAlias)
                        .width(double.infinity)
                        .padding(const EdgeInsets.all(8))
                        .color(isdarkMode
                            ? darkFontGrey
                            : Colors.lightBlue.shade100)
                        .make(),
                    20.heightBox,
                    // all products sections
                    Align(
                      alignment: Alignment.topLeft,
                      child: "All Products"
                          .text
                          .color(isdarkMode ? whiteColor : darkFontGrey)
                          .size(18)
                          .fontFamily(semibold)
                          .make(),
                    ),
                    10.heightBox,
                    StreamBuilder(
                        stream: FirestoreServices.homeallproducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(redColor),
                              ),
                            );
                          } else {
                            var allproductsdata = snapshot.data!.docs;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allproductsdata.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            max(widthCount, minCount),
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        mainAxisExtent: 250),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CachedNetworkImage(
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          placeholder: (context, url) =>
                                              loadingIndicator(),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          fadeOutDuration:
                                              const Duration(seconds: 1),
                                          fadeInDuration:
                                              const Duration(seconds: 3),
                                          imageUrl: allproductsdata[index]
                                              ['p_imgs'][0],
                                          width: double.maxFinite,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        ).box.shadow.make(),
                                      ),
                                      10.heightBox,
                                      "${allproductsdata[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(isdarkMode
                                              ? whiteColor
                                              : darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "${allproductsdata[index]['p_price']}"
                                          .text
                                          .fontFamily(bold)
                                          .size(12)
                                          .color(isdarkMode
                                              ? whiteColor
                                              : redColor)
                                          .make(),
                                      10.heightBox
                                    ],
                                  ).box.roundedSM.make().onTap(() {
                                    Get.to(() => ItemsDetailsScreen(
                                        title:
                                            "${allproductsdata[index]['p_name']}",
                                        data: allproductsdata[index]));
                                  });
                                },
                              ),
                            );
                          }
                        })
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
