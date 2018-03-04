Scriptname AdpSingleObjectTranslator extends AdpTranslatedReference

import AdpUtils

;-----------------------------------------------------------------------------@[props]

Bool Property ShareProperties = False Auto
ObjectReference  Property ObjectRef Auto Hidden

;-----------------------------------------------------------------------------@[methods]

Function setObjectRef()
	IF ! self.ObjectRef
		Keyword adpKeyword = Keyword.GetKeyword("AdpObjectRef0")
		self.ObjectRef = self.GetLinkedRef(adpKeyword) as ObjectReference
	ENDIF
endFunction

;-----------------------------------------------------------------------------@[events]

Event onLoad()
	self.setObjectRef()
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
			self.NextMarker.ObjectRef = self.ObjectRef
			IF self.ShareProperties
				self.setNextMarkerProps()
			ENDIF	
			self.NextMarker.activate(self)
		ENDIF
	endEvent
	Event onActivate (ObjectReference triggerRef)
	endEvent	
endState

