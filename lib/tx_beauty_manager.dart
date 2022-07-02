import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// 美颜及动效参数管理
class TXBeautyManager {
  static late MethodChannel _channel;
  TXBeautyManager(channel) {
    _channel = channel;
  }

  /// 设置美颜类型
  ///
  /// 参数：
  ///
  /// beautyStyle	美颜风格.三种美颜风格：0 ：光滑 1：自然 2：朦胧
  Future<void> setBeautyStyle(int beautyStyle) {
    return _channel
        .invokeMethod('setBeautyStyle', {"beautyStyle": beautyStyle});
  }

  /// 设置指定素材滤镜特效
  ///
  /// 参数：
  ///
  /// assetUrl可以为flutter中定义的asset资源地址如'images/watermark_img.png'，也可以为网络图片地址
  ///
  /// 注意：必须使用 png 格式
  Future<int?> setFilter(String assetUrl //assets 中的资源地址
      ) async {
    String imageUrl = assetUrl;
    String type = 'network'; //默认为网络图片
    if (assetUrl.indexOf('http') != 0) {
      type = 'local';
    }
    return _channel
        .invokeMethod('setFilter', {"imageUrl": imageUrl, "type": type});
  }

  /// 设置滤镜浓度
  ///
  /// 在美女秀场等应用场景里，滤镜浓度的要求会比较高，以便更加突显主播的差异。 我们默认的滤镜浓度是0.5，如果您觉得滤镜效果不明显，可以使用下面的接口进行调节。
  ///
  /// 参数：
  ///
  /// strength	从0到1，越大滤镜效果越明显，默认值为0.5。
  Future<void> setFilterStrength(double strength) {
    return _channel
        .invokeMethod('setFilterStrength', {"strength": strength.toString()});
  }

  /// 设置绿幕背景视频
  ///
  /// 此处的绿幕功能并非智能抠背，需要被拍摄者的背后有一块绿色的幕布来辅助产生特效
  ///
  /// 参数：
  ///
  /// file 视频文件路径。支持 MP4; nil 表示关闭特效。
  ///
  /// 注意：支持asset资源路径和绝对路径，带"/"开头会被识别为绝对路径
  Future<void> setGreenScreenFile(String? file) async {
    if (file != null && file.indexOf('/') != 0) {
      file = await _copyAssetToLocal(file);
    }
    return _channel.invokeMethod("setGreenScreenFile", {"file": file});
  }

