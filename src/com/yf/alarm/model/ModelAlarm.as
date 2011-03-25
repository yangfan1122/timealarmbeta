package com.yf.alarm.model
{
	import com.yf.alarm.statics.Statics;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ModelAlarm extends EventDispatcher
	{
		private var _minute:String;
		private var _second:String;
		
		public function ModelAlarm()
		{
		}
		
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
		
	}
}