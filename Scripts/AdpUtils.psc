Scriptname AdpUtils 

import debug
import utility
import math

Function adpDebug(String msg, String prefix="*", Bool enabled=True) global
	debug.traceConditional(prefix + msg, enabled)
endFunction

Function delay(Float seconds) global
	utility.wait(seconds)
endFunction

Float Function clampFloatValue(Float value, Float max, Float min) global
	IF value >= max
		value = max
	ELSEIF value <= min
		value = min		
	ENDIF
	return value 
endFunction 

Bool Function absFloatsEqual(Float valueOne, Float valueTwo) global
	return math.abs(valueOne as Int) == math.abs(valueTwo as Int)
endFunction

Float Function getAbsFloatDiff(Float valueOne, Float valueTwo) global
	return math.abs(math.abs(valueOne) - math.abs(valueTwo))
endFunction

Bool Function isFloatWithin(Float value, Float valueMin, Float valueMax) global
	return value >= valueMin && value <= valueMax
endFunction	