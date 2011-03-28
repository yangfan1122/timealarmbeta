package com.yf.alarm.controller
{
	import com.yf.alarm.Test;
	import com.yf.alarm.model.ModelAlarm;
	import com.yf.alarm.controller.count.TransferTime;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ControllerAlarm
	{
		private var _modelAlarm:ModelAlarm;
		private var timerShow:Timer=new Timer(1000); //显示计时
		private var timerShowCounter:int=0; //计时计数器
		private var timer:Timer=new Timer(500); //闪动频率
		private var timerCounter:int=0; //闪动标记
		
		
		public function ControllerAlarm(_ma:ModelAlarm)
		{
			_modelAlarm = _ma;
		}
		
		
		//计时
		public function cbSelect(_timeDelay:int):void
		{
			if (_timeDelay > 0)
			{
				_modelAlarm.appStatus = 1;
			}
			else if (_timeDelay < 0)
			{
				_modelAlarm.appStatus = 0;
			}
		}
		
		public function calculagraphCtrl(_timeDelay:int):void
		{
			timerShowCounter = _timeDelay;
			timerShow.addEventListener(TimerEvent.TIMER, timerShowHandler);
			timerShow.start();
		}
		private function timerShowHandler(event:TimerEvent):void
		{
			timerShowCounter-=1;
			_modelAlarm.timeText = TransferTime.transferTimeHandler(timerShowCounter * 1000);
			
			if (timerShowCounter == 0)
			{
				timerShow.stop();
				_modelAlarm.appStatus = 3;//闪动
			}
		}
			
		public function resetHandler():void //重置
		{
			timerShow.stop();
			timerShowCounter=0;
			
			_modelAlarm.appStatus = 0;
		}
		
		
		
		
		
		// //计时
		
		
		
		//闪动
		public function flashTimer():void
		{
			_modelAlarm.appStatus = 3;
			
			timer.addEventListener(TimerEvent.TIMER, timerCompleteHandler);
			timer.start();//闪动
		}
		private function timerCompleteHandler(event:TimerEvent):void
		{
			if (timerCounter == 1)
			{
				_modelAlarm.icon = 0;
			}
			else if (timerCounter == 0)
			{
				_modelAlarm.icon = 1;
			}
			timer.start();
		}
		
		// //闪动
		
		
		
	}
}