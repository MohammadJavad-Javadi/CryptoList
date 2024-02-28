import 'package:crypto_bazar/data/model/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto_bazar/data/model/crypto.dart';

class CryptoScreen extends StatefulWidget {
  CryptoScreen({super.key, required this.cryptoList});
  List<Crypto> cryptoList;
  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  List<Crypto>? cryptoList;
  List<Crypto>? showList;
  bool loadingTextVisibility = false;
  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
    showList = cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'کریپتو بازار',
          style: TextStyle(fontFamily: 'Sahel'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'نام رمز ارز معتبر را جستجو کنید',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          width: 4.0,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      filled: true,
                      fillColor: greenColor,
                    ),
                    onChanged: (value) {
                      _filterList(value);
                      setState(() {});
                    },
                  ),
                ),
              ),
              Visibility(
                visible: loadingTextVisibility,
                child: Text(
                  '... در حال بروزرسانی اطلاعات رمز ارز ها',
                  style: TextStyle(
                    color: greenColor,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: greenColor,
                  onRefresh: () async {
                    // List<Crypto> freshData = await _getData();
                    // setState(() {
                    //   cryptoList = freshData;
                    // });
                    await _getData();
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: showList!.length,
                    itemBuilder: (context, index) {
                      return _getListTileItem(showList![index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _filterList(String value) async {
    if (value.isEmpty) {
      setState(() {
        loadingTextVisibility = true;
      });
    }
    await _getData();
    setState(() {
      showList = cryptoList;
      loadingTextVisibility = false;
    });
    List<Crypto> serchList = showList!.where((element) {
      return element.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
    showList = serchList;
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(crypto.name, style: TextStyle(color: greenColor)),
      subtitle: Text(crypto.symbol, style: TextStyle(color: greyColor)),
      leading: SizedBox(
          width: 28.0,
          child: Center(
              child: Text(crypto.rank.toString(),
                  style: TextStyle(color: greyColor)))),
      trailing: SizedBox(
        width: 150.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(crypto.priceUsd.toStringAsFixed(2),
                    style: TextStyle(color: greyColor, fontSize: 18.0)),
                Text(
                  crypto.changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getColorChangePercent(crypto.changePercent24Hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 49,
              child: _getChangePercentIcon(crypto.changePercent24Hr),
            )
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: greenColor,
          );
  }

  Widget _getChangePercentIcon(double changePercent) {
    return changePercent <= 0
        ? Icon(
            Icons.trending_down,
            size: 24.0,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 24.0,
            color: greenColor,
          );
  }

  Color _getColorChangePercent(double changePercent) {
    return changePercent <= 0 ? redColor : greenColor;
  }

  Future<void> _getData() async {
    Response response = await Dio().get('https://api.coincap.io/v2/assets');
    cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
  }
}
