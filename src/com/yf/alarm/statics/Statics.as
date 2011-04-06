package com.yf.alarm.statics
{
	import mx.collections.ArrayCollection;
	
	public class Statics
	{
		//events
		static public const CHANGE_MINUTE:String = "change_minute";
		static public const CHANGE_SECOND:String = "change_second";
		static public const CHANGE_APPSTATUS:String = "change_appstatus";
		static public const CHANGE_TIME_TEXT:String = "change_time_text";
		static public const CHANGE_ICON:String = "change_icon";
		static public const SAVE_SETTING_SUCCESS:String = "save_setting_success";
		
		static public const CLOSE_WINDOW:String = "CLOSE_WINDOW";
		
		
		//下拉菜单
		static public const timeSelectCollectionData:Array = [
			{label: "选择", data: -1},
			{label: "3 秒", data: 3},
			{label: "15 分钟", data: 900}, 
			{label: "30 分钟", data: 1800}, 
			{label: "60 分钟", data: 3600}
		];
		
		
		//计时 提示
		static public const countTextInit:String = "00:00";
		static public const flashingText:String = "该活动活动脖子啦~~";
		static public const selectTimeFailAlert:String = "选择时间错误!";
		
		//显示名称
		static public const timeAlarmTitle:String = "Time Alarm Beta";//程序名称
		
		
		//systray menu
		static public const menuItemOpen:String = "打开";
		static public const menuItemExit:String = "退出";
		static public const menuItemAbout:String = "关于";
		
		static public const menuOpen:String = "menu_open";
		static public const menuExit:String = "menu_exit";
		static public const menuAbout:String = "menu_about";
		static public const menuSeparator:String = "menu_separator";
		
		//about me
		static public const aboutMain:String = "关于Time Alarm 0.1.0.1103_beta";
		static public const aboutMail:String = "yangfan1122@gmail.com";
		
		//displayObjects
		static public const positionPer:Number = 0.8;//窗口x位置
		static public const minBtnToolTip:String = "最小化";
		static public const closenBtnToolTip:String = "退出";
		
		//setting
		static public const setttingSaveFail:String = "设置失败!";//保存失败
		
		

		
		
		
		
		
		
	}
}