import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/constant/android_ios_storage.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/paid_id_item_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/paid_ad_item_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/core/dashboard_view.dart';
import 'package:flutterbuyandsell/ui/item/paid_ad/paid_ad_item_vertical_list_item.dart';
import 'package:flutterbuyandsell/ui/payment/payment.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaidAdItemListView extends StatefulWidget {
  const PaidAdItemListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _PaidAdItemListView createState() => _PaidAdItemListView();
}

class _PaidAdItemListView extends State<PaidAdItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  PaidAdItemProvider _paidAdItemProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _paidAdItemProvider.nextPaidAdItemList(psValueHolder.loginUserId);
      }
    });
    getData();
    super.initState();
  }

  void getData() {
    AndroidIosStorage().getItem('buy').then((value) {
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      setState(() {
        if (value != null) {
          value == sgold
              ? buy1 = paid
              : value == sdiamond
                  ? buy2 = paid
                  : value == splatinum
                      ? buy3 = paid
                      : value == srubbi
                          ? buy4 = paid
                          : () {};
        }
      });
    });
  }

  double amount;

  UserProvider userProvider;

  String gold = '4,999',
      paid = 'Paid',
      diamond = '9,999',
      platinum = '19,999',
      rubbi = '59,999',
      sgold = 'Gold',
      sdiamond = 'Diamond',
      splatinum = 'Platinum',
      srubbi = 'Rubbi',
      ncur = 'assets/images/ncur.png';
  PaidAdItemRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  String buy1 = 'Buy Now', buy2 = 'Buy Now', buy3 = 'Buy Now', buy4 = 'Buy Now';
  String userId = '';
  @override
  Widget build(BuildContext context) {
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<PaidAdItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print('######### ${psValueHolder.loginUserId}');
    print(
        '............................Build UI Again ............................');
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:

    Future postData(String premium) async {
      final http.Response response = await http.post(
        'https://us-central1-database-664f5.cloudfunctions.net/api/v1/update/premium',
        body: {
          'user_id': psValueHolder.loginUserId,
          'premium': premium,
        },
      );
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        Navigator.of(context).pop();
        return response;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }

    return ChangeNotifierProvider<PaidAdItemProvider>(
        lazy: false,
        create: (BuildContext context) {
          final PaidAdItemProvider provider =
              PaidAdItemProvider(repo: repo1, psValueHolder: psValueHolder);
          provider.loadPaidAdItemList(psValueHolder.loginUserId);
          _paidAdItemProvider = provider;
          return _paidAdItemProvider;
        },
        child: Consumer<PaidAdItemProvider>(
          builder: (BuildContext context, PaidAdItemProvider provider,
              Widget child) {
            // return Stack(children: <Widget>[
            //   Container(
            //       margin: const EdgeInsets.only(
            //           left: PsDimens.space4,
            //           right: PsDimens.space4,
            //           top: PsDimens.space4,
            //           bottom: PsDimens.space4),
            //       child: RefreshIndicator(
            //         child: CustomScrollView(
            //             controller: _scrollController,
            //             scrollDirection: Axis.vertical,
            //             shrinkWrap: true,
            //             slivers: <Widget>[
            //               SliverGrid(
            //                 gridDelegate:
            //                     const SliverGridDelegateWithMaxCrossAxisExtent(
            //                         maxCrossAxisExtent: 220,
            //                         childAspectRatio: 0.6),
            //                 delegate: SliverChildBuilderDelegate(
            //                   (BuildContext context, int index) {
            //                     if (provider.favouriteItemList.data != null ||
            //                         provider
            //                             .favouriteItemList.data.isNotEmpty) {
            //                       final int count =
            //                           provider.favouriteItemList.data.length;
            //                       return ProductVeticalListItem(
            //                         coreTagKey: provider.hashCode.toString() +
            //                             provider
            //                                 .favouriteItemList.data[index].id,
            //                         animationController:
            //                             widget.animationController,
            //                         animation:
            //                             Tween<double>(begin: 0.0, end: 1.0)
            //                                 .animate(
            //                           CurvedAnimation(
            //                             parent: widget.animationController,
            //                             curve: Interval(
            //                                 (1 / count) * index, 1.0,
            //                                 curve: Curves.fastOutSlowIn),
            //                           ),
            //                         ),
            //                         product: provider
            //                             .favouriteItemList.data[index],
            //                         onTap: () async {
            //                           final Product product = provider
            //                               .favouriteItemList.data.reversed
            //                               .toList()[index];
            //                           final ProductDetailIntentHolder holder =
            //                               ProductDetailIntentHolder(
            //                                   product: provider
            //                                       .favouriteItemList
            //                                       .data[index],
            //                                   heroTagImage: provider.hashCode
            //                                           .toString() +
            //                                       product.id +
            //                                       PsConst.HERO_TAG__IMAGE,
            //                                   heroTagTitle: provider.hashCode
            //                                           .toString() +
            //                                       product.id +
            //                                       PsConst.HERO_TAG__TITLE);
            //                           await Navigator.pushNamed(
            //                               context, RoutePaths.productDetail,
            //                               arguments: holder);

            //                           await provider.resetFavouriteItemList();
            //                         },
            //                       );
            //                     } else {
            //                       return null;
            //                     }
            //                   },
            //                   childCount:
            //                       provider.favouriteItemList.data.length,
            //                 ),
            //               ),
            //             ]),
            //         onRefresh: () {
            //           return provider.resetFavouriteItemList();
            //         },
            //       )),
            //   PSProgressIndicator(provider.favouriteItemList.status)
            // ]);
            return Stack(children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space8,
                    bottom: PsDimens.space8),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      sgold,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ncur,
                                            height: 15,
                                            width: 20,
                                          ),
                                          Text(
                                            gold,
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text(
                                        buy1,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          amount = 4999;
                                        });
                                        Navigator.push<MaterialPageRoute>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeWidget(
                                              amount: amount,
                                              status: sgold,
                                              userId: psValueHolder.loginUserId,
                                              paymentStatus:
                                                  (dynamic response) {
                                                setState(() {
                                                  buy1 = 'Paid';
                                                });

                                                Navigator.push<
                                                        MaterialPageRoute>(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DashboardView()));
                                              },
                                            ),
                                          ),
                                        );
                                        // Navigator.of(context)`
                                        //     .push(
                                        //         MaterialPageRoute(
                                        //   builder: (context) =>
                                        //       HomeWidget(
                                        //     amount: amount,
                                        //     status: (response) {
                                        //       print(response);
                                        //     },
                                        //   ),
                                        // ));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      sdiamond,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ncur,
                                            height: 15,
                                            width: 20,
                                          ),
                                          Text(
                                            diamond,
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text(
                                        buy2,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          amount = 9999;
                                        });
                                        Navigator.push<MaterialPageRoute>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeWidget(
                                              amount: amount,
                                              status: sdiamond,
                                              userId: psValueHolder.loginUserId,
                                              paymentStatus:
                                                  (dynamic response) {
                                                setState(() {
                                                  buy2 = 'Paid';
                                                });
                                                Navigator.push<
                                                        MaterialPageRoute>(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DashboardView()));
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      splatinum,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ncur,
                                            height: 15,
                                            width: 20,
                                          ),
                                          Text(
                                            platinum,
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text(
                                        buy3,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          amount = 19999;
                                        });
                                        Navigator.push<MaterialPageRoute>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeWidget(
                                              amount: amount,
                                              status: splatinum,
                                              userId: psValueHolder.loginUserId,
                                              paymentStatus:
                                                  (dynamic response) {
                                                setState(() {
                                                  buy3 = 'Paid';
                                                });

                                                Navigator.push<
                                                        MaterialPageRoute>(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DashboardView()));
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      srubbi,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ncur,
                                            height: 15,
                                            width: 20,
                                          ),
                                          Text(
                                            rubbi,
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text(
                                        buy4,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          amount = 59999;
                                        });
                                        Navigator.push<MaterialPageRoute>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeWidget(
                                              amount: amount,
                                              status: srubbi,
                                              userId: psValueHolder.loginUserId,
                                              paymentStatus:
                                                  (dynamic response) {
                                                setState(() {
                                                  buy4 = 'Paid';
                                                });

                                                Navigator.push<
                                                        MaterialPageRoute>(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DashboardView()));
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // if (provider.paidAdItemList.data != null ||
                //     provider.paidAdItemList.data.isNotEmpty) {
                //   final int count =
                //       provider.paidAdItemList.data.length;
                //   return PaidAdItemVerticalListItem(
                //     animationController:
                //         widget.animationController,
                //     animation:
                //         Tween<double>(begin: 0.0, end: 1.0)
                //             .animate(
                //       CurvedAnimation(
                //         parent: widget.animationController,
                //         curve: Interval(
                //             (1 / count) * index, 1.0,
                //             curve: Curves.fastOutSlowIn),
                //       ),
                //     ),
                //     paidAdItem:
                //         provider.paidAdItemList.data[index],
                //     onTap: () {
                //       final ProductDetailIntentHolder holder =
                //           ProductDetailIntentHolder(
                //               product: provider.paidAdItemList
                //                   .data[index].item,
                //               heroTagImage:
                //                   provider.hashCode.toString() +
                //                       provider.paidAdItemList
                //                           .data[index].item.id +
                //                       PsConst.HERO_TAG__IMAGE,
                //               heroTagTitle:
                //                   provider.hashCode.toString() +
                //                       provider.paidAdItemList
                //                           .data[index].item.id +
                //                       PsConst.HERO_TAG__TITLE);
                //       Navigator.pushNamed(
                //           context, RoutePaths.productDetail,
                //           arguments: holder);
                //     },
                //   );
                // } else {
                //   return null;
                // }
              )
            ]);
          },
          // ),
        ));
  }
}
