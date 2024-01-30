import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klnakhadem/assets_paths/app_images.dart';
import 'package:klnakhadem/model/bill_for_buyer_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:printing/printing.dart';
import 'package:klnakhadem/colors_and_sizes/app_colors.dart';
import 'package:klnakhadem/colors_and_sizes/mobile_app_sizes.dart';
import 'package:klnakhadem/componants/app_text.dart';

class MAbillForBuyerCard extends StatefulWidget {
  const MAbillForBuyerCard({super.key,required this.bill});
  final BillForBuyer bill;

  @override
  State<MAbillForBuyerCard> createState() => _MAbillForBuyerCardState();
}

class _MAbillForBuyerCardState extends State<MAbillForBuyerCard> {

  bool open = false;
  final pw.Document pdf = pw.Document();
  late final Uint8List pdfBytes;
  bool isLoading = false;

  late final double taxes;
  late final double zekaTaxes;
  late final double amolaFactor;

  void buildPdf() {
    setState(() {
      isLoading = true;
    });

    rootBundle.load(AppImages.logo).then((value) {
      pw.MemoryImage image = pw.MemoryImage(value.buffer.asUint8List());

      rootBundle.load("fonts/Hacen_Tunisia/Hacen-Tunisia.ttf").then((value) {
        pw.Font myFont = pw.Font.ttf(value);

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Expanded(
                  child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('eeeeee'),
                      ),
                      child: pw.Stack(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(20),
                                child: pw.Expanded(
                                    child: pw.Center(
                                        child: pw.Opacity(
                                            child: pw.Image(image),
                                            opacity: 0.2
                                        )
                                    )
                                )
                            ),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(20),
                                child: pw.Expanded(
                                    child: pw.Column(
                                        mainAxisAlignment: pw.MainAxisAlignment.start,
                                        mainAxisSize: pw.MainAxisSize.max,
                                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                                        children: [
                                          pw.Stack(
                                              children: [
                                                pw.Center(child: boldText('فاتورة بيع',myFont)),
                                                pw.Row(
                                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                                    mainAxisSize: pw.MainAxisSize.max,
                                                    children: [
                                                      boldText(
                                                          'كلنا خادم',myFont
                                                      ),
                                                      pw.SizedBox(
                                                          width: 3
                                                      ),
                                                      pw.SizedBox(
                                                          child: pw.Image(image),
                                                          height: 20,
                                                          width: 20
                                                      )
                                                    ]
                                                )
                                              ]
                                          ),
                                          pw.Row(
                                              children: [
                                                pw.Expanded(
                                                    flex: 1,
                                                    child: pw.Column(
                                                        mainAxisAlignment: pw.MainAxisAlignment.start,
                                                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                        children: [
                                                          boldText(
                                                              'المشتري',myFont
                                                          ),
                                                          pw.Column(
                                                              children: [
                                                                normalText(
                                                                    widget.bill.buyer,myFont
                                                                ),
                                                              ]
                                                          ),
                                                          pw.Column(
                                                              children: [
                                                                normalText(
                                                                    '${widget.bill.address.street}, ${widget.bill.address.supArea}, ${widget.bill.address.area}, ${widget.bill.address.city}',myFont
                                                                ),
                                                              ]
                                                          )
                                                        ]
                                                    )
                                                ),
                                                pw.Expanded(
                                                    flex: 1,
                                                    child: pw.Column(
                                                        mainAxisAlignment: pw.MainAxisAlignment.start,
                                                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                        children: [
                                                          boldText(
                                                              'البائع',myFont
                                                          ),
                                                          pw.Column(
                                                              children: [
                                                                normalText(
                                                                    'كلنا خادم',myFont
                                                                ),
                                                              ]
                                                          ),
                                                          pw.Column(
                                                              children: [
                                                                normalText(
                                                                    'القكيف - ام الجزم 2377 المملكة العربية السعودية',myFont
                                                                ),
                                                              ]
                                                          )
                                                        ]
                                                    )
                                                ),
                                                pw.Expanded(
                                                    flex: 2,
                                                    child: pw.Column(
                                                        children: [
                                                          pw.Row(
                                                              mainAxisSize: pw.MainAxisSize.min,
                                                              children: [
                                                                pw.Expanded(
                                                                    flex: 1,
                                                                    child: pw.Column(
                                                                        mainAxisAlignment: pw.MainAxisAlignment.start,
                                                                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                                        children: [
                                                                          normalText(
                                                                              widget.bill.companyRegisterNumber,myFont
                                                                          ),
                                                                          normalText(
                                                                              widget.bill.serial,myFont
                                                                          ),
                                                                          normalText(
                                                                              '${widget.bill.billTime.year}-${widget.bill.billTime.month}-${widget.bill.billTime.day}',myFont
                                                                          ),
                                                                          /*normalText(
                                                                              'NSADB0097124738-S1',myFont
                                                                          ),*/
                                                                        ]
                                                                    )
                                                                ),
                                                                pw.Expanded(
                                                                    flex: 1,
                                                                    child: pw.Column(
                                                                        mainAxisAlignment: pw.MainAxisAlignment.start,
                                                                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                                        children: [
                                                                          normalText(
                                                                              'الرقم الضريبي للمنشأة الموردة',myFont
                                                                          ),
                                                                          normalText(
                                                                              'رقم الفاتورة',myFont
                                                                          ),
                                                                          normalText(
                                                                              'تاريخ الفاتورة',myFont
                                                                          ),
                                                                          /*normalText(
                                                                              'رقم الشحنة',myFont
                                                                          ),*/
                                                                        ]
                                                                    )
                                                                ),
                                                              ]
                                                          )
                                                        ]
                                                    )
                                                ),
                                              ]
                                          ),
                                          pw.Expanded(
                                              child: pw.Table(
                                                  border: pw.TableBorder.all(
                                                      width: 1,
                                                      color: PdfColor.fromHex('1b6165')
                                                  ),
                                                  children: [
                                                    pw.TableRow(
                                                        children: [
                                                          boldText(
                                                              'الاجمالي شامل الضريبة',myFont
                                                          ),
                                                          boldText(
                                                              'قيمة الضريبة',myFont
                                                          ),
                                                          boldText(
                                                              'الاجمالي غير شامل الضريبة',myFont
                                                          ),
                                                          boldText(
                                                              'الكمية',myFont
                                                          ),
                                                          boldText(
                                                              'سعر الوحدة',myFont
                                                          ),
                                                          boldText(
                                                              'الوصف',myFont
                                                          ),
                                                          boldText(
                                                              'كود المنتج',myFont
                                                          ),
                                                          boldText(
                                                              'الرقم التسلسلي',myFont
                                                          ),
                                                        ],
                                                        decoration: const pw.BoxDecoration(
                                                            color: PdfColors.grey
                                                        )
                                                    ),
                                                    for(int i=0;i<widget.bill.productsName.length;i++)...[
                                                      pw.TableRow(
                                                        children: [
                                                          normalText(
                                                              widget.bill.productsPriceAfterVat[i].toStringAsFixed(2),myFont
                                                          ),
                                                          normalText(
                                                              widget.bill.productsVat[i].toStringAsFixed(2),myFont
                                                          ),
                                                          normalText(
                                                              (widget.bill.productsPriceAfterVat[i] - widget.bill.productsVat[i]).toStringAsFixed(2),myFont
                                                          ),
                                                          normalText(
                                                              widget.bill.productsQuantity[i].toString(),myFont
                                                          ),
                                                          normalText(
                                                              widget.bill.productsPricePerOne[i].toString(),myFont
                                                          ),
                                                          normalText(
                                                              widget.bill.productsName[i],myFont
                                                          ),
                                                          normalText(
                                                              widget.bill.productsId[i],myFont
                                                          ),
                                                          normalText(
                                                              (i+1).toString(),myFont
                                                          ),
                                                        ],
                                                      )
                                                    ]
                                                  ]
                                              )
                                          ),
                                          pw.Padding(
                                              padding: const pw.EdgeInsets.all(3),
                                              child: pw.Row(
                                                  children: [
                                                    pw.Expanded(
                                                        flex: 1,
                                                        child: pw.Column(
                                                            mainAxisAlignment: pw.MainAxisAlignment.start,
                                                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                            children: [
                                                              pw.Row(
                                                                children: [
                                                                  boldText(
                                                                      'ريال سعودي',myFont
                                                                  ),
                                                                  boldText(
                                                                      'العملة',myFont
                                                                  ),
                                                                ],
                                                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                                              ),
                                                              pw.Row(
                                                                children: [
                                                                  boldText(
                                                                      (widget.bill.orderTotalPrice - widget.bill.vatTotalPrice).toStringAsFixed(2),myFont
                                                                  ),
                                                                  boldText(
                                                                      'المجموع الفرعي',myFont
                                                                  ),
                                                                ],
                                                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                                              ),
                                                              pw.Row(
                                                                children: [
                                                                  boldText(
                                                                      widget.bill.vatTotalPrice.toStringAsFixed(2),myFont
                                                                  ),
                                                                  normalText(
                                                                      'قيمة الضريبة',myFont
                                                                  ),
                                                                  boldText(
                                                                      '${widget.bill.vat*100}%',myFont
                                                                  ),
                                                                  normalText(
                                                                      'نسبة الضريبة',myFont
                                                                  ),
                                                                ],
                                                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                                              ),
                                                              pw.Row(
                                                                children: [
                                                                  boldText(
                                                                      widget.bill.delivery.toString(),myFont
                                                                  ),
                                                                  boldText(
                                                                      'التوصيل',myFont
                                                                  ),
                                                                ],
                                                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                                              ),
                                                              pw.Row(
                                                                children: [
                                                                  boldText(
                                                                      (widget.bill.orderTotalPrice+widget.bill.delivery).toStringAsFixed(2),myFont
                                                                  ),
                                                                  boldText(
                                                                      'المجموع',myFont
                                                                  ),
                                                                ],
                                                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                                              ),
                                                            ]
                                                        )
                                                    ),
                                                    pw.Expanded(flex: 10,child: pw.SizedBox())
                                                  ]
                                              )
                                          )
                                        ]
                                    )
                                )
                            )
                          ]
                      )
                  )
              ); // Center
            }));

        pdf.save().then((value) {
          pdfBytes = value;
          setState(() {
            isLoading = false;
          });
        });// Page

      });
    });
  }

  @override
  void initState() {
    super.initState();
    buildPdf();
  }

  pw.Padding boldText (String s, pw.Font myFont) {
    return pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Center(child: pw.Directionality(child: pw.Text(s, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: myFont,fontSize: 5)),textDirection: pw.TextDirection.rtl))
    );
  }

  pw.Padding normalText (String s, pw.Font myFont) {
    return pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Center(child: pw.Directionality(child: pw.Text(s, style: pw.TextStyle(font: myFont,fontSize: 5)),textDirection: pw.TextDirection.rtl))
    );
  }

  Future<void> printArabicPdf (pw.Document pdf) async{
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: isLoading?const Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):(open? Container(
        height: MAsizes.heightOfMyOrderContainer,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: AppColors.offWhiteBoxColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        open = !open;
                      });
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  const Expanded(child: SizedBox()),
                  AppText(widget.bill.serial, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  AppText(' # ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  AppText('الطلب رقم', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                ],
              ),
              Container(
                height: 1,
                width: MAsizes.screenW,
                decoration: const BoxDecoration(
                    color: AppColors.mainColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppText('فاتورة الطلب', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
                  ],
                ),
              ),
              Expanded(
                child: PDFView(
                  pdfData: pdfBytes,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                  fitPolicy: FitPolicy.BOTH,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  onPressed: () async {
                    printArabicPdf(pdf);
                  },
                  child: Container(
                      height: MAsizes.buttonHeight,
                      width: MAsizes.screenW,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MAsizes.buttonBorderRadius),
                          color: AppColors.buttonGreenColor
                      ),
                      child: Center(child: AppText('طباعة',color: AppColors.textWhiteColor,size: MAsizes.textNormalSize,))
                  ),
                ),
              ),
            ],
          ),
        ),
      ) : Container(
        height: MAsizes.buttonHeight*1.5,
        width: MAsizes.screenW,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MAsizes.bigContainerBorderRadius),
            color: AppColors.offWhiteBoxColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    open = !open;
                  });
                },
                icon: const Icon(Icons.arrow_downward),
              ),
              const Expanded(child: SizedBox()),
              AppText(widget.bill.serial, size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
              AppText(' # ', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
              AppText('الطلب رقم', size: MAsizes.textNormalSize, color: AppColors.textGreenColor),
            ],
          ),
        ),
      )),
    );
  }
}
