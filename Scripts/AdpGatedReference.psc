Scriptname AdpGatedReference extends AdpObjectReference 

Import  AdpUtils

;-----------------------------------------------------------------------------@[props]

AdpLogicGate Property LogicGate Auto Hidden
Bool Property IsActivated = False Auto Hidden
Bool Property InitiallyActivated = False Auto
Bool Property NonBlockingActivate = False Auto Hidden

;-----------------------------------------------------------------------------@[methods]

Function setDefaultRef()
	parent.setDefaultRef()
	self.gateConnect()
endFunction

Function toggleSelfActivated()
	IF ! self.IsActivated
		self.IsActivated = True	
	ELSE
		self.IsActivated = False
	ENDIF
EndFunction

Function activateNoWait(AdpGatedReference activatorRef)
	self.NonBlockingActivate = True
	self.activate(activatorRef)
endFunction

Function  timedActivationBlock(Float seconds)
	IF ! self.NonBlockingActivate
		self.BlockActivation(True)
		String previousFormName = self.getFormName()
		self.setFormName()
		utility.wait(seconds)
		self.setFormName(previousFormName)
		self.BlockActivation(False)
	ENDIF
	self.NonBlockingActivate = False
endFunction

Function gateConnect()
	IF ! self.LogicGate
		self.LogicGate =  self.GetLinkedRef() as AdpLogicGate
		IF self.LogicGate.isAdpLogicGate()
			IF self.InitiallyActivated
				self.LogicGate.InitiallyActivated = True
			ENDIF
			self.DefaultRef = self.LogicGate
		ENDIF	
	ENDIF
	IF self.LogicGate && ! self.LogicGate.isFunctional()
		self.LogicGate.connect(self)
	ENDIF
endFunction 
