package com.yf.alarm.controller.count
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class Utils
	{
		public function Utils()
		{
		}
		
		private static var countdownTimer : Timer = new Timer(300);
		private static var timestamp : Number = 0;
		private static var countdowns : Array = [];
		private static var countdownSeconds : Dictionary = new Dictionary();
		
		public static function addCountdown(method : Function, second : Number) : void {
			var index:int = countdowns.indexOf(method);
			if(index >= 0){
				return;
			}
			if(!countdownTimer.hasEventListener(TimerEvent.TIMER)){
				countdownTimer.addEventListener(TimerEvent.TIMER, countDownHandler);
			}
			if(!countdownTimer.running){
				timestamp = getTimer();
				countdownTimer.start();
			}
			countdowns.push(method);
			countdownSeconds[method] = second;
		}
		
		public static function removeCountdown(method : Function) : void {
			if (method == null) {
				return;
			}
			var index:int = countdowns.indexOf(method);
			if (index >= 0) {
				countdowns.splice(index, 1);
				countdownSeconds[method] = null;
				delete countdownSeconds[method];
			}
			if(countdowns.length == 0){
				countdownTimer.stop();
			}
		}
		
		private static function countDownHandler(e : TimerEvent) : void {
			var remain : Number = (getTimer() - timestamp) * 0.001;
			timestamp = getTimer();
			for(var i : int = 0; i < countdowns.length; i++){
				var func : Function = countdowns[i];
				var second : Number = countdownSeconds[func];
				second -= remain;
				func(second);
				countdownSeconds[func] = second;
				
			}
		}
	}
}