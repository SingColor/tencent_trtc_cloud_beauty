
//
//  BeautyManager.swift
//  tencent_trtc_cloud
//
//  Created by 林智 on 2020/12/24.
//

import Foundation
// import TXLiteAVSDK_TRTC
import TXLiteAVSDK_Enterprise

class BeautyManager {
	private var tRegistrar: FlutterPluginRegistrar?;
    init(registrar: FlutterPluginRegistrar?){
        tRegistrar = registrar
    }
    
	private var txBeautyManager: TXBeautyManager = TRTCCloud.sharedInstance().getBeautyManager();
	
	/**
	*设置美颜licenseKey
	*/
	public func setLicence(call: FlutterMethodCall, result: @escaping FlutterResult){
		if let licenceUrl = CommonUtils.getParamByKey(call: call, result: result, param: "licenceUrl") as? String,
			let licenseKey = CommonUtils.getParamByKey(call: call, result: result, param: "licenseKey") as? String{
            TXLiveBase.setLicenceURL(licenceUrl, key: licenseKey);
			result(nil);
		}
	}

    /**
     *获取美颜Licence信息
     */
    public func getLicenceInfo(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(TXLiveBase.getLicenceInfo())
    }
	/**
	* 设置美颜（磨皮）算法
	* TXBeautyStyleSmooth, TXBeautyStyleNature, TXBeautyStylePitu
	*/
	public func setBeautyStyle(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let beautyStyle = CommonUtils.getParamByKey(call: call, result: result, param: "beautyStyle") as? Int {
			txBeautyManager.setBeautyStyle(TXBeautyStyle(rawValue: beautyStyle)!);
			result(nil);
		}
	}
	
	/**
	* 设置美颜级别
	*/
	public func setBeautyLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let beautyLevel = CommonUtils.getParamByKey(call: call, result: result, param: "beautyLevel") as? Int {
			txBeautyManager.setBeautyLevel(Float(beautyLevel));
			result(nil);
		}
	}
	
	/**
	* 设置美白级别
	*/
	public func setWhitenessLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let whitenessLevel = CommonUtils.getParamByKey(call: call, result: result, param: "whitenessLevel") as? Int {
			txBeautyManager.setWhitenessLevel(Float(whitenessLevel));
			result(nil);
		}
	}
	
	/**
	* 开启清晰度增强
	*/
	public func enableSharpnessEnhancement(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let enable = CommonUtils.getParamByKey(call: call, result: result, param: "enable") as? Bool {
			txBeautyManager.enableSharpnessEnhancement(enable);
			result(nil);
		}
	}
	
	/**
	* 设置红润级别
	*/
	public func setRuddyLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let ruddyLevel = CommonUtils.getParamByKey(call: call, result: result, param: "ruddyLevel") as? Float {
			txBeautyManager.setRuddyLevel(ruddyLevel);
			result(nil);
		}
	}
	
	/**
	* 设置指定素材滤镜特效
	* image 指定素材，即颜色查找表图片。必须使用 png 格式
	*/
	public func setFilter(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let imageUrl = CommonUtils.getParamByKey(call: call, result: result, param: "imageUrl") as? String,
		   let type = CommonUtils.getParamByKey(call: call, result: result, param: "type") as? String {
			
			if type == "local" {
				let img = UIImage(contentsOfFile: imageUrl)!;
				txBeautyManager.setFilter(img);
			} else {
				let queue = DispatchQueue(label: "setFilter")
				queue.async {
					let url: NSURL = NSURL(string: imageUrl)!
					let data: NSData = NSData(contentsOf: url as URL)!
					let img = UIImage(data: data as Data, scale: 1)!
					self.txBeautyManager.setFilter(img);
				}
			}
			
			result(nil);
		}
	}
	
	/**
	* 设置滤镜浓度
	*/
	public func setFilterStrength(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let strength = CommonUtils.getParamByKey(call: call, result: result, param: "strength") as? String {
			txBeautyManager.setFilterStrength(Float(strength)!);
			result(nil);
		}
	}
	
	/**
	* 设置绿幕背景视频，该接口仅在 企业版 SDK 中生效
	*/
	public func setGreenScreenFile(call: FlutterMethodCall, result: @escaping FlutterResult){
		let file = CommonUtils.getParamByKey(call: call, result: result, param: "file") as? String;
        txBeautyManager.setGreenScreenFile(file);
        result(nil);
	}
	/**
	* TODO: 设置大眼级别，该接口仅在 企业版 SDK 中生效
	*/
	public func setEyeScaleLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setEyeScaleLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置瘦脸级别，该接口仅在 企业版 SDK 中生效
	*/
	public func setFaceSlimLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
            let val = Float(level)!;
			txBeautyManager.setFaceSlimLevel(val);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置 V 脸级别，该接口仅在 企业版 SDK 中生效
	*/
	public func setFaceVLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setFaceVLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置下巴拉伸或收缩，该接口仅在 企业版 SDK 中生效
	*/
	public func setChinLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setChinLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置短脸级别，该接口仅在 企业版 SDK 中生效
	*/
	public func setFaceShortLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setFaceShortLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置瘦鼻级别，该接口仅在 企业版 SDK 中生效
	*/
	public func setNoseSlimLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setNoseSlimLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO：设置亮眼 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setEyeLightenLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setEyeLightenLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO：设置白牙 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setToothWhitenLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setToothWhitenLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置祛皱 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setWrinkleRemoveLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setWrinkleRemoveLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置祛眼袋 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setPounchRemoveLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setPounchRemoveLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置法令纹 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setSmileLinesRemoveLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setSmileLinesRemoveLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置发际线 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setForeheadLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setForeheadLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置眼距 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setEyeDistanceLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setEyeDistanceLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置眼角 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setEyeAngleLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setEyeAngleLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置嘴型 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setMouthShapeLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setMouthShapeLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置鼻翼 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setNoseWingLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setNoseWingLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置鼻子位置 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setNosePositionLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setNosePositionLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 设置嘴唇厚度 ，该接口仅在 企业版 SDK 中生效
	*/
	public func setLipsThicknessLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setLipsThicknessLevel(Float(level)!);
			result(nil);
		}
	}
	
	/**
	* TODO: 选择 AI 动效挂件，该接口仅在 企业版 SDK 中生效
	*/
	public func setMotionTmpl(call: FlutterMethodCall, result: @escaping FlutterResult){
		if let tmplPath = CommonUtils.getParamByKey(call: call, result: result, param: "tmplPath") as? String,
			let tmplName = CommonUtils.getParamByKey(call: call, result: result, param: "tmplName") as? String{
            txBeautyManager.setMotionTmpl(tmplName,inDir:tmplPath);
			result(nil);
		}else{
			txBeautyManager.setMotionTmpl(nil,inDir:nil);
			result(nil);
		}
	}

	/**
	* TODO: 设置动效静音，该接口仅在 企业版 SDK 中生效
	*/
	public func setMotionMute(call: FlutterMethodCall, result: @escaping FlutterResult){
		if let motionMute = CommonUtils.getParamByKey(call: call, result: result, param: "motionMute") as? Bool {
			txBeautyManager.setMotionMute(motionMute);
			result(nil);
		}
	}

	/**
	* TODO: 设置脸型，该接口仅在 企业版 SDK 中生效
	*/
	public func setFaceBeautyLevel(call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let level = CommonUtils.getParamByKey(call: call, result: result, param: "level") as? String {
			txBeautyManager.setFaceBeautyLevel(Float(level)!);
			result(nil);
		}
	}
}
