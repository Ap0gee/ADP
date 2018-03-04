Scriptname AdpObjectReference extends ObjectReference

Import  AdpUtils

;-----------------------------------------------------------------------------@[props]

ObjectReference Property DefaultRef Auto Hidden
Bool Property DefaultRefActivated = False  Auto Hidden
Int  Property MaxRefTypeCount = 10 AutoReadOnly Hidden
Bool  Property ShowDebug = False Auto 

;-----------------------------------------------------------------------------@[methods]
Function setDefaultRef()
	IF ! self.DefaultRef 
		self.DefaultRef  =  self.GetLinkedRef() 
	ENDIF
endFunction

Function toggleDefaultRefActivated()
	IF ! self.DefaultRefActivated
		self.DefaultRefActivated = True	
	ELSE
		self.DefaultRefActivated = False
	ENDIF
endFunction

Function setRefEnabledState(ObjectReference objectRef, Bool enabled=True, Bool allowFade=False)
	IF ! enabled
		objectRef.Disable(allowFade)
	ELSE
		objectRef.Enable(allowFade)
	ENDIF		
endFunction

Function resetObjectCollision(ObjectReference objectRef)
	self.setRefEnabledState(objectRef, False, False)
	self.setRefEnabledState(objectRef, True, False)
endFunction	

Function setRefMotionType(ObjectReference objectRef, Int motionType, Bool allowActivate)
	objectRef.SetMotionType(motionType, allowActivate)
endFunction 	

Function toggleDefaultRefEnabled(Bool allowFade=False)
	IF ! self.DefaultRefActivated
		self.setRefEnabledState(self.DefaultRef, True, allowFade)
	ELSE
		self.setRefEnabledState(self.DefaultRef, False, allowFade)
	ENDIF
endFunction

Function activateDefaultRef(ObjectReference activatorRef)
	self.toggleDefaultRefActivated()
	self.activateIfSet(self.DefaultRef, activatorRef)
endFunction

Function activateIfSet(ObjectReference objectRef, ObjectReference activatorRef)
	IF objectRef
		objectRef.activate(activatorRef)
	ENDIF
endFunction

ObjectReference[] Function getLinkedRefArray(String adpKeywordStr)
	ObjectReference[]  attachedRefs = new ObjectReference[10]
	Int refCount = self.MaxRefTypeCount
	WHILE(refCount  > 0)
		String strKeyword = adpKeywordStr + "" + (refCount  - 1)
		Keyword dynKeyword = Keyword.GetKeyword(strKeyword) 
		ObjectReference linkedRef = self.GetLinkedRef(dynKeyword) 
		IF linkedRef  != self.DefaultRef
			Int  eIndex = attachedRefs.Find(None)
			attachedRefs[eIndex] = linkedRef
		ENDIF
		refCount  -= 1
	ENDWHILE
	return attachedRefs	
endFunction

Function enableRefArray(ObjectReference[] objectRefArray, Bool allowFade=False)
	Int refCount = objectRefArray.Length
	WHILE (refCount > 0)
		Int index = refCount - 1
		ObjectReference enableRef = objectRefArray[index] 
		enableRef.Enable(allowFade)
		refCount -= 1
	ENDWHILE
endFunction

Function disableRefArray(ObjectReference[] objectRefArray, Bool allowFade=False)
	Int refCount = objectRefArray.Length
	WHILE (refCount > 0)
		Int index = refCount - 1
		ObjectReference enableRef = objectRefArray[index]
		enableRef.Disable(allowFade)
		refCount -= 1
	ENDWHILE
endFunction

Function activateRefArray(ObjectReference[] objectRefArray)
	Int refCount = objectRefArray.Length
	WHILE (refCount > 0)
		Int index = refCount - 1
		ObjectReference enableRef = objectRefArray[index]
		enableRef.activate(self)
		refCount -= 1
	ENDWHILE
endFunction

Function setFormName(String name="")
	Form  refForm =  self.GetBaseObject()
	refForm .SetName(name)
endFunction

String Function getFormName()
	Form  refForm =  self.GetBaseObject()
	return refForm.GetName()
endFunction

Float[] Function getXYZPositionArray(ObjectReference objectRef)
	Float[] posArray = new Float[3]
	posArray[0] = objectRef.X
	posArray[1] = objectRef.Y
	posArray[2] = objectRef.Z
	return posArray
endFunction	