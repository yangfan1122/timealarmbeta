package com.yf.alarm.view
{
	import com.yf.alarm.Test;
	import com.yf.alarm.controller.ControllerAlarm;
	import com.yf.alarm.controller.count.TransferTime;
	import com.yf.alarm.model.ModelAlarm;
	import com.yf.alarm.statics.Statics;
	
	import component.Aboutme;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import spark.components.ComboBox;

	public class ViewAlarm extends Sprite
	{
		private var _thisApp:Object;
		private var _modelAlarm:ModelAlarm;
		private var _controllerAlarm:ControllerAlarm;
		
		private var timerCounter:int=0; //闪动标记
		
		[Embed(source='assets/alarm16x16.png')]
		private var icon:Class;
		
		[Embed(source='assets/alarm1_16x16.png')]
		private var icon1:Class;
		
		private var aboutme:Aboutme=new Aboutme();
		private var timeDelay:int=-1; //选定的延迟时间
		private var timer:Timer=new Timer(500); //闪动频率
		private var timerShow:Timer=new Timer(1000); //显示计时
		private var timerShowCounter:int=0; //计时计数器
		
		
		public function ViewAlarm(_this:Object, _modelalarm:ModelAlarm, _controlleralarm:ControllerAlarm)
		{
			_thisApp = _this;
			_modelAlarm = _modelalarm;
			_controllerAlarm = _controlleralarm;
			
			init();
		}
		
		private function init():void
		{
			styles();
			addListeners();
			addObjects();
		}
		private function styles():void
		{
			_thisApp.cb.dataProvider = new ArrayCollection(Statics.timeSelectCollectionData);
			
			initializationStyle();
			
		}
		private function addListeners():void
		{
			_thisApp.addEventListener(MouseEvent.MOUSE_DOWN, dragHandler); //窗口拖拽
			
			_thisApp.confirmBtn.addEventListener(MouseEvent.CLICK, confirmBtnHandler);
			_thisApp.resetBtn.addEventListener(MouseEvent.CLICK, resetBtnHandler);
			
			_thisApp.minBtn.addEventListener(MouseEvent.CLICK, minBtnHandler);
			_thisApp.closeBtn.addEventListener(MouseEvent.CLICK, closeBtnHandler);
			
			_thisApp.cb.addEventListener(Event.CLOSE, cbHandler);
			
			_modelAlarm.addEventListener(Statics.CHANGE_APPSTATUS, statusDispatcher);//app状态处理函数
			
			_modelAlarm.addEventListener(Statics.CHANGE_TIME_TEXT, timeTextHandler);//显示倒计时
			
			_thisApp.nativeWindow.addEventListener(Event.RESIZE, resizeHandler);//监听全屏变化
			
		}
		private function addObjects():void
		{
			addSysTrayIcon(); //添加任务栏图标
		}
		
		//styles
		private function initializationStyle():void //初始
		{
			_thisApp.confirmBtn.mouseEnabled=false;
			_thisApp.confirmBtn.alpha=.5;
			_thisApp.resetBtn.mouseEnabled=false;
			_thisApp.resetBtn.alpha=.5;
			
			_thisApp.countLabel.text=Statics.countTextInit;
			_thisApp.flashingLabel.text="";
			
			_thisApp.cb.enabled=true;
			_thisApp.cb.selectedIndex=0;
			
			_thisApp.nativeApplication.icon.bitmaps=[new icon()];
			timerCounter=0;
			
			if(_thisApp.picContainer.numElements>0)_thisApp.picContainer.removeElement(_thisApp.picContent);
		}
		private function preparativeStyle():void //准备
		{
			_thisApp.confirmBtn.mouseEnabled=true;
			_thisApp.confirmBtn.alpha=1;
			_thisApp.resetBtn.mouseEnabled=false;
			_thisApp.resetBtn.alpha=.5;
			
			_thisApp.countLabel.text=Statics.countTextInit;
			
			_thisApp.cb.enabled=true;
		}
		private function countStyle():void //计数
		{
			_thisApp.confirmBtn.mouseEnabled=false;
			_thisApp.confirmBtn.alpha=.5;
			_thisApp.resetBtn.mouseEnabled=true;
			_thisApp.resetBtn.alpha=1;
			
			_thisApp.cb.enabled=false;
		}
		private function flashingStyle():void //闪动
		{
			_thisApp.confirmBtn.mouseEnabled=false;
			_thisApp.confirmBtn.alpha=.5;
			_thisApp.resetBtn.mouseEnabled=true;
			_thisApp.resetBtn.alpha=1;
			
			_thisApp.countLabel.text=Statics.countTextInit;
			_thisApp.flashingLabel.text=Statics.flashingText;
			
			undockHandler();
			
			//全屏
			_thisApp.stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			_thisApp.nativeWindow.orderToFront();
		}
		private function chooseStyles(_status:int):void
		{
			switch(_status){
				case 0:
					initializationStyle();
					break;
				case 1:
					preparativeStyle();
					break;
				
				case 2:
					countStyle();
					break;
				
				case 3:
					flashingStyle();
					break;
				
				default:
					break;
			}
		}
		
		private function statusDispatcher(event:Event):void //app状态变化处理函数 
		{
			var _status:int = _modelAlarm.appStatus;
			switch(_status){
				case 0:
					
					break;
				case 1:
					
					break;
				
				case 2:
					
					break;
				
				case 3:
					flash();
					if(_thisApp.picContainer.numElements<1)_thisApp.picContainer.addElement(_thisApp.picContent);
					break;
				
				default:
					break;
			}
			chooseStyles(_status);
		}
		
		private function iconDispatcher(_ico:int):void //ico状态变化处理函数
		{
			//Test.a(_ico);
			switch(_ico){
				case 0:
					_thisApp.nativeApplication.icon.bitmaps=[new icon()];
					timerCounter=1;
					_thisApp.flashingLabel.text="";
					break;
				case 1:
					_thisApp.nativeApplication.icon.bitmaps=[new icon1()];
					timerCounter=0;
					_thisApp.flashingLabel.text=Statics.flashingText;
					break;
				default:
					break;
			}
		}
		
		
		// //styles
		
		//btns
		private function dragHandler(event:MouseEvent):void
		{
			_thisApp.stage.nativeWindow.startMove();
		}
		
		private function confirmBtnHandler(event:MouseEvent):void //确定按钮
		{
			if (timeDelay < 0)
			{
				Alert.show(Statics.selectTimeFailAlert);
			}
			else
			{
				calculagraph();
			}
			
			chooseStyles(_modelAlarm.appStatus);
		}
		private function resetBtnHandler(event:MouseEvent):void //重置按钮
		{
			/*
			timer.stop();//闪动
			
			timerShow.stop();
			timerShowCounter=0;
			
			//取消全屏
			stage.displayState=StageDisplayState.NORMAL;
			
			initializationStyle();
			*/
			
			_controllerAlarm.resetHandler();
		}
		private function minBtnHandler(event:MouseEvent):void //最小化按钮
		{
			_thisApp.flashingLabel.scaleX=_thisApp.flashingLabel.scaleY=1;
			
			_thisApp.minimize();
			_thisApp.nativeWindow.visible=false;
			
			if(_thisApp.picContainer.numElements>0)_thisApp.picContainer.removeElement(_thisApp.picContent);
		}
		private function closeBtnHandler(event:MouseEvent):void //关闭按钮
		{
			exitHandler();
		}
		
		
		
		// //btns
		

		
		//计时	
		private function cbHandler(event:Event):void //下拉框选定
		{
			timeDelay = ComboBox(event.target).selectedItem.data; //秒
			_controllerAlarm.cbSelect(timeDelay);// --> C
		}
		
		private function calculagraph():void //计时
		{
			/*
			timerShowCounter=timeDelay;
			timerShow.addEventListener(TimerEvent.TIMER, timerShowHandler);
			timerShow.start();
			*/
			_controllerAlarm.calculagraphCtrl(timeDelay);
		}
		/*
		private function timerShowHandler(event:TimerEvent):void
		{
			timerShowCounter-=1;
			_thisApp.countLabel.text=TransferTime.transferTimeHandler(timerShowCounter * 1000);
			
			if (timerShowCounter == 0)
			{
				timerShow.stop();
				flash(); //开始提醒
			}
		}
		*/
		private function timeTextHandler(event:Event):void
		{
			_thisApp.countLabel.text = _modelAlarm.timeText;
		}
		
		// //计时
		
		
		
		
		//闪动
		private function flash():void
		{
			/*
			flashingStyle();
			
			timer.addEventListener(TimerEvent.TIMER, timerCompleteHandler);
			timer.start();//闪动
			
			if(_thisApp.picContainer.numElements>0)_thisApp.picContainer.removeElement(_thisApp.picContent);
			*/
			
			
			
			_modelAlarm.addEventListener(Statics.CHANGE_ICON, iconHandler);
			//_modelAlarm.removeEventListener(Statics.CHANGE_ICON, iconHandler);
			_controllerAlarm.flashTimer();
			
		}
		private function iconHandler(event:Event):void
		{
			iconDispatcher(_modelAlarm.icon);
		}
		private function resizeHandler(event:Event):void //全屏变化处理
		{
			//窗口宽，判断是否全屏用
			var screenWidth:int;
			for each (var screen:Screen in Screen.screens)screenWidth = screen.bounds.width;
				
			if (this.stage.nativeWindow.width == screenWidth) //全屏
			{ 
				_thisApp.flashingLabel.scaleX = _thisApp.flashingLabel.scaleY=5;
				_thisApp.nativeWindow.orderToFront();
			}
			else //非全屏
			{ 
				_thisApp.flashingLabel.scaleX=_thisApp.flashingLabel.scaleY=1;
			}
			
		}
		
		// //闪动
		
		
		
		//系统任务栏
		private function addSysTrayIcon():void
		{
			_thisApp.nativeApplication.icon.bitmaps=[new icon()];
			if (NativeApplication.supportsSystemTrayIcon)
			{
				var sti:SystemTrayIcon=SystemTrayIcon(_thisApp.nativeApplication.icon);
				
				sti.menu=createSysTrayMenu();
				sti.addEventListener(MouseEvent.CLICK, restoreFromSysTrayHandler); //左键点击系统任务栏图标
				sti.tooltip=Statics.timeAlarmTitle;
			}
		}
		private function createSysTrayMenu():NativeMenu
		{
			var menu:NativeMenu=new NativeMenu();
			var labels:Array=[Statics.menuItemOpen, Statics.menuItemAbout, "", Statics.menuItemExit];
			var names:Array=[Statics.menuOpen, Statics.menuAbout, Statics.menuSeparator, Statics.menuExit];
			for (var i:int=0; i < labels.length; i++)
			{
				//如果标签为空的话，就认为是分隔符
				var menuItem:NativeMenuItem=new NativeMenuItem(labels[i], labels[i] == "");
				menuItem.name=names[i];
				menuItem.addEventListener(Event.SELECT, sysTrayMenuHandler); //菜单处理事件
				menu.addItem(menuItem);
			}
			
			return menu;
		}
		
		private function restoreFromSysTrayHandler(event:MouseEvent):void //系统任务栏最大最小化
		{
			if (_thisApp.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED)
			{
				undockHandler();
			}
			else
			{
				_thisApp.minimize();
				_thisApp.nativeWindow.visible=false;
				
				if(_thisApp.picContainer.numElements>0)_thisApp.picContainer.removeElement(_thisApp.picContent);
			}
		}
		private function sysTrayMenuHandler(event:Event):void
		{
			switch (event.target.name)
			{
				case Statics.menuOpen: //打开菜单
					undockHandler();
					break;
				case Statics.menuAbout: //关于
					aboutMeHandler();
					break;
				case Statics.menuExit: //退出菜单
					exitHandler();
					break;
			}
			
		}
		
		
		
		private function undockHandler():void //从系统托盘恢复到任务栏
		{
			_thisApp.nativeWindow.visible=true;
			_thisApp.nativeWindow.orderToFront();
			_thisApp.activate();
		}
		
		private function exitHandler():void
		{
			_thisApp.exit();
		}
		
		// //系统任务栏
		
		
		
		
		//关于
		private function aboutMeHandler():void
		{
			undockHandler();
			
			aboutme.addEventListener(Statics.CLOSE_WINDOW, closeAboutHandler);
			_thisApp.addElement(aboutme);
		}
		
		private function closeAboutHandler(event:Event):void
		{
			aboutme.removeEventListener(Statics.CLOSE_WINDOW, closeAboutHandler);
			_thisApp.removeElement(aboutme);
		}
		
		// //关于
		
		
		
		
		
		
		
		
		
		
		
		
	}
}