  /// 设置美颜级别
  ///
  /// 参数：
  ///
  /// beautyLevel	美颜级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setBeautyLevel(int beautyLevel) {
    return _channel
        .invokeMethod('setBeautyLevel', {"beautyLevel": beautyLevel});
  }

  /// 设置美白级别
  ///
  /// 参数：
  ///
  /// whitenessLevel	美白级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setWhitenessLevel(int whitenessLevel) {
    return _channel
        .invokeMethod('setWhitenessLevel', {"whitenessLevel": whitenessLevel});
  }

  /// 开启清晰度增强
  ///
  /// 参数：
  ///
  /// enable	true：开启清晰度增强；false：关闭清晰度增强。默认值：true
  Future<void> enableSharpnessEnhancement(bool enable) {
    return _channel
        .invokeMethod('enableSharpnessEnhancement', {"enable": enable});
  }

  /// 设置红润级别
  ///
  /// 参数：
  /// ruddyLevel	红润级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setRuddyLevel(int ruddyLevel) {
    return _channel.invokeMethod('setRuddyLevel', {"ruddyLevel": ruddyLevel});
  }

  /// 获取 License 信息
  Future<String?> getLicenceInfo() {
    return _channel.invokeMethod('getLicenceInfo');
  }

  /// 配置 美颜License，licenceUrl必须使用https，否则ios下回下载失败
  ///
  /// 参数：
  ///
  /// licenceUrl 下载url 和 key。授权 License 请根据 美颜特效 SDK [购买流程](https://cloud.tencent.com/document/product/647/32689#Enterprise) 获取。
  Future<void> setLicence(String licenceUrl, String licenseKey) {
    return _channel.invokeMethod(
        'setLicence', {"licenceUrl": licenceUrl, "licenseKey": licenseKey});
  }

  /// 设置大眼级别，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// eyeScaleLevel	大眼级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setEyeScaleLevel(double eyeScaleLevel) {
    return _channel
        .invokeMethod('setEyeScaleLevel', {"level": eyeScaleLevel.toString()});
  }

  /// 设置瘦脸级别，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// faceSlimLevel	瘦脸级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setFaceSlimLevel(double faceSlimLevel) {
    return _channel
        .invokeMethod('setFaceSlimLevel', {"level": faceSlimLevel.toString()});
  }

  /// 设置 V 脸级别，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// faceVLevel	V脸级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setFaceVLevel(double faceVLevel) {
    return _channel
        .invokeMethod('setFaceVLevel', {"level": faceVLevel.toString()});
  }

  /// 设置大眼级别，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// eyeScaleLevel	大眼级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setChinLevel(double chinLevel) {
    return _channel
        .invokeMethod('setChinLevel', {"level": chinLevel.toString()});
  }

  /// 设置短脸级别，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// faceShortLevel	短脸级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setFaceShortLevel(double faceShortLevel) {
    return _channel.invokeMethod(
        'setFaceShortLevel', {"level": faceShortLevel.toString()});
  }

  /// 设置瘦鼻级别，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// noseSlimLevel	瘦鼻级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setNoseSlimLevel(double noseSlimLevel) {
    return _channel
        .invokeMethod('setNoseSlimLevel', {"level": noseSlimLevel.toString()});
  }

  /// 设置亮眼，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// eyeLightenLevel	亮眼级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setEyeLightenLevel(double eyeLightenLevel) {
    return _channel.invokeMethod(
        'setEyeLightenLevel', {"level": eyeLightenLevel.toString()});
  }

  /// 设置白牙，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// toothWhitenLevel	白牙级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setToothWhitenLevel(double toothWhitenLevel) {
    return _channel.invokeMethod(
        'setToothWhitenLevel', {"level": toothWhitenLevel.toString()});
  }

  /// 设置祛皱，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// wrinkleRemoveLevel	祛皱级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setWrinkleRemoveLevel(double wrinkleRemoveLevel) {
    return _channel.invokeMethod(
        'setWrinkleRemoveLevel', {"level": wrinkleRemoveLevel.toString()});
  }

  /// 设置祛眼袋，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// pounchRemoveLevel	祛眼袋级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setPounchRemoveLevel(double pounchRemoveLevel) {
    return _channel.invokeMethod(
        'setPounchRemoveLevel', {"level": pounchRemoveLevel.toString()});
  }

  /// 设置祛法令纹，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// smileLinesRemoveLevel	祛法令纹级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setSmileLinesRemoveLevel(double smileLinesRemoveLevel) {
    return _channel.invokeMethod('setSmileLinesRemoveLevel',
        {"level": smileLinesRemoveLevel.toString()});
  }

  /// 设置发际线，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// foreheadLevel	发际线级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setForeheadLevel(double foreheadLevel) {
    return _channel
        .invokeMethod('setForeheadLevel', {"level": foreheadLevel.toString()});
  }

  /// 设置眼距，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// eyeDistanceLevel	眼距级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setEyeDistanceLevel(double eyeDistanceLevel) {
    return _channel.invokeMethod(
        'setEyeDistanceLevel', {"level": eyeDistanceLevel.toString()});
  }

  /// 设置眼角，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// eyeAngleLevel	眼角级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setEyeAngleLevel(double eyeAngleLevel) {
    return _channel
        .invokeMethod('setEyeAngleLevel', {"level": eyeAngleLevel.toString()});
  }

  /// 设置嘴型，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// mouthShapeLevel	嘴型级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setMouthShapeLevel(double mouthShapeLevel) {
    return _channel.invokeMethod(
        'setMouthShapeLevel', {"level": mouthShapeLevel.toString()});
  }

  /// 设置鼻翼，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// noseWingLevel	鼻翼级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setNoseWingLevel(double noseWingLevel) {
    return _channel
        .invokeMethod('setNoseWingLevel', {"level": noseWingLevel.toString()});
  }

  /// 设置鼻子位置，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// nosePositionLevel	鼻子位置级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setNosePositionLevel(double nosePositionLevel) {
    return _channel.invokeMethod(
        'setNosePositionLevel', {"level": nosePositionLevel.toString()});
  }

  /// 设置嘴唇厚度，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// lipsThicknessLevel	嘴唇厚度级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setLipsThicknessLevel(double lipsThicknessLevel) {
    return _channel.invokeMethod(
        'setLipsThicknessLevel', {"level": lipsThicknessLevel.toString()});
  }

  /// 设置脸型 ，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 参数：
  ///
  /// faceBeautyLevel	脸型级别，取值范围0 - 9； 0表示关闭，1 - 9值越大，效果越明显。
  Future<void> setFaceBeautyLevel(double faceBeautyLevel) {
    return _channel.invokeMethod(
        'setFaceBeautyLevel', {"level": faceBeautyLevel.toString()});
  }

  /// 选择使用哪一款 AI 动效挂件 ，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 有些挂件本身会有声音特效，通过此 API 可以关闭这些特效播放时所带的声音效果。
  ///
  /// 参数：fullPath 特效文件夹的全路径。
  ///
  /// tmplPath
  Future<void> setMotionTmpl(String? fullPath) async {
    if (Platform.isIOS) {
      if (fullPath == null || fullPath.isEmpty) {
        return _channel.invokeMethod(
            'setMotionTmpl', {"tmplPath": null, "tmplName": null});
      }
      if (fullPath.endsWith("/")) {
        fullPath = fullPath.substring(0, fullPath.length - 1);
      }
      String tmplName = fullPath.substring(fullPath.lastIndexOf("/") + 1);
      String tmplPath =
          fullPath.substring(0, fullPath.length - tmplName.length);
      return _channel.invokeMethod(
          'setMotionTmpl', {"tmplPath": tmplPath, "tmplName": tmplName});
    }
    return _channel.invokeMethod('setMotionTmpl', {"tmplPath": fullPath});
  }

  /// 设置动效静音，该接口仅在 [企业版 SDK](https://cloud.tencent.com/document/product/647/32689#Enterprise) 中生效
  ///
  /// 有些挂件本身会有声音特效，通过此 API 可以关闭这些特效播放时所带的声音效果。
  ///
  /// 参数：
  ///
  /// motionMute YES：静音；NO：不静音。
  Future<void> setMotionMute(bool motionMute) {
    return _channel.invokeMethod('setMotionMute', {"motionMute": motionMute});
  }

  /// @nodoc
  /// 私有方法
  static Future<String> _copyAssetToLocal(String asset,
      {bool rewrite: false}) async {
    int lastIndex = asset.lastIndexOf("/");

    // 初始化目录
    final dir = await getApplicationDocumentsDirectory();
    Directory rootDir = new Directory(
        "${dir.path}${lastIndex != -1 ? "/${asset.substring(0, lastIndex)}" : ""}");
    if (!(await rootDir.exists())) {
      await rootDir.create(recursive: true);
    }

    // 初始化文件
    final file = new File(
        "${rootDir.path}${lastIndex == -1 ? asset : asset.substring(lastIndex)}");
    if (await file.exists() && rewrite) {
      file.deleteSync();
    }

    if (!(await file.exists())) {
      final soundData = await rootBundle.load(asset);
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }

    return file.path;
  }
}
