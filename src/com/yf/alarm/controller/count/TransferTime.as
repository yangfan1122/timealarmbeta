package com.yf.alarm.controller.count
{
	public class TransferTime
	{ //秒转分

		static public function transferTimeHandler(__sec:Number):String
		{ //__sec 毫秒
			var min:Number;
			var sec:Number;
			var minStr:String;
			var secStr:String;
			var _sec:Number;

			_sec=Math.floor(__sec / 1000);

			min=Math.floor(_sec / 60);
			sec=_sec % 60;

			if (min < 10)
			{
				minStr="0" + min;
			}
			else
			{
				minStr=min.toString();
			}

			if (sec < 10)
			{
				secStr="0" + sec;
			}
			else
			{
				secStr=sec.toString();
			}

			return minStr + ":" + secStr;
		}




	}
}


