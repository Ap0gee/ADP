Scriptname AdpTestScript extends AdpObjectReference  

import AdpUtils

Event onLoad()
  	RegisterForUpdate(0.25)  
endEvent

Event onUpdate()
endEvent

auto State waiting
	Event onBeginState()
	endEvent
	Event onActivate(ObjectReference triggerRef)
	endEvent
	Event onTriggerEnter(ObjectReference triggerRef)
		debug.Trace("*" + triggerRef)
	endEvent
endState 