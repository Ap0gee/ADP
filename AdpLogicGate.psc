Scriptname AdpLogicGate extends AdpGatedReference

import  AdpUtils

;-----------------------------------------------------------------------------@[props]

AdpGatedReference Property Input0 Auto Hidden
AdpGatedReference Property Input1 Auto Hidden

;-----------------------------------------------------------------------------@[methods]

;@override
Bool Function getOutput()	
endFunction

;@override
Bool Function isFunctional()
	return self.Input0 && self.Input1
endFunction

Bool Function isAdpLogicGate()
	return True
endFunction

Function connect(AdpGatedReference _input)
	IF ! self.Input0
		self.Input0 = _input

	ELSE
		IF ! self.Input1 && self.Input0 != _input
			self.Input1 = _input
		ENDIF
	ENDIF
endFunction

;-----------------------------------------------------------------------------@[events]

Event onLoad()
	self.setDefaultRef()
endEvent

;-----------------------------------------------------------------------------@[states]

auto State waiting
	Event onBeginState()
	endEvent
	Event onActivate (ObjectReference triggerRef)
		goToState("busy")
	endEvent
endState

State busy
	Event onBeginState()
		IF self.getOutput()
			self.activateDefaultRef(self)
		ELSE 
			IF self.DefaultRefActivated
				self.activateDefaultRef(self)	
			ENDIF
		ENDIF	
		adpDebug(self + "busy@onBeginState: getOutput=" + self.getOutput(), enabled=self.ShowDebug)
		GoToState("waiting")
	endEvent
	Event onActivate (ObjectReference triggerRef)
	endEvent	
endState


