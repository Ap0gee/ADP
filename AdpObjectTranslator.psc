Scriptname AdpObjectTranslator extends AdpTranslatedReference

import debug
import utility

;-----------------------------------------------------------------------------@[props]

Keyword Property AdpObjectRef0 Auto Hidden

;-----------------------------------------------------------------------------@[methods]

Function setDefaultRefs()
	IF ! self.NextMarker
		self.NextMarker  =  self.GetLinkedRef() as AdpTranslationMarker
	ENDIF
endFunction

Function setObjectRefs()
	IF ! self.ObjectRef
		self.ObjectRef = self.GetLinkedRef(AdpObjectRef0) as ObjectReference
	ENDIF
endFunction	

;-----------------------------------------------------------------------------@[events]

Event onLoad()
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
		IF self.NextMarker && self.ObjectRef
			self.NextMarker.setObjectRef(self.ObjectRef)
			self.NextMarker.pullObjectRef()
		ENDIF
	endEvent
	Event onActivate (ObjectReference triggerRef)
	endEvent	
endState

