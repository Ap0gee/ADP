Scriptname AdpMultiObjectTranslator extends AdpTranslatedReference  

import AdpUtils

;-----------------------------------------------------------------------------@[props]

Bool Property ShareProperties = False Auto
ObjectReference[]  Property ObjectRefs Auto Hidden
Float[] Property XPositionOffsets Auto Hidden
Float[] Property YPositionOffsets Auto Hidden
Float[] Property ZPositionOffsets Auto Hidden

;-----------------------------------------------------------------------------@[methods]

Function setObjectRefs()
	IF ! self.ObjectRefs
		self.ObjectRefs = self.getLinkedRefArray("AdpObjectRef")
	ENDIF
endFunction

Function mapPositionOffsets()
	self.XPositionOffsets = new Float[10]
	self.YPositionOffsets = new Float[10]
	self.ZPositionOffsets = new Float[10]
	Int refCount = self.ObjectRefs.Length
	WHILE refCount > 0
		ObjectReference objectRef = self.ObjectRefs[refCount]
		Float[] posArrary =  self.getXYZPositionArray(objectRef)
		self.XPositionOffsets[refCount] = posArrary[0]
		self.YPositionOffsets[refCount] = posArrary[1]
		self.ZPositionOffsets[refCount] = posArrary[2]
	ENDWHILE	
endFunction

Bool Function isMultiObjectTranslator()
	return True
EndFunction

Bool Function isTranslationComplete()
endFunction

;-----------------------------------------------------------------------------@[events]

Event onLoad()
	self.setObjectRefs()
	self.mapPositionOffsets()
	self.setDefaultRef()
EndEvent

Event onTranslationComplete()
endEvent	

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
		IF self.NextMarker && self.ObjectRefs
			self.NextMarker.ObjectRef = self
			IF self.ShareProperties
				self.setNextMarkerProps()
			ENDIF
			self.NextMarker.activate(self)
			GoToState("translating")
		ENDIF
	endEvent
	Event onActivate (ObjectReference triggerRef)
	endEvent	
endState

State translating
	Event onBeginState()
		self.Translating = True
	endEvent
	Event onActivate (ObjectReference triggerRef)
		IF ! self.Translating
			;perform calcs, set new markers, activate them
			;foreach object place at me a marker, translate to calculated pos with high speed.
			; pass each marker the corrisponding object ref, and activate it.
			GoToState("polling")
		ENDIF	
	endEvent	
endState

State polling 
	Event onBeginState()
		WHILE ! self.Translating	
			IF self.isTranslationComplete()
				self.onTranslationComplete()
				GoToState("translating")
			ENDIF
		ENDWHILE	
	EndEvent
endState



