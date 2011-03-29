import com.yf.alarm.controller.ControllerAlarm;
import com.yf.alarm.model.ModelAlarm;
import com.yf.alarm.view.ViewAlarm;

private var modelAlarm:ModelAlarm;
private var viewAlarm:ViewAlarm;
private var controllerAlarm:ControllerAlarm;

private function Main():void
{
	modelAlarm = new ModelAlarm();
	controllerAlarm = new ControllerAlarm(modelAlarm);
	viewAlarm = new ViewAlarm(this, modelAlarm, controllerAlarm);
}
