Scriptname AdpTranslatedReference extends AdpObjectReference

import AdpUtils

AdpTranslationMarker Property NextMarker Auto Hidden
Bool Property Translating = False Auto Hidden
Float Property Speed = 0.0 Auto
Float Property MaxRotationSpeed = 0.1 Auto
Float Property TangentMagnitude = 0.0 Auto
AdpTranslatedReference Property ControllerRef Auto Hidden 
Bool Property AbortedTranslation = False Auto Hidden
AdpTranslationMarker Property CurrentMarker Auto Hidden

Function setDefaultRef()
	parent.setDefaultRef()
	IF ! self.NextMarker
		self.NextMarker  =  self.GetLinkedRef() as AdpTranslationMarker
		IF self.NextMarker.getTranslatedRefType() == "AdpTranslationMarker"
			self.DefaultRef = self.NextMarker
		ENDIF	
	ENDIF
endFunction

String Function getTranslatedRefType()
	return "AdpTranslatedReferenceBase"
endFunction	

Function abortTranslation()
	self.AbortedTranslation = True
endFunction

Function enableTranslation()
	self.AbortedTranslation = False
endFunction	

Function setControllerRef(AdpTranslatedReference controllerRef)
	self.ControllerRef = controllerRef
endFunction	

Function setCurrentMarker(AdpTranslationMarker markerRef)
	self.CurrentMarker = markerRef
endFunction

Function setNextMarkerProps()
	IF self.NextMarker.InheritProperties
		self.NextMarker.Speed = self.Speed
		self.NextMarker.MaxRotationSpeed = self.MaxRotationSpeed
		self.NextMarker.TangentMagnitude = self.TangentMagnitude
	ENDIF
	self.NextMarker.ControllerRef = self.ControllerRef	
endFunction

Bool Function isXYZPosEqual(ObjectReference objectRef)
	return self.GetDistance(objectRef) == 0.0
endFunction 	

Bool Function rotValuesMatched(Float objectRotation, Float markerRotation)
	return absFloatsEqual(objectRotation, markerRotation) || math.abs(objectRotation) == getAbsFloatDiff(360.00, markerRotation)
endFunction

Bool Function isRotationEqual(ObjectReference objectRef)
	return  self.rotValuesMatched(objectRef.GetAngleX(), self.GetAngleX()) && self.rotValuesMatched(objectRef.GetAngleY(), self.GetAngleY()) && self.rotValuesMatched(objectRef.GetAngleZ(), self.GetAngleZ())
endFunction

Function pollObjectXYZ()
	self.Translating = True 
	GoToState("pollingXYZ")
endFunction

Function pollObjectRotation()
	self.Translating = True 
	GoToState("pollingRotation")
endFunction	
