Scriptname AdpTranslationMarker extends AdpTranslatedReference 

import AdpUtils

;-----------------------------------------------------------------------------@[props]

Bool Property ShareProperties = True Auto
Bool Property InheritProperties =True Auto
Bool Property NoRotateUntilArrival = False Auto
Float Property WaitOnArrivalSeconds Auto
ObjectReference Property ObjectRef Auto Hidden
ObjectReference Property ActivateRef Auto Hidden
Bool Property CSFadeTo = False auto 
ImageSpaceModifier Property FadeTo Auto Hidden
ImageSpaceModifier Property FadeFrom Auto Hidden

;-----------------------------------------------------------------------------@[methods]
String Function getTranslatedRefType()
	return "AdpTranslationMarker"
endFunction

Function setActivateRef()
	IF ! self.ActivateRef
		Keyword adpKeyword = Keyword.GetKeyword("AdpActivateRef0")
		self.ActivateRef = self.GetLinkedRef(adpKeyword) as ObjectReference
	ENDIF
endFunction

Function pullObjectRef()
	IF CSFadeTo
		self.fadeObjectToSelf(1.0)
	ELSE
		self.translateObjectToSelf()
		self.pollObjectXYZ()
	ENDIF	
endFunction

Function fadeOut(float time)
	FadeTo.Apply()
	delay(time)
	Game.FadeOutGame(False,True,50, 1)
endFunction

Function fadeIn(float time)
	delay(time)
	Game.FadeOutGame(False,True,0.1, 0.1)
	FadeTo.PopTo(FadeFrom)
endFunction

Function translateObjectToSelf()
	IF ! self.TangentMagnitude
		self.ObjectRef.TranslateToRef(self, self.Speed, self.MaxRotationSpeed)
	ELSE	
		self.ObjectRef.SplineTranslateToRef(self, self.TangentMagnitude, self.Speed, self.MaxRotationSpeed)
	ENDIF
endFunction

Function fadeObjectToSelf(float time)
	fadeOut(time)
	self.ObjectRef.MoveTo(self, abMatchRotation=True)
	fadeIn(time)
	onTranslationComplete()
endFunction	

Function rotateObjectToSelf()	
	self.ObjectRef.TranslateToRef(self, self.Speed, self.MaxRotationSpeed)
endFunction 	

Bool Function isXYZTranslationComplete()
	return self.isXYZPosEqual(self.ObjectRef)
endFunction 

Bool Function isRotationTranslationComplete()
	return self.isRotationEqual(self.ObjectRef)
endFunction

Bool Function isTranslationComplete()
	return self.isXYZTranslationComplete() && self.isRotationTranslationComplete()
endFunction

Function maskObjectCollisionReset(ObjectReference objectRef)
	Float refScale = ObjectRef.GetScale()
	ObjectReference objectRefMask = self.ObjectRef.PlaceAtMe(objectRef.GetBaseObject())
	objectRefMask.SetScale(refScale) 
	delay(1.0)
	self.setRefEnabledState(objectRef, False)
	delay(0.25)
	self.setRefEnabledState(objectRef, True)
	delay(0.5)
	objectRefMask.Delete()
endFunction

ObjectReference Function placeCopy(ObjectReference objectRef)
	Float refScale = objectRef.GetScale()
	ObjectReference objectRefCopy = self.ObjectRef.PlaceAtMe(objectRef.GetBaseObject())
	objectRefCopy.SetScale(refScale)
	return objectRefCopy
endFunction	

;-----------------------------------------------------------------------------@[events]

Event  onLoad()
	self.setActivateRef()
	self.setDefaultRef()
EndEvent

Event onXYZComplete()
	IF ! self.NoRotateUntilArrival
		self.onTranslationComplete()
	ELSE
		self.rotateObjectToSelf()
		self.pollObjectRotation()
	ENDIF	
endEvent

Event onRotationComplete()
	self.onTranslationComplete()
endEvent	

Event onAbort()
	self.Translating = False
	GoToState("waiting")
endEvent

Event onTranslationComplete()
	self.Translating = False
	AdpMultiObjectTranslator castedRef = self.ControllerRef as AdpMultiObjectTranslator
	IF castedRef.isMultiObjectTranslator()
		castedRef.Translating = False
		castedRef.activate(self)
	ELSE
		IF self.ActivateRef
			self.ActivateRef.activate(self)
		ENDIF			
	ENDIF
	IF self.WaitOnArrivalSeconds
		delay(self.WaitOnArrivalSeconds)
	ENDIF
	IF ! self.ControllerRef.AbortedTranslation
		IF self.NextMarker && self.ObjectRef
			self.NextMarker.ObjectRef = self.ObjectRef 
			IF self.ShareProperties
				self.setNextMarkerProps()
			ENDIF
			self.NextMarker.activate(self)
		ELSE
			IF self.DefaultRef	
				self.DefaultRef.activate(self)
			ENDIF
			IF self.ControllerRef.getTranslatedRefType() != "AdpCutSceneCreator"
				IF ! self.NoCollisionReset
					self.maskObjectCollisionReset(self.ObjectRef)
				ENDIF	
			ENDIF		
		ENDIF
	ENDIF
	GoToState("waiting")
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
		self.ControllerRef.setCurrentMarker(self)
		self.pullObjectRef()
	endEvent
	Event onActivate (ObjectReference triggerRef)
	endEvent	
endState

State pollingXYZ 
	Event onBeginState()
		RegisterForSingleUpdate(0.25)
	EndEvent
	Event OnUpdate()
		IF ! self.ControllerRef.AbortedTranslation
			IF self.Translating
				IF self.isXYZTranslationComplete()
					self.onXYZComplete()	
				ENDIF
				RegisterForSingleUpdate(0.25)
			ENDIF
		ELSE
			self.onAbort()
		ENDIF		
	endEvent
endState

State pollingRotation
	Event onBeginState()
		RegisterForSingleUpdate(0.25)
	EndEvent
	Event OnUpdate()
		IF ! self.ControllerRef.AbortedTranslation
			IF self.Translating
				IF self.isRotationTranslationComplete()
					self.onRotationComplete()
				ENDIF
				RegisterForSingleUpdate(0.25)
			ENDIF
		ELSE
			self.onAbort()
		ENDIF		
	endEvent
endState

