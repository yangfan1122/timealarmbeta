package com.yf.alarm.controller
{
	import com.yf.alarm.Test;
	import com.yf.alarm.controller.count.TransferTime;
	import com.yf.alarm.controller.count.Utils;
	import com.yf.alarm.model.ModelAlarm;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Timer;

	public class ControllerAlarm
	{
		private var _modelAlarm:ModelAlarm;
		private var timer:Timer=new Timer(500); //闪动频率
		private var timerCounter:int=0; //闪动标记
		private var settingShareObject:SharedObject=SharedObject.getLocal("user-setting"); //保存用户设置
		
		public function ControllerAlarm(_ma:ModelAlarm)
		{
			_modelAlarm = _ma;			
		}
		
		public function init():void {
			this._modelAlarm.viewInit = true;
			if(settingShareObject.data.hasOwnProperty("selectedIndex")) {
				_modelAlarm.selectedIndex = settingShareObject.data.selectedIndex;
			} else {
				_modelAlarm.selectedIndex = 3;
			}
		}
		
		/**
		 * 保存下拉菜单索引 
		 * @param index
		 * 
		 */		
		public function storeSelectedIndex(index:int):void {
			settingShareObject.data.selectedIndex = index;
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
			_modelAlarm.appStatus = 2;//计数
			Utils.addCountdown(countHandler, _timeDelay);
		}

		private function countHandler(_seconds:Number):void
		{
			_modelAlarm.timeText = TransferTime.transferTimeHandler(_seconds*1000);
			
			if (_seconds < 0)
			{
				Utils.removeCountdown(countHandler);
				_modelAlarm.appStatus = 3;//闪动
			}
		}
		
		public function resetHandler():void //重置
		{
			Utils.removeCountdown(countHandler);
			_modelAlarm.appStatus = 0;
		}
		
		// //计时
		
		
		
		//闪动
		public function flashTimer():void
		{
			timer.addEventListener(TimerEvent.TIMER, timerCompleteHandler);
			timer.start();//闪动
		}
		private function timerCompleteHandler(event:TimerEvent):void
		{
			if (timerCounter == 1)
			{
				_modelAlarm.icon = 0;
				timerCounter = 0;
			}
			else if (timerCounter == 0)
			{
				_modelAlarm.icon = 1;
				timerCounter = 1;
			}
			timer.start();
		}
		
		// //闪动
		
		
		
		
		//开机启动
		public function startAtLoginCtrl(_startLogin:Boolean):void
		{
			settingShareObject.data.userSetting_startAtLogin = _startLogin;
			saveSetting();
		}
		private function saveSetting():void
		{
			var flushStatus:String = null;
			try
			{
				flushStatus = settingShareObject.flush(10000);
			}
			catch (error:Error)
			{
				_modelAlarm.saveSuccess = false;
			}
			if (flushStatus != null)
			{
				switch (flushStatus)
				{
					case SharedObjectFlushStatus.PENDING:
						settingShareObject.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						sendSetting();
						break;
				}
			}
			
		}
		
		private function onFlushStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case "SharedObject.Flush.Success":
					sendSetting();
					break;
				case "SharedObject.Flush.Failed":
					_modelAlarm.saveSuccess = false;
					break;
			}
			
			settingShareObject.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
		}
		
		private function sendSetting():void //保存设置成功，发送是否启动
		{
			_modelAlarm.startAtLogin = settingShareObject.data.userSetting_startAtLogin;
			_modelAlarm.saveSuccess = true;
		}
		
		// //开机启动
		
		
		
		
	}
}