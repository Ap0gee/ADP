Scriptname AdpOneObjectEnableToggle extends ObjectReference  

ObjectReference Property EnableRef Auto Hidden
Bool Property WaitForAnimation = True Auto

Function setEnableRef()
	IF ! self.EnableRef
		self.EnableRef =  self.GetLinkedRef()		
	ENDIF
endFunction	

Event OnInit()
    	self.setEnableRef()
EndEvent

auto State waiting
	Event onBeginState()
	endEvent
	Event onActivate(ObjectReference triggerRef)
		IF  self.EnableRef.isDisabled()
			self.EnableRef.Enable(self.WaitForAnimation)
		ELSE
			self.EnableRef.Disable(self.WaitForAnimation)
		ENDIF
	endEvent
endState
