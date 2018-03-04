Scriptname AdpTestGate extends AdpLogicGate

import  AdpUtils

Bool Function getOutput()
	return self.Input0.IsActivated && self.Input1.IsActivated
endFunction
