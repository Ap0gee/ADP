Scriptname AdpReferenceActivator extends AdpActivator

;-----------------------------------------------------------------------------@[props]

;-----------------------------------------------------------------------------@[methods]

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
