import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../global_widget/custom_button.dart';
import '../controllers/home_controller.dart';
import 'local_widget/select_pick_image_option.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade300,
          title: const Text('Text Recognition'),
          centerTitle: true,
        ),
        body: Obx(
          () => Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.isPick.value == false
                      ? DotBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 70),
                            child: SvgPicture.asset("assets/icons/upload.svg",
                                color: Colors.black, width: 50, height: 50),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.file(controller.imageFile.value!),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: CustomButton(
                              showBorderOnly: true,
                              text: "Upload Image",
                              onTap: () => showSelectPhotoOptions(context))),
                      const SizedBox(
                        width: 10,
                      ),
                      if(controller.isPick.value==true)
                      Expanded(
                          child: CustomButton(
                              //icon: controller.isLoading.value?const CircularProgressIndicator():null ,
                              text: "Convert To Text",
                              onTap: (controller.isLoading.value)
                                  ? null
                                  : () {
                                      controller.processImage(image: controller.imageFile.value!, language: 'bef',);
                                    }))
                    ],
                  ),
                  const SizedBox(height: 30,),
                  if (controller.imageProcessText.isEmpty == false)
                    DotBox(
                      child: Center(
                        child: Text(
                          controller.imageProcessText.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (controller.isConvert.value == true)
                    CustomButton(
                        icon: const Icon(Icons.translate, color: Colors.white),
                        text: "Translate To Bangle",
                        onTap: () {
                          //final InputImage inputImage = InputImage.fromFilePath(controller.imageFile.value!.path);
                        }),
                  const SizedBox(
                    height: 30,
                  ),
                  if (controller.translateText.isEmpty == false)
                    DotBox(
                        child: Text(
                          controller.translateText.value,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: Colors.green, fontSize: 25),
                        ))
                ],
              ),
            ),
          ),
        ));
  }
  void showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
                controller: scrollController,
                child: SelectPickImageOption(
                    onTap: controller.pickImage)
            );
          }),
    );
  }
}

class DotBox extends StatelessWidget {
  const DotBox({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      strokeWidth: 2,
      dashPattern: const [4, 4],
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        child: Center(child: child),
      ),
    );
  }


}
