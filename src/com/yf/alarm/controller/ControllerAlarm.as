package com.yf.alarm.controller
{
	import com.yf.alarm.Test;
	import com.yf.alarm.model.ModelAlarm;
	import com.yf.alarm.controller.count.TransferTime;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class ControllerAlarm
	{
		private var _modelAlarm:ModelAlarm;
		private var timerShow:Timer=new Timer(1000); //显示计时
		private var timerShowCounter:int=0; //计时计数器
		private var timer:Timer=new Timer(500); //闪动频率
		private var timerCounter:int=0; //闪动标记
		private var settingShareObject:SharedObject=SharedObject.getLocal("user-setting"); //保存用户设置
		
		
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
			_modelAlarm.appStatus = 2;//计数
			
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
				timerShow.removeEventListener(TimerEvent.TIMER, timerShowHandler);
				_modelAlarm.appStatus = 3;//闪动
			}
		}
			
		public function resetHandler():void //重置
		{
			timer.stop();
			
			timerShow.stop();
			timerShowCounter=0;
			
			_modelAlarm.appStatus = 0;
			
			timer.removeEventListener(TimerEvent.TIMER, timerCompleteHandler);
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
				//Alert.show("Error...Could not write SharedObject to disk\n");
				//Test.a("Error...Could not write SharedObject to disk\n");
				_modelAlarm.saveSuccess = false;
			}
			if (flushStatus != null)
			{
				//Test.a("flushStatus="+flushStatus);
				switch (flushStatus)
				{
					case SharedObjectFlushStatus.PENDING:
						//Alert.show("Requesting permission to save object...\n");
						settingShareObject.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						//Alert.show("Value flushed to disk.\n");
						sendSetting();
						break;
				}
			}
			
		}
		
		private function onFlushStatus(event:NetStatusEvent):void
		{
			//Alert.show("User closed permission dialog...\n");
			switch (event.info.code)
			{
				case "SharedObject.Flush.Success":
					//Test.a("User granted permission -- value saved.\n");
					sendSetting();
					break;
				case "SharedObject.Flush.Failed":
					//Test.a("User denied permission -- value not saved.\n");
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