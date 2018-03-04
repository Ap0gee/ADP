Scriptname AdpActionDelayer extends AdpObjectReference  

import AdpUtils

;-----------------------------------------------------------------------------@[props]

Bool  Property EnableInstead = False Auto 
Bool  Property WaitingForInput = True Auto Hidden
Float Property ActionDelaySeconds = 0.0 Auto 

;-----------------------------------------------------------------------------@[events]

Event  onLoad()
	self.setDefaultRef()
EndEvent

;-----------------------------------------------------------------------------@[states]

auto State waiting
	Event onBeginState()
	endEvent
	Event onActivate (ObjectReference triggerRef)
		GoToState("busy")
	endEvent	
endState

State busy
	Event onBeginState()
		delay(self.ActionDelaySeconds)
		IF ! self.EnableInstead
			self.DefaultRef.activate(self)
		Else
			self.DefaultRef.Enable()
		ENDIF
		GoToState("waiting")		
	endEvent
	Event onActivate (ObjectReference triggerRef)
	endEvent	
endState
