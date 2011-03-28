package com.yf.alarm.model
{
	import com.yf.alarm.Test;
	import com.yf.alarm.statics.Statics;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ModelAlarm extends EventDispatcher
	{
		private var _minute:String;
		private var _second:String;
		
		/**
		 * 四个状态:
		 * 0初始，1准备，2计数，3闪动
		 */ 
		private var _appStatus:int;
		
		private var _timeText:String;
		private var _icon:int;
		
		public function ModelAlarm()
		{
		}
		
		//倒计时 ??
		public function get minute():String
		{
			return _minute;
		}
		public function set minute(_min:String):void
		{
			_minute = _min;
			dispatchEvent(new Event(Statics.CHANGE_MINUTE));
		}
		
		public function get second():String
		{
			return _second;
		}
		public function set second(_sec:String):void
		{
			_second = _sec;
			dispatchEvent(new Event(Statics.CHANGE_SECOND));
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
		}
		
		
		
		
		
	}
}