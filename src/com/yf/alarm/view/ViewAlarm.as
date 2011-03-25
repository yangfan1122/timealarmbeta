package com.yf.alarm.view
{
	import com.yf.alarm.controller.ControllerAlarm;
	import com.yf.alarm.model.ModelAlarm;
	import com.yf.alarm.Test;
	import com.yf.alarm.statics.Statics;
	
	import flash.display.Sprite;
	import mx.collections.ArrayCollection;

	public class ViewAlarm extends Sprite
	{
		private var _thisApp:Object;
		private var _modelAlarm:ModelAlarm;
		private var _controllerAlarm:ControllerAlarm;
		
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
			_thisApp.cb.selectedIndex = 0;

		}
		private function addListeners():void
		{
			
		}
		private function addObjects():void
		{
			
		}
		
		
		
		
		
	}
}