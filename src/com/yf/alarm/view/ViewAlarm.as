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
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import spark.components.CheckBox;
	import spark.components.DropDownList;

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

		
		public function ViewAlarm(_this:Object, _modelalarm:ModelAlarm, _controlleralarm:ControllerAlarm)
		{
			_thisApp = _this;
			_modelAlarm = _modelalarm;
			_controllerAlarm = _controlleralarm;
			
			init();
		}
		
		private function init():void
		{
			addListeners();
			styles();
			addObjects();
		}
		private function styles():void
		{
			//窗口初始位置
			var screenWidth:int;
			var screenHeight:int;
			for each (var screen:Screen in Screen.screens)
			{
				screenWidth=screen.bounds.width;
				screenHeight=screen.bounds.height;
			}
			_thisApp.nativeWindow.x=screenWidth * Statics.positionPer;
			_thisApp.nativeWindow.y=(screenHeight - _thisApp.nativeWindow.height) / 2;
			
			//系统托盘、最小化按钮、关闭按钮提示
			_thisApp.mainPanelTitle.title = Statics.timeAlarmTitle;
			_thisApp.minBtn.toolTip = Statics.minBtnToolTip;
			_thisApp.closeBtn.toolTip = Statics.closenBtnToolTip;
			
			//下拉菜单选项
			_thisApp.cb.dataProvider = new ArrayCollection(Statics.timeSelectCollectionData);
			
			//读取是否设置开机启动
			_thisApp.startAtLoginCB.selected = NativeApplication.nativeApplication.startAtLogin;
			
			//初始化样式
			initializationStyle();
			
		}
		private function addListeners():void
		{
			_thisApp.addEventListener(MouseEvent.MOUSE_DOWN, dragHandler); //窗口拖拽
			
			_thisApp.minBtn.addEventListener(MouseEvent.CLICK, minBtnHandler);//最小化按钮
			_thisApp.closeBtn.addEventListener(MouseEvent.CLICK, closeBtnHandler);//关闭按钮
			_thisApp.startAtLoginCB.addEventListener(MouseEvent.CLICK, startAtLoginCBClickHandler);//开机启动
			_thisApp.cb.addEventListener(Event.CLOSE, cbHandler);//菜单
			
			_modelAlarm.addEventListener(Statics.CHANGE_APPSTATUS, statusDispatcher);//app状态处理函数
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
			_thisApp.cb.selectedIndex=3;//默认选中
			_thisApp.cb.dispatchEvent(new Event(Event.CLOSE));
			
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
			
			_thisApp.stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;//全屏
		}
		
		/**
		 * 四个状态:
		 * 0初始，1准备，2计数，3闪动
		 */ 
		/**
		 * 也可以根据四个状态返回四个函数，将相应操作放入四个函数中。
		 */
		private function statusDispatcher(event:Event):void //app状态变化处理函数 
		{
			var _status:int = _modelAlarm.appStatus;
			switch(_status){
				case 0:
					_thisApp.resetBtn.removeEventListener(MouseEvent.CLICK, resetBtnHandler);
					_thisApp.nativeWindow.removeEventListener(Event.RESIZE, resizeHandler);//监听全屏变化
					_thisApp.cb.addEventListener(Event.CLOSE, cbHandler);
					
					initializationStyle();
					break;
				case 1:
					_thisApp.confirmBtn.addEventListener(MouseEvent.CLICK, confirmBtnHandler);
					
					preparativeStyle();
					break;
				
				case 2:
					_thisApp.confirmBtn.removeEventListener(MouseEvent.CLICK, confirmBtnHandler);
					_thisApp.cb.removeEventListener(Event.CLOSE, cbHandler);
					_thisApp.resetBtn.addEventListener(MouseEvent.CLICK, resetBtnHandler);
					_modelAlarm.addEventListener(Statics.CHANGE_TIME_TEXT, timeTextHandler);//显示倒计时
					
					countStyle();
					break;
				
				case 3:
					_modelAlarm.removeEventListener(Statics.CHANGE_TIME_TEXT, timeTextHandler);//显示倒计时
					_thisApp.nativeWindow.addEventListener(Event.RESIZE, resizeHandler);//监听全屏变化
					
					flash();
					
					flashingStyle();
					break;
				
				default:
					break;
			}
		}
		
		private function iconDispatcher(_ico:int):void //ico状态变化处理函数
		{
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
		private function dragHandler(event:MouseEvent):void //拖拽
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
				minHandler();
			}
		}
		private function resetBtnHandler(event:MouseEvent):void //重置按钮
		{
			_thisApp.stage.displayState=StageDisplayState.NORMAL;//取消全屏
			_modelAlarm.removeEventListener(Statics.CHANGE_ICON, iconHandler);
			_controllerAlarm.resetHandler();
		}
		private function minBtnHandler(event:MouseEvent):void //最小化按钮
		{
			minHandler();
		}
		private function minHandler():void
		{
			_thisApp.flashingLabel.scaleX = 1;
			_thisApp.flashingLabel.scaleY = 1;
			
			_thisApp.minimize();
			_thisApp.nativeWindow.visible=false;
		}
		private function closeBtnHandler(event:MouseEvent):void //关闭按钮
		{
			exitHandler();
		}

		// //btns
		

		
		//计时	
		private function cbHandler(event:Event):void //下拉框选定
		{
			timeDelay = DropDownList(event.target).selectedItem.data; //秒
			_controllerAlarm.cbSelect(timeDelay);// --> C
		}
		
		private function calculagraph():void //计时
		{
			_controllerAlarm.calculagraphCtrl(timeDelay);
		}
		private function timeTextHandler(event:Event):void
		{
			_thisApp.countLabel.text = _modelAlarm.timeText;
		}
		
		// //计时
		
		
		
		
		//闪动
		private function flash():void
		{
			_modelAlarm.addEventListener(Statics.CHANGE_ICON, iconHandler);
			_controllerAlarm.flashTimer();
		}
		private function iconHandler(event:Event):void
		{
			iconDispatcher(_modelAlarm.icon);
		}
		private function resizeHandler(event:Event):void //全屏变化处理
		{
			//窗口宽，判断是否全屏用
			if ((event as NativeWindowBoundsEvent).afterBounds.width > 200) //全屏
			{ 
				_thisApp.flashingLabel.scaleX = 5;
				_thisApp.flashingLabel.scaleY = 5;
				_thisApp.nativeWindow.orderToFront();
				_thisApp.removeEventListener(MouseEvent.MOUSE_DOWN, dragHandler); //窗口拖拽
				
				if(_thisApp.picContainer.numElements<1)_thisApp.picContainer.addElement(_thisApp.picContent);
			}
			else //非全屏
			{ 
				_thisApp.flashingLabel.scaleX = 1;
				_thisApp.flashingLabel.scaleY = 1;
				_thisApp.addEventListener(MouseEvent.MOUSE_DOWN, dragHandler); //窗口拖拽
				
				if(_thisApp.picContainer.numElements>0)_thisApp.picContainer.removeElement(_thisApp.picContent);
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
		
		
		//setting
		//开机启动
		private function startAtLoginCBClickHandler(event:MouseEvent):void //点击CheckBox
		{
			_modelAlarm.addEventListener(Statics.SAVE_SETTING_SUCCESS, saveSettingSuccessHandler);
			
			if (CheckBox(event.target).selected)
			{
				_controllerAlarm.startAtLoginCtrl(true);
			}
			else
			{
				_controllerAlarm.startAtLoginCtrl(false);
			}
		}
		private function saveSettingSuccessHandler(event:Event):void //保存结果
		{
			var tmp:Boolean = _modelAlarm.saveSuccess;
			if(tmp) 
			{
				//保存成功
				setStartAtLogin();
			}
			else 
			{
				//保存失败
				Alert.show(Statics.setttingSaveFail);
			}
			
			_modelAlarm.removeEventListener(Statics.SAVE_SETTING_SUCCESS, saveSettingSuccessHandler);
		
		}
		private function setStartAtLogin():void //设置开机启动
		{
			if (_modelAlarm.startAtLogin)
			{
				NativeApplication.nativeApplication.startAtLogin = true;
			}
			else
			{
				NativeApplication.nativeApplication.startAtLogin = false;
			}
		}
		// //setting
		
		
	}
}