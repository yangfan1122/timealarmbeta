package com.yf.alarm.model
{
	import com.yf.alarm.Test;
	import com.yf.alarm.statics.Statics;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ModelAlarm extends EventDispatcher
	{
		/**
		 * 四个状态:
		 * 0初始，1准备，2计数，3闪动
		 */ 
		private var _appStatus:int;
		
		private var _timeText:String;
		private var _icon:int;
		private var _startAtLogin:Boolean;//启动否
		private var _saveSuccess:Boolean;//保存存成功
		private var _selectedIndex:int;//下拉菜单索引
		
		public function ModelAlarm()
		{
		}
		
		private var _viewInit:Boolean = true;
		public function set viewInit(set:Boolean):void {
			_viewInit = set;
			this.dispatchEvent(new Event(Statics.VIEW_INIT));
		}
			
		public function get selectedIndex():int {
			return this._selectedIndex;
		}
		public function set selectedIndex(index:int):void {
			this._selectedIndex = index;
			dispatchEvent(new Event(Statics.STORE_INDEX));
		}

		
		//显示倒计时
		public function get timeText():String
		{
			return _timeText;
		}
		public function set timeText(_tt:String):void
		{
			_timeText = _tt;
			dispatchEvent(new Event(Statics.CHANGE_TIME_TEXT));
		}
		
		
		//app状态
		public function get appStatus():int
		{
			return _appStatus;
		}
		public function set appStatus(_status:int):void
		{
			this._appStatus = _status;
			dispatchEvent(new Event(Statics.CHANGE_APPSTATUS));
		}
		
		
		//图标闪动
		public function get icon():int
		{
			return _icon;
		}
		public function set icon(_ico:int):void
		{
			_icon = _ico;
			dispatchEvent(new Event(Statics.CHANGE_ICON));
		}
		
		
		//开机启动
		public function get startAtLogin():Boolean
		{
			return _startAtLogin;
		}
		public function set startAtLogin(_sal:Boolean):void
		{
			_startAtLogin = _sal;
		}
		public function get saveSuccess():Boolean
		{
			return _saveSuccess;	
		}
		public function set saveSuccess(_ss:Boolean):void
		{
			_saveSuccess = _ss;
			dispatchEvent(new Event(Statics.SAVE_SETTING_SUCCESS));
		}
		
		
		
		
		
		
	}
}