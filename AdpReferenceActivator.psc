Scriptname AdpReferenceActivator extends AdpActivator

;-----------------------------------------------------------------------------@[props]

ObjectReference Property DefaultRef Auto Hidden

;-----------------------------------------------------------------------------@[methods]

Function setDefaultRef()
	IF ! self.DefaultRef
		self.DefaultRef =  self.GetLinkedRef() 	
	ENDIF
endFunction 

;-----------------------------------------------------------------------------@[events]

Event onPreInit()
	self.setDefaultRef()
EndEvent

Event onActivated()
	self.DefaultRef.activate(self)
endEvent

Event onBusy()
Endevent

;-----------------------------------------------------------------------------@[states]
