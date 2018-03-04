Scriptname AdpActivator extends AdpGatedReference

import  AdpUtils 

;-----------------------------------------------------------------------------@[props]

Bool Property ActivateOnce = False Auto 
ObjectReference[] Property EnableRefs Auto Hidden
ObjectReference[] Property ActivateRefs Auto Hidden
Float Property EnableActivationDelay = 2.0 AutoReadOnly Hidden

;-----------------------------------------------------------------------------@[methods]

Function toggleRefArrayEnabled(ObjectReference[]  objectRefArray)
	IF ! self.IsActivated
		self.disableRefArray(objectRefArray)
	ElSE
		self.enableRefArray(objectRefArray)
	ENDIF
endFunction

Function setEnableRefs()
	IF ! self.EnableRefs.Length
		self.EnableRefs = getLinkedRefArray("AdpEnableRef")
	ENDIF
endFunction

Function setActiavteRefs()
	IF ! self.ActivateRefs.Length
		self.ActivateRefs = getLinkedRefArray("AdpActivateRef")
	ENDIF
endFunction
;-----------------------------------------------------------------------------@[events]

Event onLoad()
	self.setEnableRefs()
	self.setActiavteRefs()
	
	self.setDefaultRef()
	IF self.InitiallyActivated
		self.activateNoWait(self)	
	ENDIF
endEvent

Event onTriggerEnter(ObjectReference triggerRef)
	self.activate(self)
endEvent

;-----------------------------------------------------------------------------@[states]

auto State waiting
	Event onBeginState()
	endEvent
	Event onActivate (ObjectReference triggerRef)
		self.toggleSelfActivated()
		adpDebug(self + "waiting@onActivate: IsActivated=" + self.IsActivated, enabled=self.ShowDebug)
		GoToState("busy")
	endEvent
endState

State busy
	Event onBeginState()
		self.activateIfSet(self.DefaultRef, self)
		self.activateRefArray(self.ActivateRefs)
		self.toggleRefArrayEnabled(self.EnableRefs)
		
		self.timedActivationBlock(self.EnableActivationDelay)
		
		IF ! self.ActivateOnce
			GoToState("waiting")
		ENDIF
	endEvent
	Event onActivate (ObjectReference triggerRef)
	endEvent	
endState

